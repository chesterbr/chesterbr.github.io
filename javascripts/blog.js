// Small vanilla-JS UI behaviors for the blog chrome: the collapsible search
// box and line numbers for embedded Gists. Replaces the old jQuery-based
// octopress.js (mobile nav select, sidebar toggler, Flash/Delicious helpers
// all dropped along with the sidebar and stock theme).
document.addEventListener("DOMContentLoaded", function () {
  document.querySelectorAll(".search-widget").forEach(function (widget) {
    var toggle = widget.querySelector(".search-toggle");
    var input = widget.querySelector("input.search");
    if (!toggle || !input) return;

    function open() {
      widget.classList.add("search-open");
      toggle.setAttribute("aria-expanded", "true");
    }
    function close() {
      if (document.activeElement !== input) {
        widget.classList.remove("search-open");
        toggle.setAttribute("aria-expanded", "false");
      }
    }

    toggle.addEventListener("click", function () {
      if (widget.classList.contains("search-open")) {
        close();
      } else {
        open();
        input.focus();
      }
    });
    input.addEventListener("focus", open);
    input.addEventListener("blur", function () {
      setTimeout(close, 100);
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
