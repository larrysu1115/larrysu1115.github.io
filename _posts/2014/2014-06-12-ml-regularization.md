---
layout: post
title: "Regularization"
description: ""
category: "machine-learning"
tags: [machine-learning]
---

<script type="text/javascript" async
  src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-MML-AM_CHTML">
</script>

<script type="text/x-mathjax-config">
MathJax.Hub.Config({
  displayAlign: "left"
});
</script>

Overfitting happens with excessive power, stochastic/deterministic noise, and limited data. Regularization is a way to prevent overfitting.

Named after the function approximation for `ill-posed problems`. idea: 'step back' from H_10 to H_2.

hypothesis w in $$ H_{10} = w_0 + w_1 x + w_2 x^2 + \cdots + w_{10} x^{10} $$

hypothesis w in $$ H_2 = w_0 + w_1 x + w_2 x^2 $$

H_2 = H_10 `if w3 = w4 = ... = w10 = 0`

### Regression with Constraint

$$ H_2 $$ : 第三项到第10项为零的十次多项式。

$$ H_2^{'} $$ : 任意三项为零的十次多项式。 $$ \sum_{q=0}^{10} (if \ \  w_q \neq 0) \le 3 $$

sparse hypothesis: 多个 w 为 0

将 $$ min_{w \in \mathbb{R}^{10+1}} E_{in} (w) $$, 但任意三项为零是个 NP-Hard 问题，因此试着提出 H(C): $$ \Vert{w}\Vert \le C \Rightarrow \sum_{q=0}^{10} w_q^2 \le C $$

$$ H(0) \subset H(1.126) \subset ... \subset H(1126) \subset ... \subset H( \infty ) = H_{10} $$

__Regularized hypothesis__ $$ w_{REG} $$ : optimal solution from regularized hypothesis set H(C)

### Matrix Form of Regularized Regression Problem

$$
min_{w \in \mathbb{R}^{Q+1}} E_{in}(w) = \frac{1}{N} \sum_{n=1}^{N} ( w^T z_n - y_n ) ^2
\\
s.t. \ \ \sum_{q=0}^{Q} w_q^2 \le C
$$
