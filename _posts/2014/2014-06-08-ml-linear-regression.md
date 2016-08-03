---
layout: post
title: "Linear Regression"
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

### Linear Regression

features of customer: $$ x = (x_0, x_1, x2, ..., x_d) $$ ,

approximate the __desired credit limit__ with a __weighted__ sum:

$$
y \approx \sum_{i=0}^{d} w_i X_i =
\begin{bmatrix}
  w_0 \\ w_1 \\ \cdots \\ w_d
\end{bmatrix}
\cdot
\begin{bmatrix}
  x_0 \  x_1 \  \cdots \  x_d
\end{bmatrix}

$$

> linear regression hypothesis: $$ h(x) = w^T x $$

$$ y = (x_1) \in \mathbb{R} \ \ \ \ \ \  y = (x_1, x_2) \in \mathbb{R}^2 $$

<img src="http://www.biostathandbook.com/pix/regressionlollipop.gif" /><img src="http://www.sjsu.edu/faculty/gerstman/EpiInfo/cont-mult1.jpg" width="400" style="float:right;" />

> Find lines / hyperplanes with small residuals

### Error Measure

squared error : $$ err(\hat{y}, y) = ( \hat{y} - y )^2 $$

in-sample:

$$
\begin{align}
& E_{in}(h) = \frac{1}{N} \sum_{n=1}^{N} \left( h(x_n) - y_n \right)^2
\rightarrow \\
& E_{in}(w) = \frac{1}{N} \sum_{n=1}^{N} \left( w^Tx_n - y_n \right)^2
\end{align}
$$

out-of-sample:

$$
E_{out}(w) = \varepsilon_{(x,y) \sim P} ( w^T x - y )^2
$$

> Find minimum $$ E_{in} $$

$$
E_{in}(w) 
= \frac{1}{N} \sum_{n=1}^{N} \left( w^Tx_n - y_n \right)^2
= \frac{1}{N} \sum_{n=1}^{N} \left( x_n^T \underline{w} - y_n \right)^2
\\
=\frac{1}{N}
\begin{Vmatrix}
x_1^T w & - & y_1 \\
x_2^T w & - & y_2 \\
... & & \\
x_N^T w & - & y_N \\
\end{Vmatrix}
^2
$$


$$
=\frac{1}{N}
\begin{Vmatrix}
  \begin{bmatrix}
    x_1^T \\ x_2^T \\ ... \\ x_N^T \\
  \end{bmatrix}
  w -
  \begin{bmatrix}
    y_1 \\ y_2 \\ ... \\ y_N
  \end{bmatrix}
\end{Vmatrix}^2
\\
=\frac{1}{N}
\begin{Vmatrix}
\\
  \underline{\underline{X}} \underline{w} - \underline{Y}
\\  
\end{Vmatrix}^2 
$$

this is a convex function

![img](http://mathworld.wolfram.com/images/eps-gif/ConcaveConvexFunction_1000.gif)

So, find $$ E_{LIN} $$ such that $$ \triangledown E_{in}(w_{LIN}) = 0 $$

$$  
min_w E_{in}(w)=\frac{1}{N}
\begin{Vmatrix}
  X w - Y
\end{Vmatrix}^2 
=
\frac{1}{N} ( w^T X^T X w - 2 w^T X^T y + y^T y )
$$

vector w

$$
\begin{align}
              E_{in}(w) & = \frac{1}{N} ( w^T A w - 2 b w + c ) \\
\triangledown E_{in}(w) & = \frac{1}{N} ( 2 A w - 2 b ) \\
\end{align}
$$

invertible X^T X

$$ w_{LIN} = ( X^T X ) ^{-1} X^T y = X^{\dagger} y, \ \ X^{\dagger} $$ : pseudo-inverse

> practical suggestion
> 
> use well-implemented $$ \dagger $$ routine
>

---

avg of E_in = noise_level x $$ ( 1 - \frac{d+1}{N} ) $$

call $$ XX^{\dagger} $$ the hat matrix H, because it puts ^ on y

---

### The learning Curve

expected generalization error: $$ \frac{2(d+1)}{N} $$

---