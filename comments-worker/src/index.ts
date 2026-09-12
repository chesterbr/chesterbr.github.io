/**
 * chester's blog - static comments intake Worker.
 *
 * Successor to the old self-hosted Staticman. Receives the comment form POST,
 * runs a layered spam pipeline, and writes the comment into the blog repo in the
 * same `_data/comments/{slug}/entry{ts}.yml` format Staticman used, so all the
 * existing Jekyll includes keep rendering unchanged.
 *
 * Pipeline (see README.md for the full table):
 *   door:    honeypot + min-fill-time + Cloudflare Turnstile  -> silent drop / 400
 *   filter:  Akismet, then Claude (Haiku) as second opinion
 *   outcome: publish (commit to main) | pr (open PR) | reject (log, no publish)
 *
 * Behaviour is driven by non-secret vars in wrangler.jsonc (MODERATION_MODE,
 * CLAUDE_ON, ...), so the moderation policy is a config change + redeploy, not a
 * code edit.
 */

export interface Env {
  // Secrets (set via `wrangler secret put NAME`, never committed):
  GITHUB_TOKEN: string; // fine-grained PAT: contents+pull_requests, this repo only
  TURNSTILE_SECRET: string;
  AKISMET_KEY: string;
  ANTHROPIC_API_KEY: string;

  // Non-secret config (wrangler.jsonc `vars`):
  REPO_OWNER: string;
  REPO_NAME: string;
  REPO_BRANCH: string;
  SITE_URL: string;
  ALLOWED_ORIGIN: string;
  AKISMET_SITE: string;
  MODERATION_MODE: string; // "auto" (auto-publish clean) | "pr_all" (everything -> PR)
  CLAUDE_ON: string; // "flagged_only" (Claude only when Akismet flags) | "always"
  CLAUDE_MODEL: string; // e.g. "claude-haiku-4-5"
  MIN_SECONDS: string; // reject submissions faster than this many seconds
}

interface CommentFields {
  name: string;
  email: string; // raw, used only for Akismet + hashing; never stored raw
  message: string;
  replying_to_uid: string;
  slug: string;
  post_url: string;
}

type Verdict = "spam" | "ham" | "unsure";
type Outcome = "publish" | "pr" | "reject";

const jsonHeaders = { "content-type": "application/json" };

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    if (request.method === "OPTIONS") return cors(env, new Response(null, { status: 204 }));
    if (request.method !== "POST") return reply(env, 405, { errorCode: "method" });

    let form: FormData;
    try {
      form = await request.formData();
    } catch {
      return reply(env, 400, { errorCode: "bad_request" });
    }

    const fields: CommentFields = {
      name: str(form.get("name")).slice(0, 100),
      email: str(form.get("email")).slice(0, 200),
      message: str(form.get("message")).slice(0, 8000),
      replying_to_uid: str(form.get("replying_to_uid")).slice(0, 40),
      slug: sanitizeSlug(str(form.get("slug"))),
      post_url: str(form.get("post_url")).slice(0, 300),
    };

    // Required fields.
    if (!fields.name || !fields.message || !fields.slug) {
      return reply(env, 400, { errorCode: "missing_fields" });
    }

    // --- Door: cheap bot filters that never reach a human or a commit ---

    // Honeypot: real users leave it blank. Pretend success so bots don't learn.
    if (str(form.get("hp"))) return reply(env, 200, { ok: true });

    // Min fill time: bots submit instantly.
    const minMs = (parseInt(env.MIN_SECONDS, 10) || 0) * 1000;
    const ts = parseInt(str(form.get("ts")), 10);
    if (minMs > 0 && Number.isFinite(ts) && Date.now() - ts < minMs) {
      return reply(env, 200, { ok: true });
    }

    // Turnstile: the main automated-spam wall.
    const ip = request.headers.get("CF-Connecting-IP") || "";
    const ua = request.headers.get("User-Agent") || "";
    const turnstileToken = str(form.get("cf-turnstile-response"));
    if (!(await verifyTurnstile(env, turnstileToken, ip))) {
      return reply(env, 400, { errorCode: "captcha" });
    }

    // --- Filter: Akismet, then Claude as configured ---

    let akismetSpam = false;
    let akismetDiscard = false;
    try {
      const a = await akismetCheck(env, fields, ip, ua);
      akismetSpam = a.spam;
      akismetDiscard = a.discard;
    } catch {
      // On Akismet failure, route to human review rather than trust or reject.
      akismetSpam = true;
    }

    let claude: { verdict: Verdict; reason: string } | null = null;
    if (env.CLAUDE_ON === "always" || akismetSpam) {
      try {
        claude = await claudeClassify(env, fields);
      } catch {
        claude = { verdict: "unsure", reason: "classifier unavailable" };
      }
    }

    let outcome = decide(akismetSpam, claude?.verdict ?? null);
    if (env.MODERATION_MODE === "pr_all" && outcome === "publish") outcome = "pr";

    // --- Act ---
    try {
      if (outcome === "reject") {
        await writeRejected(env, fields, akismetSpam, akismetDiscard, claude);
      } else {
        await writeComment(env, fields, outcome);
      }
    } catch (e) {
      console.log("write failed", outcome, String(e));
      return reply(env, 500, { errorCode: "server" });
    }

    // Rejected looks like success to the submitter (don't tip off spammers).
    return reply(env, 200, { ok: true, status: outcome });
  },
} satisfies ExportedHandler<Env>;

