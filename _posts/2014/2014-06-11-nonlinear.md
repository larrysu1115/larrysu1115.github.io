---
layout: post
title: "Nonlinear"
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


### Quadratic Hypotheses


### Linear Hypothesis in Z-Space

$$
(z_0,z_1,z_2) = z = \phi(x) = (1, x_1^2, x_2^2)
\\
h(x) = \tilde{h}(z) = sign( \tilde{w}^T \cdot \phi(x) ) = sign( \tilde{w_0} + \tilde{w_1} x_1^2 + \tilde{w_2} x_2^2 )
\\
\tilde{w} = ( \tilde{w_0} + \tilde{w_1} + \tilde{w_2} )
$$

- (0.6, -1, -1): circle (o inside)
- (0.6,  1,  1): circle (o outside)
- (0.6, -1, -2): ellipse
- (0.6, -1, +2): hyperbola
- (0.6, +1, +2): constant o

__restricted center on (0,0)__


### General Quadratic Hypothesis Set

$$
\phi_2(x) = (1, x_1, x_2, x_1^2, x_1 x_2, x_2^2 )
$$

- Perceptrons in Z-Space <--> quadratic hypotheses in X-Space
- Can implement all possible quadratic curve boundaries: circle, ellipse, rotated ellipse, hyperbola, parabola,...
- include lines and constants as degenerate cases

$$
2(x_1 + x_2 - 3)^2 + (x_1 - x_2 - 4)^2 = 1
\\
\tilde{w}^T = [ 33, -20, -4, 3, 2, 3]
$$

1 + $$ \tilde{d} $$ dimensions

= # ways of <= Q-combination from d kinds with repetitions

= $$ \binom{Q+d}{Q} $$
