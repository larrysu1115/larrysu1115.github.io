---
layout: post
title: "Linear Algebra - System of linear equations"
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

---

### System of linear equation

General system of __m__ equations in __n__ variables (unknown) over a field F

$$
a_{11} x_1 + a_{12} x_2 + ... + a_{1n} x_n = b_1 \\
a_{21} x_1 + a_{22} x_2 + ... + a_{2n} x_n = b_2 \\
... \\
a_{m1} x_1 + a_{m2} x_2 + ... + a_{mn} x_n = b_m
$$

can also be described by :

$$
\sum_{j=1}^n a_{ij} x_j = b_{i}, for \  i = 1, 2, ..., m.
$$

or by a m x n __coefficient matrix__ A

$$
Ax = b \\
x = 
\begin{pmatrix}
x_1 \\ x_2 \\ ... \\ x_n
\end{pmatrix}
,
b = 
\begin{pmatrix}
b_1 \\ b_2 \\ ... \\ b_m
\end{pmatrix}
$$

__Augmented matrix__ : let A be the coefficient matrix of _m_ linear equations in _n_ variables, the _augmented matrix_ is the m x (n+1) matrix given in the block form as [A \| b]

### Gaussian elimination

$$
\begin{align}
  x_1 - x_2   + 2 x_3 = & 3 \\
  3 x_1 + 2 x_2 - x_3   = & 1 \\
  x_2 + 4 x_3 = & -1 \\
\end{align}
\Rightarrow
\left[\begin{array}{rrr|r}
1 & -1 & 2 & 3 \\
3 & 2 & -1 & 1 \\
0 & 1 & 4 & -1 \\
\end{array}\right]
\Rightarrow
\left[\begin{array}{rrr|r}
1 & -1 & 2 & 3 \\
0 & 5 & -7 & -8 \\
0 & 1 & 4 & -1 \\
\end{array}\right] \\
\Rightarrow
\left[\begin{array}{rrr|r}
1 & -1 & 2 & 3 \\
0 & 1 & 4 & -1 \\
0 & 5 & -7 & -8 \\
\end{array}\right]
\Rightarrow
\left[\begin{array}{rrr|r}
1 & -1 & 2 & 3 \\
0 & 1 & 4 & -1 \\
0 & 0 & -27 & -3 \\
\end{array}\right] \\
\Rightarrow
\left[\begin{array}{rrr|r}
1 & 0 & 0 & 12/9 \\
0 & 1 & 0 & -13/9 \\
0 & 0 & 1 & 1/9 \\
\end{array}\right]
\Rightarrow
x_1 = 12/9, x_2 = -13/9, x_3 = 1/9
$$

---

### Row operations

__elementary row operation__ :

  - Multiplying any row by a non-zero scalar.
  - Interchanging two rows.
  - Adding a scalar multiple of one row to another.

__row equivalent__ :

  If an m × n matrix A can be changed to matrix B by a sequence of row operations, then B is __row equivalent__ to A.
  
  notation: __B ~ A__
  
__elementary matrix__ :

Perform one row operation on Identity Matrix.

$$
\begin{bmatrix}
a & 0 \\ 0 & 1
\end{bmatrix}
,
\begin{bmatrix}
0 & 1 \\ 1 & 0
\end{bmatrix}
,
\begin{bmatrix}
1 & a \\ 0 & 1
\end{bmatrix}
$$

Observe effects of multiply by elementary matrix:

$$
\begin{bmatrix}
1 & a \\ 0 & 1
\end{bmatrix}
\begin{bmatrix}
a_{11} & a_{12} & a_{13} \\ a_{21} & a_{22} & a_{23}
\end{bmatrix}
=
\begin{bmatrix}
a_{11} + aa_{21} & a_{12} + aa_{22} & a_{13} + aa_{23} \\ a_{21} & a_{22} & a_{23}
\end{bmatrix}
\\

\begin{bmatrix}
1 & 0 \\ a & 1
\end{bmatrix}
\begin{bmatrix}
a_{11} & a_{12} & a_{13} \\ a_{21} & a_{22} & a_{23}
\end{bmatrix}
=
\begin{bmatrix}
a_{11} & a_{12} & a_{13} \\ a_{21} + aa_{11} & a_{22} + aa_{12} & a_{23} + aa_{13}
\end{bmatrix}
\\

\begin{bmatrix}
0 & 1 \\ 1 & 0
\end{bmatrix}
\begin{bmatrix}
a_{11} & a_{12} & a_{13} \\ a_{21} & a_{22} & a_{23}
\end{bmatrix}
=
\begin{bmatrix}
a_{21} & a_{22} & a_{23} \\ a_{11} & a_{12} & a_{13}
\end{bmatrix}
\\

\begin{bmatrix}
a & 0 \\ 0 & 1
\end{bmatrix}
\begin{bmatrix}
a_{11} & a_{12} & a_{13} \\ a_{21} & a_{22} & a_{23}
\end{bmatrix}
=
\begin{bmatrix}
aa_{11} & aa_{12} & aa_{13} \\ a_{21} & a_{22} & a_{23}
\end{bmatrix}
$$

### Row reduction

__row echelon matrix__

$$
\begin{bmatrix}
1 & * & * & 0 & * & * & 0 \ldots \\
0 & 0 & 0 & 1 & * & * & 0 \ldots \\
0 & 0 & 0 & 0 & 0 & 0 & 1 \ldots
\end{bmatrix}
$$

