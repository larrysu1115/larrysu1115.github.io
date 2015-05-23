---
layout: page
title: Larry
tagline: Supporting tagline
---
{% include JB/setup %}

    吾生也有涯，而知也無涯。以有涯隨無涯，殆已；已而為知者，殆而已矣。 - 養生主
    
## Articles:

<ul class="posts">
  {% for post in site.posts %}
    <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>