/** Combine the two filters into one outcome. Conservative: disagreement -> human. */
function decide(akismetSpam: boolean, claude: Verdict | null): Outcome {
  if (!akismetSpam) {
    // Akismet clean. Only reached Claude if CLAUDE_ON=always.
    if (claude === "spam") return "pr"; // catch Akismet false-negative, don't auto-publish
    if (claude === "unsure") return "pr";
    return "publish";
  }
  // Akismet flagged spam -> Claude has run.
  if (claude === "spam") return "reject";
  return "pr"; // Claude says ham (disagreement) or unsure -> human decides
}

// --- Spam services -------------------------------------------------------

async function verifyTurnstile(env: Env, token: string, ip: string): Promise<boolean> {
  if (!token) return false;
  const body = new URLSearchParams({ secret: env.TURNSTILE_SECRET, response: token });
  if (ip) body.set("remoteip", ip);
  const res = await fetch("https://challenges.cloudflare.com/turnstile/v0/siteverify", {
    method: "POST",
    body,
  });
  const data = (await res.json()) as { success?: boolean };
  return data.success === true;
}

async function akismetCheck(
  env: Env,
  f: CommentFields,
  ip: string,
  ua: string,
): Promise<{ spam: boolean; discard: boolean }> {
  const body = new URLSearchParams({
    blog: env.AKISMET_SITE,
    user_ip: ip,
    user_agent: ua,
    comment_type: "comment",
    comment_author: f.name,
    comment_content: f.message,
    permalink: f.post_url,
    blog_lang: "pt,en",
  });
  if (f.email) body.set("comment_author_email", f.email);

  const res = await fetch(`https://${env.AKISMET_KEY}.rest.akismet.com/1.1/comment-check`, {
    method: "POST",
    headers: { "User-Agent": "chester-comments/1.0" },
    body,
  });
  const text = (await res.text()).trim();
  if (text === "true") {
    return { spam: true, discard: res.headers.get("X-akismet-pro-tip") === "discard" };
  }
  if (text === "false") return { spam: false, discard: false };
  // "invalid" or anything unexpected -> treat as an Akismet failure.
  throw new Error(`akismet: ${text}`);
}

