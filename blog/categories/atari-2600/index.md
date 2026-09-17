---
robots: "noindex, follow"
sitemap: false
layout: page
title: Atari 2600
description: "Posts about the Atari 2600: homebrew, programming, and hardware for the classic console."
hide_heading: true
category: atari-2600
permalink: /blog/categories/atari-2600/
redirect_from:
  - /atari-2600/
---
<header>
  <h1 class="entry-title" data-i18n="cat-atari-2600">Atari 2600</h1>
</header>

<div class="blog-index">
{% assign index = true %}
{% for post in site.categories[page.category] %}
  {% assign content = post.excerpt %}
  {% capture end_elipsis %}{{ post.excerpt | slice: -4, 3 }}{% endcapture %}
  {% if post.content contains "<!--more-->" or end_elipsis == "..." %}
    {% assign read_more = 'show' %}
  {% else %}
    {% assign read_more = 'hide' %}
  {% endif %}
  <article data-lang="{{ post.locale }}">
    {% include article.html %}
  </article>
{% endfor %}
</div>
