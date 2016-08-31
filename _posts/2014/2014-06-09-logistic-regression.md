---
layout: post
title: "Logistic Regression"
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

Logistic Reg. __目标__：求解可能的几率 (Soft Binary Classification)。$$ f(x) = P(+1 \vert x) \in [0,1] $$

Linear Reg.: 求解答案的数值，任意数。

PLA: 求解 是或否 的 是非题。

### Logistic Hypothesis

<img style="width:300px;float:right;" src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/Logistic_cdf.svg/640px-Logistic_cdf.svg.png" />

linear reg. score : $$ s = \sum_{i=0}^d w_i x_i $$

logistic function $$ \theta (s) $$ : 将分数 s 转换为 0~1 之间的可能性。

features of patient: $$ x = (x_0, x_1, x2, ..., x_d) $$ ,

calculate a weighted `risk score`:

$$
s = \sum_{i=0}^{d} w_i x_i 
\\
\theta(s) = \frac{e^s}{1+e^s} = \frac{1}{1+e^{-s}}
\\
h(x) = \theta( w^T \ x ) = \frac{1}{1+exp(-w^T x)} \sim f(x) = P(y \vert x)
$$

### Cross Entropy Error

发生资料 D 为 { (x1,o), (x2,x), ..., (xn,x) } 的几率为: 

$$  
P(x_1) h(x_1) \times P(x_2) (1 - h(x_2)) \times \cdots \times P(x_N)(1 - h(x_N)) = \\
P(x_1) h(x_1) \times P(x_2) h(-x_2) \times \cdots \times P(x_N)h(-x_N) 
\\
h \varpropto \Pi_{n=1}^N h(y_n x_n)
\\
\rightarrow \max_w \text{likelihood}(w) \varpropto \ln \Pi_{n=1}^N \theta(y_n \ w^T \  x_n)
\\
\rightarrow \min_w \frac{1}{N} \sum_{n=1}^N - \ln \theta(y_n \ w^T \  x_n)
\\
\\
\theta (s) = \frac{1}{1 + exp(-s)}
\\
\rightarrow \min_w \frac{1}{N} \sum_{n=1}^N \ln ( 1 + exp(- y_n \ w^T \  x_n))
\\
\rightarrow \min_w \frac{1}{N} \sum_{n=1}^N err(w, x_n, y_n)
$$

cross-entropy error: `err(x,w,y) = ln(1 + exp(-ywx))`

### Gradient of Logistic Regression

$$
\nabla E_{in}(w) = \frac{d}{d \ w_i} E_{in}(w) = \frac{1}{N} \sum_{n=1}^{N} \theta ( - y_n w^T x_n ) ( -y_n x_n)
$$

参考 PLA 的逐步更正方式

$$
\begin{align}
w_{t+1} \leftarrow & w_t + 1 \times ( \Vert \text{sign}(w_t^T x_n) \neq y_n \Vert \cdot y_n x_n ) \\
& w_t + \eta \times v
\end{align}
$$

Gradient Descent, $$ v = - \frac{\nabla E_{in}(w_t)}{\Vert \nabla E_{in}(w_t) \Vert} $$, for small $$ \eta, w_{t+1} = w_t - \eta \ v $$

Fixed learning rate gradient descent:

$$
w_{t+1} = w_t - \eta \nabla E_{in}(w_t)
$$

### Logistic Regression Algorithm

- initial $$ w_0 $$
- For t = 0, 1, ...
    1. compute
        $$
        \nabla E_{in}(w) = \frac{1}{N} \sum_{n=1}^{N} \theta ( - y_n w_t^T x_n ) ( -y_n x_n)
        $$
    2. update by
        $$
        w_{t+1} \leftarrow w_t - \eta \nabla E_{in}(w_t)
        $$
    3. until 
        $$ \nabla E_{in} (w_{t+1}) = 0 $$ ,or enough iterations
    4. return last $$ w_{t+1} $$ as g.

> $$ \theta (s) = \frac{1}{1 + exp(-s)} $$

### Multicalss via Logistic Regression


### One-Versus-All (OVA) Decomposition

### One-Versus-One (OVO) Decomposition
