---
layout: post
title: "Calculus - Integral by Parts"
description: ""
category: "math"
tags: [math-calculus]
---

<script type="text/javascript" async
  src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-MML-AM_CHTML">
</script>

<script type="text/x-mathjax-config">
MathJax.Hub.Config({
  displayAlign: "left",
  displayIndent: "2em"
});
</script>

### Integration by Parts 分部積分法

  $$ \int u dv = uv - \int v du $$

`用於相乘的積分`

推導:

$$
d \big( u v \big) = u \ d(v) + v \  d(u) \\
\to \int d \big( u v \big) = \int \Big[ u \ d(v) + v \ d(u) \Big] \\
\to u v = \int \Big( u \ d(v) \Big) + \int \Big( v \ d(u) \Big) \\
\to \int u dv = uv - \int v du
$$

#### Example 1

$$
\int x \ cosx dx \\
= \int u dv = uv - \int v du \\
= x \ sinx - \int sinx dx \\
= x \ sinx + cosx + C
$$

細節:

$$
let \ \  u=x, dv = cosx dx \\
du = dx, v = \int cosx d_x = sinx
$$

快速的作法:

$$
\int x \ cosx dx \\
= \int \underbrace{x}_{u} \ d \underbrace{sinx}_{v} \\
= uv - \int v \ du \\
= x \ sinx - \int sinx dx \\
= x \ sinx + cosx + C
$$

#### Example 2

$$
\int \underbrace{\ln x}_{u} \ d \underbrace{x}_{v}  \\
= u v - \int v du = x \ln x - \int x d \ln x \\
= x \ln x - \int x x^{-1} dx \\
= x \ln x - \int 1 dx \\
= x \ln x - x + C
$$

細節:

$$
\frac{d}{dx} \ln x = x^{-1} \\
\to d \ln x = x^{-1} dx
$$
