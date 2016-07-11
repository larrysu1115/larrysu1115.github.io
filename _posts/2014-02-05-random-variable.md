---
layout: post
title: "Random variable"
description: ""
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

## Random variable

---

__Discrete random variable)__: A random variable X is said to be discrete if there is a finite list of values a1, a2, ..., an or an infinite list of values a1, a2, .... such that P (X = aj for some j) = 1. If X is a discrete r.v., then the finite or countably infinite set of values x such that P (X = x) > 0 is called the support of X.

- function mapping from sample space S to real life
- numeric "summary" of an aspect of the experiments(random).

---

__Probability mass function__: The probability mass function (PMF) of a discrete r.v. X is the function pX given by pX (x) = P (X = x). Note that this is positive if x is in the support of X, and 0 otherwise.

Suppose that $$ X: S \to A ( A \subseteq R ) $$ is a discrete random variable defined on a sample space S. Then the probability mass function $$ f_x: A \to [0, 1] for X $$ is defined as:

$$ f_x(x) = Pr(X = x) = Pr({s \in S : X(s) = x }) $$ 

Total probability of all hypothetical outcomes:

$$ \sum_{x \in A} f_x(x) = 1 $$

---

__Bernoulli distribution__: A random variable x is said to have Bernoulli distribution if x has only 2 possible values 0 and 1.

And P(x=1) = p, P(x=0) = 1-p

---

__Indicator random variable__: The indicator random variable of an event A is the r.v. which equals 1 if A occurs and 0 otherwise. We will denote the indicator r.v. of A by IA or I(A). Note that IA ~ Bern(p) with p = P (A).

---

__Binomial(n,p)__: The distribution of # sucesses in n independent Bern(p) trials, is called Bin(n,p), it's distribution is given by:

$$
P(X=k) = \binom{n}{k} \ p^k\ q^{n-k}
\\
X \sim Bin(n,p)
$$

---

$$
X \sim Bin(n,p)
\\
Y \sim Bin(m,p)
\\
X + Y \sim Bin(m+n, p)
$$

---

Definitions:

(1):
__X__ is # successes in __n__ independent __Bern(p)__ trial.

(2):
Sum of indicator random variables :

$$
X = X_1 + X_2 + ... + X_n,\ X_j =
\begin{cases}
1, & \text{if jth trial succeeds} \\
0, & \text{otherwise}
\end{cases}
\\
E(X) = P(A)
$$

i.i.d = Independent and Identically Distributed

(3): PMF - Probability Mass Function

$$
P(X=k) = \binom{n}{k} \ p^k\ q^{n-k}
$$

R.V.s

CDF: Cummulative distribute function

$$
X \le x\ \text{is an event}
\\
F(x) = P(X \le x), \text{then F is the CDF of X}
$$

PMF(for discrete r.v.s):

$$
P(X = a_j)\ \text{for all j}
\\
p_j = P(X = a_j)
\\
p_j \ge 0
\\
\sum_j p_j = 1

$$


hint: [Binomial theorem](https://en.wikipedia.org/wiki/Binomial_theorem)

$$
(x + y)^n = \sum_{k=0}^n \binom{n}{k} \ x^{n-k} \ y^k
$$


check:

$$
p(x=k) = \binom{n}{k} \ p^k\ q^{n-k},\ k \in \{ 0, 1, ..., n \}
\\
\sum_{k=0}^{n} \binom{n}{k} \ p^k\ q^{n-k}\ = (p+q)^n = 1
$$

Binomial Distribution

---

[Hypergeometric Distribution](https://en.wikipedia.org/wiki/Hypergeometric_distribution) : sampling without replacement : __X ~ HGeom(w, b, n)__

Having #_b_ black marbles and #w white marbles, pick a sample of _n_ marbles. What's the distribution of white marbles in the sample?

$$
P(X=k) = \frac{\binom{w}{k}\binom{b}{n-k}}{\binom{b+w}{n}}
,\ 0 \le k \le w
,\ 0 \le n-k \le b
$$

> [Vandermonde's identity](https://en.wikipedia.org/wiki/Vandermonde%27s_identity)
> 
> $$
> \binom{m+n}{r} = \sum_{k=0}^r \binom{m}{k} \binom{n}{r-k}
> $$

---

__Cumulative Distribution Function (CDF)__ of an r.v. X is the function $$ F_X  \ \text{given by} \ F_X(x) = P ( X \le x ) $$ . When there is no risk of ambiguity, we sometimes drop the subscript and just write F (or some other letter) for a CDF.

