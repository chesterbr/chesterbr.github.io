#!/usr/bin/env ruby
# frozen_string_literal: true

# Builds a single self-contained HTML page from tmp/wayback_review.json for
# quickly triaging broken links: a filterable list on the left, click a row
# to load its Wayback Machine snapshot in an iframe on the right. Data is
# inlined (not fetched) so it works from a plain double-clicked file:// URL
# in any browser. Decisions made in the page can be exported as CSV.
#
# Usage: bundle exec ruby script/wayback_lookup.rb && ruby script/build_link_review_page.rb

require "json"

ROOT = File.expand_path("..", __dir__)
DATA_JSONL = File.join(ROOT, "tmp/wayback_review.jsonl")
OUT_HTML = File.join(ROOT, "tmp/link_review.html")

# wayback_lookup.rb appends (resumable), so a URL retried after a failed
# lookup appears twice -- keep the last (most complete) record per URL.
by_url = {}
File.foreach(DATA_JSONL) do |line|
  next if line.strip.empty?

  rec = JSON.parse(line)
  by_url[rec["url"]] = rec
end

SITE_URL = "https://chester.me"
POSTS_DIR = File.join(ROOT, "_posts")

# A URL already carrying the dead-link marker in the actual post source is
# resolved -- drop it from the review queue. Checked against current post
# content (not a static list) so this stays correct across re-runs.
posts_blob = Dir.glob(File.join(POSTS_DIR, "*.{md,markdown}")).map { |p| File.read(p, encoding: "utf-8") }.join("\n")

def already_marked_dead?(url, posts_blob)
  raw_url = url.include?("%5C") ? url.gsub("%5C", "\\") : url
  posts_blob.include?(%(class="dead-link")) && posts_blob =~ /class="dead-link"[^>]*href="#{Regexp.escape(raw_url)}"/
end

data = by_url.values
  .reject { |rec| already_marked_dead?(rec["url"], posts_blob) }
  .map do |rec|
    # post_file is the _site/archives-relative path, e.g.
    # "2001/11/feira-sobre-banheiros-em-cingapura.html/index.html"
    rec["post_url"] = "#{SITE_URL}/archives/#{rec["post_file"].sub(/index\.html\z/, "")}"
    rec
  end

