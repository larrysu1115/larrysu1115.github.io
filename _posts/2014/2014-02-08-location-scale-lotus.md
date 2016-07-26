---
layout: post
title: "Location, Scale, LOTUS"
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

---

Let $$ X = \mu + \sigma Z $$ 

$$ \mu \in \mathbb{R} $$ (mean, location)

$$ \sigma > 0 $$ (SD, scale)

Then we say $$ X \sim N(\mu, \sigma^2) $$

$$ E(X) = \mu $$

$$ Var(\mu + \sigma Z)= \sigma^2 Var(Z) = \sigma^2 $$

Standardization: $$ Z = \frac{X-\mu}{\sigma} $$

---

$$ 
Var(X) = E \left( (X-EX)^2 \right) = EX^2 - (EX)^2 \\
Var(X + c) = Var(X) \\
Var(X \times c) = c^2 \times Var(X) \\
$$

---

Find PDF of $$ N(\mu, \sigma^2) $$

$$ 
CDF: P(X \le x) = P(\frac{X-\mu}{\sigma} \le \frac{x-\mu}{\sigma}) \\
= \Phi(\frac{X-\mu}{\sigma}) \\
\Rightarrow PDF = \frac{1}{\sigma\sqrt{2\pi}} e^{-(\frac{X-\mu}{\sigma})^2/2} \\
-X = -\mu + \sigma(-Z) \sim N(-\mu, \sigma^2)
$$

later will show:

$$
\begin{align}
if \ X_j \sim N(\mu,\sigma^2) indep., 
  & X_1 + X_2 \sim N(\mu_1 + \mu_2, \sigma_1^2 + \sigma_2^2) \\
  & X_1 - X_2 \sim N(\mu_1 - \mu_2, \sigma_1^2 + \sigma_2^2) \\
\end{align}
$$

---

### 68-95-99.7% Rule

$$ 
X \sim N(\mu, \sigma^2) \\
P( |X-\mu| \le \sigma ) \approx 0.68 \\
P( |X-\mu| \le 2 \ \sigma ) \approx 0.95 \\
P( |X-\mu| \le 3 \ \sigma ) \approx 0.997
$$

---

LOTUS:

$$ X: r.v. \in \{ 0, 1, 2, ... \} $$

$$
\begin{array}{cccccc}
PMF: & P_0 & P_1 & P_2 & P_3 & ... \\
X: & 0 & 1 & 2 & 3 & ... \\
X^2: & 0^2 & 1^2 & 2^2 & 3^2 & ...
\end{array}

\\

E(X) = \sum_x x P(X=x) \\
E(X^2) = \sum_x x^2 P(X=x) \\
$$

$$ 
X \sim Pois(\lambda) \\

\begin{align}
E(X^2) & = \sum_{k=0}^{\infty} k^2 \frac{e^{-\lambda} \ \lambda^k}{k!} \\
& = e^{-\lambda} \times \lambda \ e^\lambda(\lambda + 1) \\
& = \lambda \ (\lambda + 1) \\
\end{align}
$$

$$
Var(X) = \lambda \ (\lambda + 1) - \lambda^2 = \lambda
$$

> Taylor series
> $$ \sum_{k=0}^{\infty} \frac{\lambda^k}{k!} = e^\lambda $$
> take derivatives of both sides
> multiply be lambda
> take derivatives of both sides again

$$
\begin{align}
\sum_{k=0}^{\infty} \frac{\lambda^k}{k!} & = e^\lambda \\
\sum_{k=1}^{\infty} \frac{k \ \lambda^{k-1}}{k!} & = e^\lambda \\
\lambda \sum_{k=1}^{\infty} \frac{k \ \lambda^{k-1}}{k!} & = \lambda \ e^\lambda \\
\sum_{k=1}^{\infty} \frac{k \ \lambda^k}{k!} & = \lambda \ e^\lambda \\
\sum_{k=1}^{\infty} \frac{k^2 \ \lambda^{k-1}}{k!} & = \lambda \ e^\lambda + e^\lambda = e^\lambda(\lambda + 1) \\
\sum_{k=1}^{\infty} \frac{k^2 \ \lambda^k}{k!} & = \lambda \ e^\lambda(\lambda + 1)
\end{align}
$$

---

### X ~ Bin(n,p), Find Var(X)

> if X, Y indep., Var(X+Y) = Var(X) + Var(Y)
> Binomial is sum of n indep. Bern(p)

$$ I_j \sim i.i.d. of Bern(p) $$

> $$ I_1 \times I_2 $$ : indicator of success on both trials 1st,  2nd. 

$$
\begin{align}
X & = I_1 + ... + I_n \\
X^2 & = I_1^2 + ... + I_n^2 + 2 I_1 I_2 + 2 I_1 I_3 + ... + 2 I_{n-1} I_n \\
E(X^2) & = n E(I_1^2) + 2 \binom{n}{2} E(I_1 I_2) \\
& =  n p + n ( n - 1 ) p^2 \\
& =  n p + n^2 p^2 - n p^2 \\
Var(X) & = E(X^2) - (EX)^2 = np - n p^2 = np(1-p) = npq
\end{align}
$$

---

### Prove LOTUS for discrete sample space.

Show $$ E( g(x) ) = \sum_x g(x) P(X=x) $$

$$
\sum_x g(x) P(X=x) \\
= \sum_{s \in S} g \left( X(s) \right) \times P( \{s\} ) \\

\sum_x \sum_{s: X(s)=x} g \left( X(s) \right) \times P( \{s\} ) \\
= \sum_x g(x) \sum_{s: X(s)=x} P( \{s\} ) \\
= \sum_x g(x) P(X=x)

$$

> grouped case / ungrouped case

---