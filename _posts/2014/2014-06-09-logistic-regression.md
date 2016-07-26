---
layout: post
title: "Logistic Regression"
description: ""
category: "machine-learning"
tags: [machine-learning]
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

---

## Logistic Regression

features of patient: $$ x = (x_0, x_1, x2, ..., x_d) $$ ,

calculate a weighted `risk score`:

$$
s = \sum_{i=0}^{d} w_i x_i 
\\
\theta(s) = \frac{e^s}{1+e^s} = \frac{1}{1+e^{-s}}
\\
h(x) = \frac{1}{1+exp(-w^T x)}
$$

---

### Stochastic Gradient Descent (SGD)

---

### Multicalss via Logistic Regression

---

### One-Versus-All (OVA) Decomposition

### One-Versus-One (OVO) Decomposition
