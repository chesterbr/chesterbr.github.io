// Small vanilla-JS UI behaviors for the blog chrome: the collapsible search
// box and line numbers for embedded Gists. Replaces the old jQuery-based
// octopress.js (mobile nav select, sidebar toggler, Flash/Delicious helpers
// all dropped along with the sidebar and stock theme).
document.addEventListener("DOMContentLoaded", function () {
  document.querySelectorAll(".search-widget").forEach(function (widget) {
    var toggle = widget.querySelector(".search-toggle");
    var panel = widget.querySelector(".search-panel");
    var mount = widget.querySelector(".pagefind-mount");
    if (!toggle || !panel || !mount) return;

    // Pagefind's own UI strings (placeholder, "N results for X", "load more")
    // follow the site's reader language — window.readerLangIsPt() is the same
    // source the chrome i18n uses — rather than the current post's own locale.
    function pagefindTranslations() {
      var pt = typeof window.readerLangIsPt === "function"
        ? window.readerLangIsPt()
        : (document.documentElement.lang || "en").toLowerCase().indexOf("pt") === 0;
      return pt
        ? {
            placeholder: "Buscar no blog",
            load_more: "Ver mais resultados",
            searching: "Buscando por [SEARCH_TERM]…",
            zero_results: "Nada encontrado para [SEARCH_TERM]",
            many_results: "[COUNT] resultados para [SEARCH_TERM]",
            one_result: "[COUNT] resultado para [SEARCH_TERM]",
          }
        : { placeholder: "Search the blog" };
    }

    // Pagefind's WASM engine + UI are ~KBs we only need if someone searches,
    // so we don't load them on every page view — only on the first open.
    var pfLoaded = false;
    var pfInstance = null;
    function makePagefindUI() {
      pfInstance = new PagefindUI({
        element: mount,
        showImages: false,
        showSubResults: true,
        translations: pagefindTranslations(),
      });
    }
    function loadPagefind() {
      if (pfLoaded) return;
      pfLoaded = true;
      var css = document.createElement("link");
      css.rel = "stylesheet";
      css.href = "/pagefind/pagefind-ui.css";
      document.head.appendChild(css);
      var js = document.createElement("script");
      js.src = "/pagefind/pagefind-ui.js";
      js.onload = makePagefindUI;
      document.head.appendChild(js);
    }

    // In-place language switches (archive/category pages) don't reload, so rebuild
    // the Pagefind UI with the new-language strings when the reader switches.
    document.addEventListener("readerlangchange", function () {
      if (pfInstance) { pfInstance.destroy(); makePagefindUI(); }
    });

    function focusInput() {
      var input = mount.querySelector("input");
      // Select any existing query so the next keystroke replaces it.
      if (input) { input.focus(); input.select(); }
    }
    // The Categories menu is a native <details>; clicking away doesn't close it,
    // so close it explicitly when search opens (search already closes on any
    // outside click, including on the menu).
    var menus = document.querySelectorAll(".topics-widget details");
    function closeMenus() {
      menus.forEach(function (d) { d.open = false; });
    }
    function open() {
      loadPagefind();
      closeMenus();
      widget.classList.add("search-open");
      panel.hidden = false;
      toggle.setAttribute("aria-expanded", "true");
      // The input may not exist until Pagefind's script has run.
      focusInput();
      setTimeout(focusInput, 200);
    }
    function close() {
      widget.classList.remove("search-open");
      panel.hidden = true;
      toggle.setAttribute("aria-expanded", "false");
    }

    toggle.addEventListener("click", function (e) {
      e.stopPropagation();
      if (widget.classList.contains("search-open")) close();
      else open();
    });
    document.addEventListener("click", function (e) {
      if (widget.classList.contains("search-open") && !widget.contains(e.target)) close();
    });
    document.addEventListener("keydown", function (e) {
      if (e.key === "Escape" && widget.classList.contains("search-open")) close();
    });
    // Symmetric: opening Categories closes search.
    menus.forEach(function (d) {
      d.addEventListener("toggle", function () {
        if (d.open && widget.classList.contains("search-open")) close();
      });
    });
  });

  document.querySelectorAll("div.gist-highlight").forEach(function (code) {
    var lines = code.querySelectorAll(".line");
    var pre = code.querySelector("pre");
    if (!lines.length || !pre) return;

    var lineNumbers = "";
    for (var i = 1; i <= lines.length; i++) {
      lineNumbers += '<span class="line-number">' + i + "</span>\n";
    }

    code.innerHTML =
      '<table><tbody><tr><td class="gutter"><pre class="line-numbers">' +
      lineNumbers +
      '</pre></td><td class="code"><pre>' +
      pre.innerHTML +
      "</pre></td></tr></tbody></table>";
  });
});
