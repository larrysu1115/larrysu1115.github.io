---
layout: post
title: "VC Dimension"
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

### VC Dimension

__the formal name of Maximum Non-Break Point__

Def.

VC dimension of H, denoted $$ d_{vc}(H) $$ is largest N for which $$ m_H(N) = 2^N $$

the most inputs H that can shatter

$$ d_{vc} $$ = 'minimum k' - 1

if $$ N \ge 2, d_{vc} \ge 2, m_H(N) \le N^{d_{vc}} $$

$$ d_{vc} $$ is the maximum that $$ m_H(N) = 2^N $$

$$ d_{vc}(H) $$ : powerfulness of H

---

### Penalty for Model Complexity

$$
\mathbb{P} [ | E_{in}(g) - E_{out}(g) | > \epsilon ] \le 4 ( 2 N )^{d_{vc}} \  exp( -\frac{1}{8} \epsilon^2 N ) = \delta
\\
\begin{align}
\delta & = 4 ( 2 N )^{d_{vc}} \  exp( -\frac{1}{8} \epsilon^2 N ) \\
\frac{\delta}{4 ( 2 N )^{d_{vc}}} & = exp( -\frac{1}{8} \epsilon^2 N ) \\
\ln \left( \frac{4 ( 2 N )^{d_{vc}}}{\delta} \right) & = -\frac{1}{8} \epsilon^2 N \\
\sqrt{\frac{8}{N} \ln \left( \frac{4 ( 2 N )^{d_{vc}}}{\delta} \right)} & = \epsilon \\
\end{align}
$$

gen. error 

$$ 
| E_{in}(g) - E_{out}(g) | \le \sqrt{\frac{8}{N} \ln \left( \frac{4 ( 2 N )^{d_{vc}}}{\delta} \right)} \\
E_{out}(g) \le E_{in}(g) + \sqrt{\frac{8}{N} \ln \left( \frac{4 ( 2 N )^{d_{vc}}}{\delta} \right)}
$$

penalty for __Model Complexity__ : $$ \frac{8}{N} \ln \left( \frac{4 ( 2 N )^{d_{vc}}}{\delta} \right) = \Omega(N,H,\delta) $$

---

### Target Distribution P(y|x)

unknown target distribution P(y\|x) containing f(x) + noise

---

### Error Measure

$$
\begin{Bmatrix}
  P(y = 1|x) & = 0.2 \\
  P(y = 2|x) & = 0.7 \\
  P(y = 3|x) & = 0.1 \\
\end{Bmatrix}
$$

__0/1 error :__

$$ err( \hat{y}, y) = [ \hat{y} \ne y ] $$

correct or incorrect ?

often for classification

$$
\hat{y} = 
\begin{Bmatrix}
  1 & avg. err = 0.8 \\
  2 & avg. err = 0.3 \\
  3 & avg. err = 0.9 \\
  1.9 & avg. err = 1.0 \\  
\end{Bmatrix}
$$


__squared error :__

$$ err( \hat{y}, y) = ( \hat{y} - y )^2 $$

how far is ^y from y ?

often for regression

$$
\hat{y} = 
\begin{Bmatrix}
  1 & avg. err = 1.1 \\
  2 & avg. err = 0.3 \\
  3 & avg. err = 1.5 \\
  1.9 & avg. err = 0.29(*) \\  
\end{Bmatrix}

\\
\\

f(x) = \sum_{y \in Y} y \  P(y | x)
$$

Algorithmic Error Measure : $$ \widehat{err} $$

---

### Weighted Pocket Algorithm

---