async function claudeClassify(
  env: Env,
  f: CommentFields,
): Promise<{ verdict: Verdict; reason: string }> {
  const system =
    "You are a spam filter for comments on a personal tech / retro-computing blog. " +
    "Comments may be in Portuguese or English and are often short, casual, or nostalgic. " +
    "Legitimate comments can be brief ('great post!', 'valeu!') or off-topic-ish reminiscing. " +
    "Spam is commercial promotion, SEO link-dropping, gibberish, or unrelated bulk content. " +
    'Respond with ONLY compact JSON: {"verdict":"spam"|"ham"|"unsure","reason":"<short>"}. ' +
    "Use 'unsure' only when genuinely ambiguous.";
  const user = `Author: ${f.name}\n\nComment:\n${f.message}`;

  const res = await fetch("https://api.anthropic.com/v1/messages", {
    method: "POST",
    headers: {
      "x-api-key": env.ANTHROPIC_API_KEY,
      "anthropic-version": "2023-06-01",
      "content-type": "application/json",
    },
    body: JSON.stringify({
      model: env.CLAUDE_MODEL,
      max_tokens: 200,
      system,
      messages: [{ role: "user", content: user }],
    }),
  });
  if (!res.ok) throw new Error(`anthropic ${res.status}`);
  const data = (await res.json()) as { content?: Array<{ type: string; text?: string }> };
  const text = (data.content || []).find((b) => b.type === "text")?.text || "";
  const match = text.match(/\{[\s\S]*\}/);
  if (!match) throw new Error("no json in classifier reply");
  const parsed = JSON.parse(match[0]) as { verdict?: string; reason?: string };
  const verdict: Verdict =
    parsed.verdict === "spam" || parsed.verdict === "ham" ? parsed.verdict : "unsure";
  return { verdict, reason: (parsed.reason || "").slice(0, 300) };
}

// --- Writing to the repo -------------------------------------------------

async function writeComment(env: Env, f: CommentFields, outcome: Outcome): Promise<void> {
  const id = Date.now();
  const date = Math.floor(id / 1000);
  const emailHash = await sha256Hex(f.email.trim().toLowerCase());
  const yaml = [
    `_id: ${id}`,
    `_parent: ${js(f.post_url)}`,
    `replying_to_uid: ${js(f.replying_to_uid)}`,
    `message: ${js(f.message)}`,
    `name: ${js(f.name)}`,
    `email: ${js(emailHash)}`,
    `hp: ''`,
    `date: ${date}`,
    "",
  ].join("\n");

  const path = `_data/comments/${f.slug}/entry${id}.yml`;
  if (outcome === "publish") {
    await ghPutFile(env, path, yaml, `Comment by ${f.name} on ${f.slug}`, env.REPO_BRANCH);
    return;
  }
  // outcome === "pr"
  const branch = `comments/${f.slug}-${id}`;
  const baseSha = await ghRefSha(env, env.REPO_BRANCH);
  await ghCreateRef(env, branch, baseSha);
  await ghPutFile(env, path, yaml, `Comment by ${f.name} on ${f.slug}`, branch);
  await ghCreatePr(
    env,
    `Comment by ${f.name} on ${f.slug}`,
    branch,
    `New comment awaiting review on **${f.slug}**.\n\nAuthor: ${f.name}\nPost: ${f.post_url}`,
  );
}

async function writeRejected(
  env: Env,
  f: CommentFields,
  akismetSpam: boolean,
  akismetDiscard: boolean,
  claude: { verdict: Verdict; reason: string } | null,
): Promise<void> {
  const id = Date.now();
  const date = Math.floor(id / 1000);
  const emailHash = await sha256Hex(f.email.trim().toLowerCase());
  // Public repo: store only what a published comment would show (name, message,
  // email hash) plus the spam verdicts. No raw email / IP.
  const yaml = [
    `_id: ${id}`,
    `_parent: ${js(f.post_url)}`,
    `slug: ${js(f.slug)}`,
    `replying_to_uid: ${js(f.replying_to_uid)}`,
    `message: ${js(f.message)}`,
    `name: ${js(f.name)}`,
    `email: ${js(emailHash)}`,
    `date: ${date}`,
    `akismet: ${akismetSpam ? "spam" : "ham"}`,
    `akismet_discard: ${akismetDiscard}`,
    `claude_verdict: ${js(claude?.verdict ?? "not_run")}`,
    `claude_reason: ${js(claude?.reason ?? "")}`,
    "",
  ].join("\n");
  const path = `comments-rejected/${f.slug}/entry${id}.yml`;
  await ghPutFile(env, path, yaml, `Rejected comment by ${f.name} on ${f.slug}`, env.REPO_BRANCH);
}

