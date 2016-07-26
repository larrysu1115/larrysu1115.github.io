---
layout: post
title: "Distributions of Probability - Discrete"
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


## Bernoulli : $$ X ~ Bern(p) $$

Story: A random variable x is said to have Bernoulli distribution if x has only 2 possible values 0 and 1.

$$ 
\text{PMF:} \ P(X = 1) = p, \ P(X = 0) = q
\\
E(X) = p
$$

---


## Binomial Distribution : $$ X \sim Bin(n,p) $$

Story: The distribution of # sucesses in n independent Bern(p) trials.

$$ 
\text{PMF:} \ \binom{n}{k} p^k q^{n-k}, \text{for} \ k \in \{ 0, 1, ..., n \}
\\
E(X) = np
$$

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

## Hypergeometric distribution : $$ X \sim HGeom(w, b, n) $$

Story: Sampling without replacement. Having #_b_ black marbles and #_w_ white marbles, pick a sample of _n_ marbles. What's the distribution of white marbles in the sample?

$$ 
\text{PMF:} \ 
P(X=k) = \frac{\binom{w}{k}\binom{b}{n-k}}{\binom{b+w}{n}}
,\ 0 \le k \le w
,\ 0 \le n-k \le b
\\
E(X) = \mu = \frac{nw}{w + b}
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