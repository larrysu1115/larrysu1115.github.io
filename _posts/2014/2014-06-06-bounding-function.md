---
layout: post
title: "Bounding Function"
description: ""
category: "machine-learning"
tags: [machine-learning]
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

### Break Point of H

if no k inputs can be shattered by H, call k a break point for H.

$$ m_H(k) < 2^k $$

---

### Growth function 

$$ m_H(N) $$ : max number of dichotomies

| | | Break Point | $$ m_H(N) $$ |
|-|-|-|-|
| Positive rays | $$ m_H(2) = 3 < 2^2 $$ | 2 | $$ N + 1 $$ |
| Positive intervals | $$ m_H(3) = 7 < 2^3 $$ | 3 | $$ N^2/2 + N/2 + 1 $$ |
| Convex sets |                          | NA | $$ 2^N $$ |
| 2D Perceptrons | $$ m_H(4) = 14 < 2^4 $$ | 4 | ? |

---

### Bounding function 

B(N,k) maximum possible $$ m_H(N) $$ when break point = k

- B(2,2) = 3, maximum < 4
- B(3,2) = 4
- B(N,1) = 1

$$ B(N,k) = 2^N $$ for N < k

$$ B(N,k) = 2^N - 1 $$ for N = k

$$
B(N,k) = 2\alpha + \beta
\\
\alpha + \beta \le B(N-1, k)
\\
\alpha \le B(N-1, k-1)
\\
\rightarrow B(N,k) \le B(N-1,k) + B(N-1, k-1)
$$

| B(N,k) | k=1 | 2 | 3 | 4 | 6 | 6 |
|-|-|-|-|-|-|-|
| N=1 | 1 | 2 | 2 | 2 | 2 | 2 |
| 2   | 1 | 3 | 4 | 4 | 4 | 4 |
| 3   | 1 | 4 | 7 | 8 | 8 | 8 |
| 4   | 1 | <=5 | <=11 | 15 | 16 | 16 |
| 5   | 1 | <=6 | <=16 | <=26 | 31 | 32 |
| 6   | 1 | <=7 | <=22 | <=42 | <=57 | 63 |

Bounding Function: The Theorem

$$
B(N,k) \le \sum_{i=0}^{k-1} \binom{N}{i}
$$

highest term: $$ N^{k-1} $$

---

want:

$$
\mathbb{P} [ \exists h \in H s.t. | E_{in}(h) - E_{out}(h) | > \epsilon ] \le 2 \  m_H(N) \  exp( -2 \epsilon^2 N )
$$

when N large enough, ->

$$
\mathbb{P} [ \exists h \in H s.t. | E_{in}(h) - E_{out}(h) | > \epsilon ] \le 2 \times 2 \  m_H(2 N) \  exp( -2 \frac{1}{16} \epsilon^2 N )
$$

### Vapnik-Chervonenkis (VC) bound:

$$
\mathbb{P} [ \exists h \in H s.t. | E_{in}(h) - E_{out}(h) | > \epsilon ] \le 
4 \  m_H(2 N) \  exp( - \frac{1}{8} \epsilon^2 N )
$$

- replace Eout by E'in
- decompose H by kind
- use Hoeffding without replacement

---
