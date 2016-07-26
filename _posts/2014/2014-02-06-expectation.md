---
layout: post
title: "Expectation"
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
more on CDF

CDF: $$ F(x) = P(X \le x), \text{as a function of real x } $$

---

Average of a discrete r.v. X
E: Expected

$$
E(X) = \sum_{X} X \times P(X=x) 
$$


Example:

$$
X \sim Bern(p)
\\
E(X) = 1 \times P(X=1) + 0 \times P(X=0) = p
$$

indicator of r.v

$$
X = 
\begin{cases}
1, \text{if A occurs} \\
0, \text{otherwise}
\end{cases}
\\
\text{then } \ E(X)=P(A)
$$

---
Expectation of Binomial

$$
X \sim Bin(n,p)
\\
\begin{align}
E(X) & = \sum_{k=0}^{n} k \binom{n}{k} p^k q^{n-k} \\
     & = \sum_{k=0}^{n} n \binom{n-1}{k-1} p^k q^{n-k} ,\text{hint:} k \binom{n}{k} = n \binom{n-1}{k-1} \\
     & = n p \sum_{k=1}^{n} \binom{n-1}{k-1} p^{k-1} q^{n-k} ,\text{hint: k=0 is zero, and let j=k-1} \\
     & = n p \sum_{j=0}^{n-1} \binom{n-1}{j} p^{j} q^{n-1-j} \\
     & = n p ( p + q )^{n-1} \\
     & = n p
\end{align}
$$

Can also solved by Linearity

$$
\text{Linearity:} \\
E(X+Y) = E(X) + E(Y), \text{even if X,Y are dependent} \\
E(C X) = C E(X), \text{C is a constant} \\
$$

Redo by Linearity: sum of n iid Bern(p) is $$ n \times p $$
$$
\text{Since} \ X = X_1 + X_2 + X_3 + ... + X_n, X_j \sim Bern(p)
$$

---

Expected Value of Hypergeometric

5 cards from a deck, X = (# aces)

$$
\text{Let} \ X_j \text{be indicator of jth card being an ace,} \ 1 \le j \le 5
\\
\begin{align}
E(X) & = E(X_1 + X_2 + ... + X_5)      , \text{by indicator random variable} \\
     & = E(X_1) + E(X_2) + ... + E(X_5), \text{by linearity} \\
     & = 5 \times E(X_1), \text{by symmetry} \\
     & = 5 \times P( \text{1st card is ace} ), \text{by fundamental bridge} \\
     & = \frac{5}{13}
\end{align}

$$

---

## Poisson Paradigm (Pois Approximation)

$$
\text{Events} \ A_1, A_2, ..., A_n. P(A_j) = p_j, 
\\
n \text{ is large,} \  p_j \text{'s small} 
$$ 

Events are independent or "weakly independent", then # of $$ A_j $$'s that occur is approx. $$ Pois(\lambda), \lambda = \sum_{j=1}^{n} p_j $$ 

$$
Bin(n, p), let \  n\to\infty, p \to 0, \lambda = np\ \text{is held constant.} 
\\
\text{Find what happends to } P(X=k) = \binom{n}{k} p^k (1-p)^{n-k}, k \ \text{fixed}
$$

$$
\begin{align}
P(X=k) & = \frac{n(n-1)...(n-k+1) \lambda^k }{k! \  n^k} \times (1-\frac{\lambda}{n})^n  \times (1-\frac{\lambda}{n})^{-k} \\
       & = \frac{\lambda^k}{k!} \times ( \frac{n}{n} \frac{n-1}{n} ...  \frac{n-k+1}{n} ) \times e^{-\lambda} \times 1 \\
       & = \frac{\lambda^k}{k!} \times e^{-\lambda} \\
       & = Pois PMF
\end{align}
$$


> Hints:
> $$ p = \frac{\lambda}{n} $$ 
> $$ \binom{n}{k} = \frac{n(n-1)...(n-k+1)}{k!} $$
> $$ (1 + \frac{x}{n})^n \to e^x \  as \ n \to \infty $$
> $$ (1-\frac{\lambda}{n})^{-k} \to 1 $$

---

## Birthday problem

Having n people, find approximation Prob. that there are 3 people with the same birthday.

$$ \binom{n}{3} $$ triplets of people. indicator of r.v. for each, For i,j,k, i < j < k
E(# triple matches) = $$ \binom{n}{3} \frac{1}{365^2} $$

X = # triple matches. Approx $$ Pois(\lambda), \lambda = \binom{n}{3} \frac{1}{365^2} $$

$$ P(X \ge 1) = 1 - P(X=0) \approx 1 - e^{-\lambda} \frac{\lambda^0}{0!} = 1 - e^{-\lambda} $$
