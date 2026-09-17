---
robots: "noindex, follow"
sitemap: false
layout: page
title: Books
description: "Posts about books: reviews, recommendations, and reading notes."
hide_heading: true
category: books
permalink: /blog/categories/books/
---
<header>
  <h1 class="entry-title" data-i18n="cat-books">Books</h1>
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
