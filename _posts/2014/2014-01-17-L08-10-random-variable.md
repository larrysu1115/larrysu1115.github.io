---
layout: post
title: "L08~10 - Random Variable"
description: ""
category: "math - probability"
tags: [probability]
---

<script type="text/javascript" async
  src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-MML-AM_CHTML">
</script>

<script type="text/x-mathjax-config">
MathJax.Hub.Config({
  displayAlign: "left",
  displayIndent: "2em",
  tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}
});
</script>

### What is Random Variable?

`Function from sample space 'S' to the real life 'R'`.
Think X in 'X+3=7' as a constant. a Variable is not a constant, but a function.
R.V is a numerical summary of an aspect of experiment.
`Random` > experiment
`Variable` > function

#### Bernoulli Distribution: Bern(p)

A r.v. X is said to have Bern(p) distribution. 如果X只有两种可能的值 {0,1}, 而且 P(X=1)=p, P(X=0)=1-p

#### Binomial Distribution: Bin(n, p)

The distribution of # successes "X" in n independent Bern(p) trials is called Bin(n,p).
It's distribution is given by:

二項分布: __n 個獨立的 {0,1} 試驗中成功的次數的離散機率分布，其中每次試驗的成功機率為 p__。
這樣的單次成功/失敗試驗又稱為伯努利試驗。實際上，當n = 1時，二項分布就是伯努利分布。

$$ 
P(X=k) = \binom{n}{k} p^k (1-p)^{n-k} 
$$

This is the `PMF` (Probability Math Function)

$ X \sim Bin(n,p), Y \sim Bin(m,p) $ and X,Y are independent, then $ X + Y \sim Bin(m+n, p) $

Proof: X是丢n次硬币正面的次数，Y是丢m次硬币正面的次数，那么 X+Y 就是丢 m+n 次硬币正面的次数。

Sum of indicator r.v.s : 

$$ 
X = X_1 + X_2 + \dots + X_n, X_j = 
\begin{cases}
1, \text{if success} \\
0, \text{if failure}
\end{cases}
$$

`i.i.d.` : Independent, identically distributed.
`PMF` : Probability Math Function, P(X=k) "當X=k時，機率為何?", only for Discrete r.v.s
`CDF` : Cumulative Distribution Function

例如在一個有許多數字的 Sample Space, `X=7` 代表選取了所有數字為7的事件 Event。

```text
Sample Space :  15 7 5 13 9 1 8 60 7 1
Event X=7    :     7               7
Event X<=7   :     7 5      1      7 1
```

`X<=x` 也是一個事件, $ F = P(X \le x) $, F 是 CDF

#### CDF Properties

- Increasing
- Right continuous (从右方趋近)
- $ F(X) \to 0, \text{as x} \to - \infty, F(X) \to 1, \text{as x} \to \infty $
- if and only if

### Hypergeometric Distribution

#### Story 1

瓶中有 黑石頭b顆，白石頭w顆，取出n顆的機率分佈為？

令 X=取出的白石頭數量。X=k代表取出k顆的白石頭。

$$ 
PMF = P(X=k) = \frac{\binom{b}{n-k} \binom{w}{k}}{ \binom{b+w}{n} }
$$

驗證 sum PMF = 1, 利用 Vandermonde Identity, C(w+b,n) = C(w,n) X C(b,n-k)

$$
\\
\begin{align}
\sum_{k=0}^{w} P(X=k) 
= & \sum_{k=0}^{n} \frac{\binom{b}{n-k} \binom{w}{k}}{ \binom{b+w}{n} } \\ 
= & \frac{1}{ \binom{b+w}{n} } \sum_{k=0}^{n} \binom{b}{n-k} \binom{w}{k} \\
= & \frac{1}{ \binom{b+w}{n} } \times \binom{w+b}{n} = 1\\
\end{align} 
$$

#### Independence of r.v.s

X, Y are indep. r.v.s if: $ P(X \le x, Y \le y) = P(X \le x) \  P(Y \le y) $ , for all x, y.

For discrete cases:

$ P(X = x, Y = y) = P(X = x) \  P(Y = y) $

### Average (Mean), Expected Value

計算 平均數: {1,1,1,1,1,3,3,5} 可以有兩種方法
- 所有加總 / 8
- 乘以權重 : 1 * 5/8 + 3 * 2/8 + 5 * 1/8

