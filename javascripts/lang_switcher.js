// Blog-wide reader language switcher (EN / PT-BR / All languages).
(function () {
  var STORAGE_KEY = "readerLang";

  var translationsPt = {
    blogTitle: "blog do chester",
    langAll: "TODOS",
    archives: "Arquivo",
    eightBit: "8-Bit",
    etcetera: "Etcetera",
    subtitle: "tecnologia, viagens, quadrinhos, livros, matemática, web, software e divagações",
    readMore: "Leia mais &rarr;",
    postedBy: "Publicado por",
    postedIn: "publicado em",
    recentPosts: "Posts Recentes",
    aboutMe: "Sobre mim",
    aboutMeBlurb: 'Meu nome é Carlos, mas a maioria me chama de Chester. <a href="/">Saiba mais sobre mim.</a>',
    comments: "Comentários",
    rss: "RSS",
    rssTitle: "assine via RSS",
    email: "Email",
    emailTitle: "assine via email",
    search: "Buscar",
    recentProjects: "Projetos Recentes",
    statusUpdating: "Atualizando...",
    onGithub: "no GitHub"
  };

  // Caches each tagged element's original (English) content/attributes the
  // first time we touch it, so switching back to English can restore it
  // instead of only ever being able to translate forward.
  var originalHtml = new WeakMap();
  var originalTitle = new WeakMap();
  var originalPlaceholder = new WeakMap();

  function getMode() {
    return localStorage.getItem(STORAGE_KEY) || "all";
  }

  function chromeLangFor(mode) {
    if (mode === "en") return "en";
    if (mode === "pt-BR") return "pt-BR";
    var nav = (navigator.language || "en").toLowerCase();
    return nav.indexOf("pt") === 0 ? "pt-BR" : "en";
  }

  function blogUrlFor(mode) {
    if (mode === "en") return "/blog/en/";
    if (mode === "pt-BR") return "/blog/pt-br/";
    return "/blog/";
  }

  function applyTranslations(chromeLang) {
    var wantPt = chromeLang === "pt-BR";

    document.querySelectorAll("[data-i18n]").forEach(function (el) {
      if (!originalHtml.has(el)) originalHtml.set(el, el.innerHTML);
      var key = el.getAttribute("data-i18n");
      el.innerHTML = wantPt && translationsPt[key] ? translationsPt[key] : originalHtml.get(el);
    });

    document.querySelectorAll("[data-i18n-title]").forEach(function (el) {
      if (!originalTitle.has(el)) originalTitle.set(el, el.getAttribute("title"));
      var key = el.getAttribute("data-i18n-title");
      el.setAttribute("title", wantPt && translationsPt[key] ? translationsPt[key] : originalTitle.get(el));
    });

    document.querySelectorAll("[data-i18n-placeholder]").forEach(function (el) {
      if (!originalPlaceholder.has(el)) originalPlaceholder.set(el, el.getAttribute("placeholder"));
      var key = el.getAttribute("data-i18n-placeholder");
      el.setAttribute("placeholder", wantPt && translationsPt[key] ? translationsPt[key] : originalPlaceholder.get(el));
    });
  }

  function updateHomeLink(mode) {
    var link = document.getElementById("blog-home-link");
    if (link) link.href = blogUrlFor(mode);
  }

  function updateSwitcherState(mode) {
    document.querySelectorAll("[data-set-lang]").forEach(function (el) {
      var isActive = el.getAttribute("data-set-lang") === mode;
      el.classList.toggle("active", isActive);
      el.setAttribute("aria-pressed", isActive ? "true" : "false");
    });
  }

  function apply(mode) {
    document.documentElement.setAttribute("data-reader-lang", mode);
    applyTranslations(chromeLangFor(mode));
    updateHomeLink(mode);
    updateSwitcherState(mode);
  }

  function isBlogListingPath(path) {
    return /^\/blog(\/(en|pt-br))?\/(page\d+\/)?$/.test(path);
  }

  // /blog/ (no /en/ or /pt-br/ segment) is the unfiltered, all-languages
  // listing - its posts aren't locale-filtered server-side, so the
  // [data-reader-lang]/[data-lang] CSS filter is the only thing hiding
  // posts there. Landing here (bookmark, typed URL, old link) with an
  // explicit en/pt-BR mode already stored filters out whichever language
  // dominates that page's post set, which can leave it empty. Redirect to
  // the matching locale URL instead, same as clicking the switcher would.
  function isUnfilteredBlogListingPath(path) {
    return /^\/blog\/(page\d+\/)?$/.test(path);
  }

  // Pages with no [data-lang] elements (single posts, plain pages like
  // /about/) have nothing for the switcher to filter in place - clicking it
  // there only changed chrome text, which reads as broken. Send the reader
  // to the blog listing for that mode instead. Listing/archive pages do
  // have [data-lang] content, so they keep filtering in place.
  function hasFilterableContent() {
    return !!document.querySelector("[data-lang]");
  }

  document.addEventListener("DOMContentLoaded", function () {
    var mode = getMode();
    if (mode !== "all" && isUnfilteredBlogListingPath(window.location.pathname)) {
      window.location.href = blogUrlFor(mode);
      return;
    }
    apply(mode);

    document.querySelectorAll("[data-set-lang]").forEach(function (link) {
      link.addEventListener("click", function (event) {
        event.preventDefault();
        var newMode = link.getAttribute("data-set-lang");
        localStorage.setItem(STORAGE_KEY, newMode);
        if (isBlogListingPath(window.location.pathname) || !hasFilterableContent()) {
          window.location.href = blogUrlFor(newMode);
        } else {
          apply(newMode);
        }
      });
    });
  });
})();