html = <<~HTML
  <!doctype html>
  <html lang="en">
  <head>
  <meta charset="utf-8">
  <title>Broken link review</title>
  <style>
    :root {
      color-scheme: light dark;
      --bg: #fff; --fg: #1a1a1a; --muted: #666; --border: #ddd;
      --panel: #f7f7f7; --accent: #0056b3; --done-bg: #eef7ee;
    }
    @media (prefers-color-scheme: dark) {
      :root { --bg: #121212; --fg: #e0e0e0; --muted: #999; --border: #333;
        --panel: #1b1b1b; --accent: #90caf9; --done-bg: #16241a; }
    }
    * { box-sizing: border-box; }
    body { margin: 0; font-family: -apple-system, "Segoe UI", Helvetica, Arial, sans-serif;
      background: var(--bg); color: var(--fg); }
    #toolbar { display: flex; gap: 8px; align-items: center; flex-wrap: wrap;
      padding: 8px 12px; border-bottom: 1px solid var(--border); background: var(--panel); }
    #toolbar input[type=text] { flex: 1; min-width: 160px; padding: 6px 8px; }
    #toolbar select, #toolbar button, #toolbar input[type=text] {
      background: var(--bg); color: var(--fg); border: 1px solid var(--border);
      border-radius: 4px; padding: 6px 8px; font-size: 13px; }
    #toolbar button { cursor: pointer; }
    #counts { font-size: 12px; color: var(--muted); white-space: nowrap; }
    #main { display: flex; height: calc(100vh - 49px); }
    #list { width: 42%; min-width: 320px; overflow-y: auto; border-right: 1px solid var(--border); }
    #view { flex: 1; display: flex; flex-direction: column; }
    #view iframe { flex: 1; border: 0; background: #fff; }
    #placeholder { flex: 1; display: flex; align-items: center; justify-content: center;
      color: var(--muted); padding: 24px; text-align: center; }
    #viewbar { padding: 6px 10px; font-size: 12px; border-bottom: 1px solid var(--border);
      background: var(--panel); display: none; align-items: center; gap: 10px; }
    #viewbar a { color: var(--accent); }
    .row { padding: 10px 12px; border-bottom: 1px solid var(--border); cursor: pointer; }
    .row:hover { background: var(--panel); }
    .row.active { background: var(--panel); border-left: 3px solid var(--accent); }
    .row.done { background: var(--done-bg); opacity: 0.6; }
    .row-top { display: flex; justify-content: space-between; gap: 8px; align-items: baseline; }
    .title { font-weight: 600; font-size: 13px; }
    .date { font-size: 11px; color: var(--muted); white-space: nowrap; }
    .snippet { font-size: 12px; color: var(--muted); margin: 3px 0; }
    .linktext { font-style: italic; }
    .postlink { color: var(--accent); text-decoration: none; }
    .postlink:hover { text-decoration: underline; }
    .url { font-size: 11px; color: var(--muted); word-break: break-all; margin-top: 2px; }
    .badges { display: flex; gap: 6px; margin-top: 4px; flex-wrap: wrap; }
    .badge { font-size: 10px; padding: 1px 6px; border-radius: 10px; border: 1px solid var(--border); }
    .badge.status { color: #a33; border-color: #a33; }
    .badge.wb-yes { color: #2a7; border-color: #2a7; }
    .badge.wb-no { color: var(--muted); }
    .badge.fp { color: #b80; border-color: #b80; }
    .controls { display: flex; gap: 6px; margin-top: 6px; }
    .controls select, .controls input[type=text] { font-size: 11px; padding: 3px; flex: 1;
      background: var(--bg); color: var(--fg); border: 1px solid var(--border); border-radius: 3px; }
    .controls * { cursor: pointer; }
  </style>
  </head>
  <body>
  <div id="toolbar">
    <input type="text" id="search" placeholder="Filter by title / URL / text...">
    <select id="statusFilter">
      <option value="">All statuses</option>
      <option value="dead">Confirmed dead (404/410/0)</option>
      <option value="fp">Possibly false positive (403/429/401/406)</option>
      <option value="other">Redirect/server error</option>
    </select>
    <select id="wbFilter">
      <option value="">Any Wayback result</option>
      <option value="yes">Has snapshot</option>
      <option value="no">No snapshot</option>
    </select>
    <label style="font-size:13px"><input type="checkbox" id="hideDone"> hide reviewed</label>
    <span id="counts"></span>
    <button id="exportBtn">Export decisions CSV</button>
  </div>
  <div id="main">
    <div id="list"></div>
    <div id="view">
      <div id="viewbar"><span id="viewbarTitle"></span><a id="viewbarOpen" target="_blank">open in new tab ↗</a></div>
      <div id="placeholder">Click an item on the left to preview its Wayback Machine snapshot here.</div>
      <iframe id="frame" style="display:none"></iframe>
    </div>
  </div>
  <script>
    const DATA = #{JSON.generate(data)};
    const LS_KEY = "linkReviewDecisions";

    function loadDecisions() {
      try { return JSON.parse(localStorage.getItem(LS_KEY) || "{}"); }
      catch (e) { return {}; }
    }
    function saveDecisions(d) {
      try { localStorage.setItem(LS_KEY, JSON.stringify(d)); } catch (e) {}
    }
    let decisions = loadDecisions();

    function fpBucket(status) {
      if (["404", "410", "0"].includes(status)) return "dead";
      if (["403", "429", "401", "406"].includes(status)) return "fp";
      return "other";
    }

    const list = document.getElementById("list");
    const search = document.getElementById("search");
    const statusFilter = document.getElementById("statusFilter");
    const wbFilter = document.getElementById("wbFilter");
    const hideDone = document.getElementById("hideDone");
    const counts = document.getElementById("counts");

    function matches(item) {
      const q = search.value.trim().toLowerCase();
      if (q) {
        const hay = [item.post_title, item.url, item.link_text, item.context].join(" ").toLowerCase();
        if (!hay.includes(q)) return false;
      }
      if (statusFilter.value && fpBucket(item.status) !== statusFilter.value) return false;
      if (wbFilter.value === "yes" && !item.wayback_url) return false;
      if (wbFilter.value === "no" && item.wayback_url) return false;
      const dec = decisions[item.url];
      if (hideDone.checked && dec && dec.decision) return false;
      return true;
    }

    function esc(s) {
      return (s || "").replace(/[&<>"']/g, c => ({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#39;"}[c]));
    }

    function render() {
      const items = DATA.filter(matches);
      counts.textContent = items.length + " / " + DATA.length + " shown, " +
        Object.values(decisions).filter(d => d.decision).length + " decided";
      list.innerHTML = items.map((item, i) => {
        const dec = decisions[item.url] || {};
        const done = dec.decision ? "done" : "";
        const wb = item.wayback_url
          ? '<span class="badge wb-yes">snapshot found</span>'
          : '<span class="badge wb-no">no snapshot</span>';
        const fp = fpBucket(item.status) === "fp"
          ? '<span class="badge fp">' + esc(item.note || "check in browser") + '</span>' : "";
        return '<div class="row ' + done + '" data-url="' + esc(item.url) + '">' +
          '<div class="row-top"><span class="title">' + esc(item.post_title || item.post_file) + '</span>' +
          '<span class="date">' + esc(item.post_date || "") + '</span></div>' +
          (item.link_text ? '<div class="snippet linktext">&ldquo;' + esc(item.link_text) + '&rdquo;</div>' : "") +
          (item.context ? '<div class="snippet">' + esc(item.context) + '</div>' : "") +
          '<div class="snippet"><a class="postlink" href="' + esc(item.post_url) + '" target="_blank">read full post on chester.me &#8599;</a></div>' +
          '<div class="url">' + esc(item.url) + '</div>' +
          '<div class="badges"><span class="badge status">' + esc(item.status) + '</span>' + wb + fp + '</div>' +
          '<div class="controls">' +
            '<select data-field="decision">' +
              optionsHtml(dec.decision) +
            '</select>' +
            '<input type="text" data-field="note" placeholder="note..." value="' + esc(dec.note || "") + '">' +
          '</div>' +
        '</div>';
      }).join("");
    }

    const DECISION_OPTIONS = ["", "use wayback snapshot", "strip link (keep text)", "remove entirely", "leave as-is", "needs manual research"];
    function optionsHtml(selected) {
      return DECISION_OPTIONS.map(o => '<option value="' + esc(o) + '"' + (o === selected ? " selected" : "") + '>' +
        (o === "" ? "— pending —" : esc(o)) + '</option>').join("");
    }

    list.addEventListener("click", (e) => {
      const row = e.target.closest(".row");
      if (!row) return;
      const url = row.dataset.url;
      const item = DATA.find(d => d.url === url);

      if (e.target.matches("select, input, a.postlink")) return; // let controls / the post link handle their own events

      document.querySelectorAll(".row.active").forEach(r => r.classList.remove("active"));
      row.classList.add("active");

      const frame = document.getElementById("frame");
      const placeholder = document.getElementById("placeholder");
      const viewbar = document.getElementById("viewbar");
      const viewbarOpen = document.getElementById("viewbarOpen");
      const viewbarTitle = document.getElementById("viewbarTitle");

      if (item.wayback_url) {
        frame.src = item.wayback_url;
        frame.style.display = "block";
        placeholder.style.display = "none";
        viewbar.style.display = "flex";
        viewbarOpen.href = item.wayback_url;
        viewbarTitle.textContent = "Wayback snapshot (" + item.wayback_timestamp + ")";
      } else {
        frame.style.display = "none";
        frame.src = "about:blank";
        placeholder.style.display = "flex";
        placeholder.innerHTML = "No Wayback snapshot found for this URL.<br><br>" +
          '<a href="' + esc(item.url) + '" target="_blank">Try the live URL anyway ↗</a><br>' +
          '<a href="https://web.archive.org/web/*/' + esc(item.url) + '" target="_blank">Search Wayback manually ↗</a>';
        viewbar.style.display = "none";
      }
    });

    list.addEventListener("change", (e) => {
      const row = e.target.closest(".row");
      if (!row || !e.target.dataset.field) return;
      const url = row.dataset.url;
      decisions[url] = decisions[url] || {};
      decisions[url][e.target.dataset.field] = e.target.value;
      saveDecisions(decisions);
      row.classList.toggle("done", !!decisions[url].decision);
      render_counts_only();
    });

    function render_counts_only() {
      counts.textContent = document.querySelectorAll(".row").length + " / " + DATA.length + " shown, " +
        Object.values(decisions).filter(d => d.decision).length + " decided";
    }

    [search, statusFilter, wbFilter, hideDone].forEach(el => el.addEventListener("input", render));

    document.getElementById("exportBtn").addEventListener("click", () => {
      const rows = [["url", "post_file", "status", "wayback_url", "decision", "note"]];
      DATA.forEach(item => {
        const dec = decisions[item.url] || {};
        if (!dec.decision && !dec.note) return;
        rows.push([item.url, item.post_file, item.status, item.wayback_url || "", dec.decision || "", dec.note || ""]);
      });
      const csv = rows.map(r => r.map(v => '"' + String(v).replace(/"/g, '""') + '"').join(",")).join("\\n");
      const blob = new Blob([csv], { type: "text/csv" });
      const a = document.createElement("a");
      a.href = URL.createObjectURL(blob);
      a.download = "link_review_decisions.csv";
      a.click();
    });

    render();
  </script>
  </body>
  </html>
HTML

File.write(OUT_HTML, html)
puts "Wrote #{OUT_HTML} (#{data.size} items, #{(html.bytesize / 1024.0).round}KB)"
