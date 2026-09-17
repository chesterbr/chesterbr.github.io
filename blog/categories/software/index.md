---
robots: "noindex, follow"
sitemap: false
layout: page
title: Software
description: "Posts about software: development, tools, and the craft of coding."
hide_heading: true
category: software
permalink: /blog/categories/software/
---
<header>
  <h1 class="entry-title" data-i18n="cat-software">Software</h1>
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
