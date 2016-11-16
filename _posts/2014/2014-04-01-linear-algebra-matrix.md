---
layout: post
title: "Linear Algebra - Matrix"
description: ""
category: "math-linear-algebra"
tags: [linear-algebra]
---

<script type="text/javascript" async
  src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-MML-AM_CHTML">
</script>

<script type="text/x-mathjax-config">
MathJax.Hub.Config({
  displayAlign: "left",
  displayIndent: "0em"
});
</script>

#### m x n matrix 

$$
A = [a_{ij}] = 
\begin{bmatrix}
  a_{11} & a_{12} & . & a_{1n} \\
  a_{21} & . & . & . \\  
  . & . & . & . \\
  a_{m1} & . & . & a_{mn} \\
\end{bmatrix}
$$

#### matrix multiplication

`X = aA + bB + cC + dD`, 结果的 nrow = 前矩阵nrow, ncol = 后矩阵ncol.

$$
\begin{bmatrix}
  . & . & . & . \\
  a & b & c & d \\
\end{bmatrix}
 \times 
\begin{bmatrix}
  . & A & . \\
  . & B & . \\
  . & C & . \\
  . & D & . \\
\end{bmatrix}
 = 
\begin{bmatrix}
  . & . & . \\
  . & X & . \\
\end{bmatrix}
$$

#### identity matrix: 

$$ I = 
\begin{bmatrix}
  1 & 0 & 0 & 0 \\
  0 & 1 & 0 & 0 \\  
  0 & 0 & 1 & 0 \\
  0 & 0 & 0 & 1 \\
\end{bmatrix}
$$

#### dot/scalar product

$$
A = [a_1, a_2, ..., a_n], \ \ \ \ 
B = 
\begin{pmatrix}
  b_1 \\
  b_2 \\
  . \\
  b_n \\
\end{pmatrix}
\\
A \cdot B = a_1 b_1 + a_2 b_2 + ... + a_n b_n
$$

#### multiply examples

$$
c_{ij} = \sum_{k=1}^{n} a_{ik} b_{kj}
\\
\begin{bmatrix}
  1 & 2 & 3 \\
  0 & 4 & -1 \\
\end{bmatrix}
\begin{bmatrix}
  0 & 1 \\
  2 & -2 \\
  1 & 1 \\
\end{bmatrix}
=
\begin{bmatrix}
  7 & 0 \\
  7 & -9 \\
\end{bmatrix}
$$

> matrix-vector multiplication

$$
\begin{bmatrix}
  1 & -1 & 2 \\
  0 & -3 & 1
\end{bmatrix}
\begin{pmatrix}
  2 \\
  1 \\
  0
\end{pmatrix}
=
\begin{bmatrix}
  1 \\
  -3
\end{bmatrix}
$$

#### linear equotion

$$
2x - 3y = 5 \\
x + 4y = -7 \\
\Rightarrow
A \vec{x} = \vec{b} \\
A = 
\begin{bmatrix}
  2 & -3 \\
  1 & 4 \\
\end{bmatrix}
, \vec{x} =
\begin{pmatrix}
  x \\
  y \\
\end{pmatrix}
, \vec{b} =
\begin{pmatrix}
  5 \\
  -7 \\
\end{pmatrix}
$$

#### invertible matrices

inverse of A : $$ A^{-1} $$

$$
AB = BA = I_n \\
$$

If A is not invertible, A is __singular__ matrix.

#### transpose of a matrix

symmetric : $$ A^t = A $$

skew-symmetric : $$ A^t = -A $$

__conjugate transpose__ : $$ A^* $$

#### partition of matrices, block multiplication