- All non-zero rows are above any zero row.
- leading entry in a non-zero row is in a column to the right of the leading entry in any row above it.
- All the entries in the column below a leading entry are zero.

A row echelon matrix is further said to be a __reduced row echelon matrix__, provided it satisfies two more conditions:

- The leading entry in each non-zero row is 1.
- The leading entry is the only non-zero entry in the column containing the leading entry.

The leading entry of a non-zero row of a matrix in an echelon is called a __pivot__.

---

__Example of row reduction__ :

$$
          3 x_2 +  9 x_3         +  6 x_5 = -3 \\
-2 x_1 +  4 x_2 +  6 x_3 - 4 x_4          = -2 \\
 4 x_1 - 11 x_2 - 18 x_3 + 2 x_4 -  3 x_5 = 10 \\
 
\left[\begin{array}{rrrrr|r}
 0 &   3 & 9   & 0  &  6 & -3 \\
-2 &   4 &   6 & -4 &  0 & -2 \\
 4 & -11 & -18 &  2 & -3 & 10
\end{array}\right], \\
 \left[\begin{array}{rrrrr|r}
-2 &   4 &   6 & -4 &  0 & -2 \\
 0 &   3 & 9   & 0  &  6 & -3 \\
 4 & -11 & -18 &  2 & -3 & 10
\end{array}\right], 
R_1 \Leftrightarrow R_2 \\
\left[\begin{array}{rrrrr|r}
-2 &   4 &   6 & -4 &  0 & -2 \\
 0 &   3 & 9   & 0  &  6 & -3 \\
 0 &  -3 &  -6 & -6 & -3 &  6 
\end{array}\right],
R_3' = 2 R_1 + R_3 \\
\left[\begin{array}{rrrrr|r}
-2 &   4 &  6 & -4 &  0 & -2 \\
 0 &   3 &  9 &  0 &  6 & -3 \\
 0 &   0 &  3 & -6 &  3 &  3 
\end{array}\right],
R_3' = R_2 + R_3 \\
\left[\begin{array}{rrrrr|r}
 1 &  -2 & -3 &  2 &  0 &  1 \\
 0 &   1 &  3 &  0 &  2 & -1 \\
 0 &   0 &  1 & -2 &  1 &  1 
\end{array}\right], \\
\left[\begin{array}{rrrrr|r}
 1 &  -2 &  0 & -4 &  3 &  4 \\
 0 &   1 &  0 &  6 & -1 & -4 \\
 0 &   0 &  1 & -2 &  1 &  1 
\end{array}\right], \\
\left[\begin{array}{rrrrr|r}
 1 &   0 &  0 &  8 &  1 & -4 \\
 0 &   1 &  0 &  6 & -1 & -4 \\
 0 &   0 &  1 & -2 &  1 &  1 
\end{array}\right]
$$

transform to:

$$
x_1 + 8 x_4 + x_5 = -4 \\
x_2 + 6 x_4 - x_5 = -4 \\
x_3 - 2 x_4 + x_5 = 1 \\
$$

any solution satisfy:

$$
x_5 = a \\
x_4 = b \\
x_3 =  1 - a + 2b \\
x_2 = -4 + a - 6b \\
x_1 = -4 - a - 8b
$$

### Invertible Matrices

`A matrix A is invertible if and only if its reduced row echelon form is the identity matrix`

Apply elementary row operations to the block matrix [A\|I] so as to reduce A to its reduced row echelon form. If A is row-equivalent to I, then A is invertible, and [A\|I] is row equivalent to [I\|A^-1]. Otherwise, A is not invertible.

Find the inverse of A:

$$
A = \begin{bmatrix}
2 & -2 \\ 4 & 7
\end{bmatrix} \\

[A | I_2] = 
\left[\begin{array}{rr|rr}
2 & -2 & 1 & 0 \\ 
4 & 7 & 0 & 1
\end{array}\right] \\
\sim 
\left[\begin{array}{rr|rr}
2 & -2 & 1 & 0 \\ 
0 & 11 & -2 & 1
\end{array}\right] \\
\sim 
\left[\begin{array}{rr|rr}
1 & -1 & 1/2 & 0 \\ 
0 & 1 & -2/11& 1/11
\end{array}\right] \\
\sim 
\left[\begin{array}{rr|rr}
1 & 0 & 7/22 & 1/11 \\ 
0 & 1 & -2/11& 1/11
\end{array}\right] \\
$$

### Determinant

$$
\det A = a_{11} \det A_{11} - a_{12} \det A_{12} \cdots \pm a_{1n} \det A_{1n}
$$

Find the determinant:

$$
\det
\begin{bmatrix}
 2 &  0 & -3 \\
-1 &  1 &  0 \\
 2 & -1 &  1
\end{bmatrix}
=
2 \cdot \det \begin{bmatrix}
  1 &  0 \\
 -1 &  1
\end{bmatrix}
-
0 \cdot \det \begin{bmatrix}
 -1 &  0 \\
 2 &  1
\end{bmatrix}
+
(-3) \cdot \det \begin{bmatrix}
 -1 & 1 \\
 2 & -1
\end{bmatrix} \\
= 2 \cdot 1 - 0 \cdot (-1) - 3 \cdot (-1) \\
= 2 - 0 + 3 \\
= 5
$$
