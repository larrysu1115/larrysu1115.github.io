---
layout: post
title: "Directional Derivative & Gradient Vector"
description: ""
category: "math"
tags: [math]
---

<script type="text/javascript" async
  src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-MML-AM_CHTML">
</script>

<script type="text/x-mathjax-config">
MathJax.Hub.Config({
  displayAlign: "left"
});
</script>

Notes from [Paul's Online Math](http://tutorial.math.lamar.edu/Classes/CalcIII/DirectionalDeriv.aspx)

u: unit vector of direction

D: formula for computing directional derivatives

$$
\vec{u} = \langle a, b \rangle
\\
D_{\vec{u}} f (x, y) = f_x(x,y) a + f_y(x,y) b
$$

#### Example

<img style="float:right;width:200px;" src="/assets/img/2016-Q3/160803-gradient.gif" />

Find the directional derivatives of $$ D_{\vec{u}} f(2,0) $$ where $$ f(x,y) = x e^{xy} + y $$ and u is the unit vector in the direction of $$ \theta = 2 \pi / 3 $$

Mix `Chain Rule`, `product rule`, detail of using chain rule:

$$
f(x,y) = x e^{xy} + y
\\
\frac{d}{dx} f(x,y) = \frac{d}{dx} (x e^{xy}) + 0
\\

\begin{array}
 ff(z) = e^z    & g(x) = xy \\
f'(z) = e^z   & g'(x) = y \\
\end{array}
\ \ \Rightarrow \ \ 
f'( g(x) ) \times g'(x) = e^{xy} \times y
$$

to solve the problem:

$$
f_x = (x)' \times e^{xy} + x \times (e^{xy})' = e^{xy} + x \times y e^{xy}
\\
f_y = x^2 e^{xy} + 1
\\
\vec{u} = ( \cos( \frac{2\pi}{3} ), \sin( \frac{2\pi}{3} ) ) = ( -\frac{1}{2}, \frac{\sqrt{3}}{2} )
\\
\begin{align}
D_{\vec{u}} & = f_x \times a + f_y \times b \\
& = (e^{xy} + x y e^{xy}) \times -\frac{1}{2} +  (x^2 e^{xy} + 1) \times \frac{\sqrt{3}}{2}, let x=2 \ \ y=0 \\
& = (1) \times -\frac{1}{2} +  (4 + 1) \times \frac{\sqrt{3}}{2} \\
& = \frac{5\sqrt{3}-1}{2}
\end{align}
$$

### Gradient Vector of f

$$
\begin{align}
D_\vec{u} f (x,y,z) & = f_x(x,y,z) \ a + f_x(x,y,z) \ b + f_x(x,y,z) \ c \\
                    & = \langle f_x, f_y, f_z \rangle \cdot \langle a,b,c \rangle \\
                    & \\
\nabla f            & = \langle f_x, f_y, f_z \rangle \\
                    & = f_x \vec{i} + f_y \vec{j} + f_z \vec{k} \\
D_\vec{u} f (x,y,z) & = \nabla f \cdot \vec{u}
\end{align}
$$

The $$ \vec{u} $$ is the `unit vector`

Let $$ \vec{x} $$ be any number of variables x, y, z, ..., or noted as $$ x_1, x_2, x_3, \cdots $$. We can also write the formula as:

> $$ D_\vec{u} f(\vec{x}) = \nabla f \cdot \vec{u} $$

#### Example

Find directional derivative $$ D_{\vec{u}} f( \vec{x} ) $$, for $$ f(x,y,z) = sin(yz) + ln(x^2) $$ at $$ (1,1,\pi) $$ in the direction of $$ \vec{v} = \langle 1, 1, -1 \rangle $$

$$
\begin{align}
g(x)     & = x^2 \\
h(z)     & = ln(z) \\
f_x      & = h'( g ) \cdot g' = \frac{2}{x} \\
f_y      & = z \ \cos(yz) \\
f_z      & = y \ \cos(yz) \\
\nabla f(x,y,z) & = \langle \ \ \frac{2}{x}, z \ \cos(yz), y \ \cos(yz) \ \ \rangle \\
\nabla f(1,1,\pi) & = \langle \ \ 2, \pi \ \cos(\pi), 1 \ \cos(\pi) \ \ \rangle \\
                  & = \langle \ \ 2, -\pi, -1 \ \ \rangle \\
\vec{v}  & = \langle 1, 1, -1 \rangle \\
\vec{u}  & = \frac{\vec{v}}{\Vert\vec{v}\Vert} = \langle \frac{1}{\sqrt{3}}, \frac{1}{\sqrt{3}}, \frac{-1}{\sqrt{3}} \rangle \\
D_{\vec{u}} f( 1,1,\pi ) & = \langle 2, -\pi, -1 \rangle \cdot \langle \frac{1}{\sqrt{3}}, \frac{1}{\sqrt{3}}, \frac{-1}{\sqrt{3}} \rangle \\
& = \frac{2}{\sqrt{3}} + \frac{-\pi}{\sqrt{3}} + \frac{1}{\sqrt{3}} \\
& = \frac{3 - \pi}{\sqrt{3}}
\end{align}
$$

### Theorem

1. the maximum rate of change of function f `最大斜率`:

> The maximum value of $$ D_{\vec{u}} f(\vec{x}) $$ is given by $$ \Vert \nabla f(\vec{x}) \Vert $$ and will occur in the direction given by $$ \nabla f (\vec{x}) $$.

2. 梯度 與 水平曲線 `垂直`

> The gradient vector $$ \nabla f(x_0, y_0) $$ is orthogonal (or perpendicular) to the [level curve](http://tutorial.math.lamar.edu/Classes/CalcIII/MultiVrbleFcns.aspx#LevelCurve) f(x,y) = k at the point P(x0,y0). Likewise, the gradient vector $$ \nabla f(x_0,y_0,z_0) $$ is orthogonal to the level surface f(x,y,z)=k at the point (x0,y0,z0).