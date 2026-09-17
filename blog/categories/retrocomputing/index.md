---
robots: "noindex, follow"
sitemap: false
layout: page
title: Retrocomputing
description: "Posts about retrocomputing: vintage machines, emulation, and old-school programming."
hide_heading: true
category: retrocomputing
permalink: /blog/categories/retrocomputing/
redirect_from:
  - /micros/
  - /micros.html/
---
<header>
  <h1 class="entry-title" data-i18n="cat-retrocomputing">Retrocomputing</h1>
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
