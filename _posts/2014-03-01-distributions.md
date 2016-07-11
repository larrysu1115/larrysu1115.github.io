---
layout: post
title: "Distributions of Probability"
description: "Distributions"
category: "math - probability"
tags: [math,probability]
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

## Geometric Distribution : $$ X \sim Geom(p) $$

Story: A sequence of independent Bernoulli trials with the same success probability p. Let X be # of failures before the successful trial.

$$ 
\text{PMF:} \ P(X = k) = q^k \times p
\\
E(X) = \frac{q}{p}
$$

---

## Negative Binomial distribution : $$ X \sim NBin(r,p) $$

Story: A sequence of independent Bernoulli trials with the same success probability p. Let X be # of failures before the rth trial.

$$ 
\text{PMF:} \ P(X = n) = \binom{n + r -1}{r - 1} p^r \times q^n
\\
E(X) = r \times \frac{q}{p}
$$

---

## Poisson Distribution : $$ X \sim Pois(\lambda) $$

$$
\text{PMF:} \ P(X = k) = e^{-\lambda} \times \frac{\lambda^k}{k!}, k \in \{ 0, 1, 2,... \}
\\
\lambda \ \text{ is the rate parameter}
\\
E(X) = \lambda
$$

Valid PMF:

$$
\sum_{k=0}^\infty e^{-\lambda} \times \frac{\lambda^k}{k!} = 
\\
e^{-\lambda} \times \sum_{k=0}^\infty \frac{\lambda^k}{k!} =
\\
e^{-\lambda} \times e^{\lambda} = 1
$$

> [Taylor Series](https://en.wikipedia.org/wiki/Taylor_series)
> $$
> e^x = \sum_{n=0}^\infty \frac{x^n}{n!} = 1 + x + \frac{x^2}{2!} + \frac{x^3}{3!} + ...
> $$

E(X) = value __times__ probability of the value

$$
E(X) 
= e^{-\lambda} \sum_{k=0}^\infty k \times \frac{\lambda^k}{k!} 
= \lambda e^{-\lambda} \sum_{k=1}^\infty \frac{\lambda^{k-1}}{(k-1)!}
= \lambda e^{-\lambda} e^{\lambda} = \lambda
$$

---