// --- GitHub REST helpers -------------------------------------------------

function ghHeaders(env: Env): HeadersInit {
  return {
    Authorization: `Bearer ${env.GITHUB_TOKEN}`,
    Accept: "application/vnd.github+json",
    "X-GitHub-Api-Version": "2022-11-28",
    "User-Agent": "chester-comments-worker",
    "content-type": "application/json",
  };
}

function repoApi(env: Env, path: string): string {
  return `https://api.github.com/repos/${env.REPO_OWNER}/${env.REPO_NAME}${path}`;
}

async function ghPutFile(
  env: Env,
  path: string,
  content: string,
  message: string,
  branch: string,
): Promise<void> {
  const res = await fetch(repoApi(env, `/contents/${encodePath(path)}`), {
    method: "PUT",
    headers: ghHeaders(env),
    body: JSON.stringify({ message, content: toBase64(content), branch }),
  });
  if (!res.ok) throw new Error(`github put ${res.status}: ${await res.text()}`);
}

async function ghRefSha(env: Env, branch: string): Promise<string> {
  const res = await fetch(repoApi(env, `/git/ref/heads/${branch}`), { headers: ghHeaders(env) });
  if (!res.ok) throw new Error(`github ref ${res.status}`);
  const data = (await res.json()) as { object: { sha: string } };
  return data.object.sha;
}

async function ghCreateRef(env: Env, branch: string, sha: string): Promise<void> {
  const res = await fetch(repoApi(env, "/git/refs"), {
    method: "POST",
    headers: ghHeaders(env),
    body: JSON.stringify({ ref: `refs/heads/${branch}`, sha }),
  });
  if (!res.ok) throw new Error(`github create ref ${res.status}: ${await res.text()}`);
}

async function ghCreatePr(env: Env, title: string, head: string, body: string): Promise<void> {
  const res = await fetch(repoApi(env, "/pulls"), {
    method: "POST",
    headers: ghHeaders(env),
    body: JSON.stringify({ title, head, base: env.REPO_BRANCH, body }),
  });
  if (!res.ok) throw new Error(`github pr ${res.status}: ${await res.text()}`);
}

// --- Small utilities -----------------------------------------------------

function str(v: unknown): string {
  return typeof v === "string" ? v.trim() : "";
}

/** YAML scalar via JSON: YAML is a superset of JSON, so a JSON string is valid. */
function js(v: string): string {
  return JSON.stringify(v);
}

function sanitizeSlug(s: string): string {
  return s.replace(/[^a-zA-Z0-9._-]/g, "").slice(0, 200);
}

/** Encode a repo path for the URL while keeping the slash separators. */
function encodePath(path: string): string {
  return path.split("/").map(encodeURIComponent).join("/");
}

function toBase64(s: string): string {
  const bytes = new TextEncoder().encode(s);
  let bin = "";
  for (const b of bytes) bin += String.fromCharCode(b);
  return btoa(bin);
}

async function sha256Hex(input: string): Promise<string> {
  if (!input) return "";
  const buf = await crypto.subtle.digest("SHA-256", new TextEncoder().encode(input));
  return [...new Uint8Array(buf)].map((b) => b.toString(16).padStart(2, "0")).join("");
}

function cors(env: Env, res: Response): Response {
  res.headers.set("Access-Control-Allow-Origin", env.ALLOWED_ORIGIN);
  res.headers.set("Access-Control-Allow-Methods", "POST, OPTIONS");
  res.headers.set("Access-Control-Allow-Headers", "Content-Type");
  return res;
}

function reply(env: Env, status: number, body: unknown): Response {
  return cors(env, new Response(JSON.stringify(body), { status, headers: jsonHeaders }));
}
