---
layout: post
title: "Linear Support Vector Machine"
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

### Find largest-margin separating hyperplane

Maximum-margin hyperplane and margins for an SVM trained with samples from two classes. Samples on the margin are called the support vectors.

<img width="300" style="float:right;" src="https://upload.wikimedia.org/wikipedia/commons/2/2a/Svm_max_sep_hyperplane_with_margin.png" />

Linear (hyperplane) classifiers: $$ h(x) = sign( w^T x ) $$.

$$ E_{out}(w) \le E_{in}(w) + \Omega(H) $$

Purpose:

- maximize : fatness(w) = $$ \min_{n=1,...,N} distance(x_n, w) $$. 'fatness' formally called `margin`.
- correctness : $$ y_n = sign(w^T x_n) \Rightarrow y_n w^T x_n > 0 $$

从 W 中取出 w0 = b, 剩下的 w1 ~ w_d 为 w, x1 ~ w_d 为 x.

所以 h(x) = sign(W^T x + b)

want: distance(x, b, w), with hyperplane $$ w^T x' + b = 0 $$

distance(x, b, w) 
= \| $$ \frac{w^T}{\|w\|} (x - x') $$ \| 
= $$ \frac{1}{\|w\|} | w^T x + b | $$

经过放缩 w 长度，分子分母倒置 max 变成 min, w长度等于 w^T w，去除根号，乘上1/2后，需要找到的是:

$$ 
min_{b,w} = \frac{1}{2} w^T w
\\
\text{,s.t.:} \ y_n(w^T x_n + b) \ge 1 
$$

### Quadratic Programming

Quadratic Programming (QP) is 'easy' optimization problem.

| SVM Problem | QP |
| - | - |
| optimal(b,w) = ?  | optimal u <- QP(Q, p, A, c) |
| $$ min_{b,w} = \frac{1}{2} w^T w $$ | $$ min_u \frac{1}{2} u^T Q u + p^T u $$ |
| $$ y_n(w^T x_n + b) \ge 1 $$, for n=1,2,...,N | $$ a_m^T u \ge c_m $$, for m=1,2,...,M |

#### Linear Hard-Margin SVM Algorithm

objective function: `u, Q, p`; constraints: `a, c, M`

$$
u = \begin{bmatrix} b \\ \underline{w}	 \end{bmatrix},
\ \ \ \ 
Q = \begin{bmatrix} 
  0 & \underline{0}^T \\ 
  \underline{0} & \underline{\underline{I}}
\end{bmatrix},
\ \ \ \ 
p = \underline{0}
\\
a_n^T = \begin{bmatrix} y_n & y_n \underline{x}_n^T \end{bmatrix} 
= y_n \begin{bmatrix} 1 & \underline{x}_n^T \end{bmatrix},
\ \ \ \ 
c_n = 1,
\ \ \ \ 
M = N
$$