#### Average of a discrete r.v. X : E(X)

$ E(X) = \sum_{x} x P(X=x) $, 即為加總 所有數值x乘以該數值的出現機率P(X=x)。

#### E(X) of X~Bern(p)

$ E(X) = 1 p + 0 (1-p) = p $

`Indicator of random variables`: 如果 A 發生，則為 1 ；A不發生，則為 0 。 Then, E(X) = P(A), 這也叫做 Fundamental Bridge.

將 E, P 做連結。如果想求得 P(A), 只要先訂出 i.r.v 然後求得 E(X), 即得 P(A)

#### E(X) of X~Bin(n,p)

1st Way:

$ E(X) = \sum_{k=0}^{n} k \binom{n}{k} p^k q^{n-k} $

2nd Way:

`Linearity 1`: E(X+Y) = E(X) + E(Y), event if X,Y are dependent.

`Linearity 2`: E(cX) = c E(X), if c is a constant.

Bin(n,p) 的 E(X) 是 加總 n 個 iid of Bern(p), 即為 n E(X~Bern(p)) = n p

$$ 
Y \sim Bin(n,p) \\
Y=X_1 + X_2 + \dots + X_n \\
X_j \sim Bern(p) 
$$

#### X ~ Hypergeometric

從一副牌中取 5 張, X = (# of aces)
令 Xj 為 indicator of jth card being an ace.

### X ~ Geom(p)

### X ~ NBin(r,p) :Negative Binomial

`Story` : indep. Bern(p) trials, # of failures before got r th successes. 在得到第 r 個成功前，失敗的次數。

`PMF` : $ P(X=n) = \binom{n+r-1}{r-1} p^r q^n $

`E(X)` : $ E(X) = r \frac{q}{p} $

```text
PMF:
1: 成功4次 (r)
0: 失敗6次 (n)
0100011001
# 最後一位一定是1，剩下的共有 C(n+r-1, r-1) 種方法組合

E(X):
Xj = 在得到第 r 個成功前，失敗的次數。
X1 = X ~ Geom(p) >> E(X1) = q / p
X2 = X1 + X1 (得到第一個成功前失敗的次數；加上，再等到一個成功前失敗的次數)
Xr = X1 + X1 + ... (r times) = r * X1 = r * q / p
```

#### 應用: First Success [FS]

X ~ FS(p) : 得到第一個成功前，總共硬幣投擲的次數 (失敗的次數+1次成功)
let Y = X-1, Y ~ Geom(p)  E(X) = E(Y) + E(1) = q / p + 1 = 1 / p
如果成功機率是 1/10，代表獲得第一個成功前，預期需要投擲10次。

#### 應用: Expectation - from Putnam competition

Question: Random permutaion of 1,2,3,...,n  (n >= 2).
Find the average (Expected Value) of local maximum (數字比相鄰的數字都大).

Solution:
Let Ij be the indicator r.v. of jth position having the local maximum. 1 &le; j &le; n

```text
3 2 1 4 7 5 6
^       ^   ^  : local maximum
可分為兩頭(2個數字)的比較，與中間(3個數字)的比較。
中間(n-2個位置): 三個數字如 4,7,5 ，有 1/3 的機會中間的數字最大。
兩頭(  2個位置): 兩個數字，有 1/2 的機會邊緣的數字最大。
```

$ E(I_1 + \dots + I_n) = E(I_1) + \dots + E(I_n) = (n - 2) \times \frac{1}{3} + 2 \times \frac{1}{2} $

#### 應用: St. Petersburg Paradox

Question: 投擲硬幣x次才獲得第一個正面，可獲得 2^x 元 (x包含投出正面的那一次)

Let $ Y=2^X, E(Y) = \sum_{k=1}^{\infty} 2^k q^{k-1} p = \sum_{k=1}^{\infty} 2^k \frac{1}{2^k} = \sum_{k=1}^{\infty} 1 = \infty $

但實際上金錢不是無限大的，假設有 2^40 元 （超過一兆)，期待值也不過是 $40

$$ \sum_{k=1}^{40} 1 = 40 $$

#### MISTAKE: Sympathetic Magic

不要弄混 r.v. 與 distribution

沒有意義: P(X=x) + P(Y=y)

`Word is not the thing, Map is not territory`

`r.v 是隨機造出的房子；distribution 是藍圖`
