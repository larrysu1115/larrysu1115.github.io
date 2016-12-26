---
layout: post
title: "L11~12 - Poisson Distribution"
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

### Poisson Distribution, X~Pois(&lambda;)

`Story`: ?
`PMF`: $ P(X=k) = \frac{e^{-\lambda} \lambda^k}{k!}, k \in 0,1,2,3,\dots $。 k 可為任意非負的整數

##### &lambda; is the "rate parameter", &lambda; &gt; 0

##### Taylor Series!

#### Valid PMF

$ \sum_{k=0}^{\infty} \frac{e^{-\lambda} \lambda^k}{k!} = e^{-\lambda} \times e^{\lambda} = 1 $

`E(X)`

$$
\begin{align}
E(X) & = \sum_{k=0}^{\infty} k \times \frac{e^{-\lambda} \lambda^k}{k!} \\
     & = e^{-\lambda} \sum_{k=1}^{\infty} \frac{\lambda^k}{(k-1)!}, if m = k-1 \\
     & = e^{-\lambda} \lambda \sum_{m=0}^{\infty} \frac{\lambda^m}{m!} \\
     & = e^{-\lambda} \lambda e^{\lambda} \\
     & = \lambda \\
\end{align}
$$

常用在計算成功 trials 的數量，總 trials 非常多，但是每個成功的機會很小。

- 可能是: 每小時收到的電子郵件數量
- 可能是: 某地一年發生地震的次數

# Poisson Paradigm (Pois Approximation)

Events A1, A2,..., An. P(Aj) = pj, n is large, pj is small.
Events are indep. or "weakly dependent".
Then, `# of Aj's occur is approx. Pois(&lambda;)`, &lambda; = $ \sum_{j=1}^{n} p_j $

__Binomial__ :  n 越大 p 越小時，趨近於 Poisson

Question: X ~ Bin(n,p), let n &rarr; &infin; , p &rarr; 0, &lambda;=np is held constant.
Find what happens to $ P(X=k) = \binom{n}{k} p^k q^{n-k}  $ ?

Solution: 

$$
e^x = \lim_{n \to \infty} (1 + \frac{x}{n})^n \\

\begin{align}
P(X=k) & = \binom{n}{k} p^k q^{n-k} \\
       & = \frac{n(n-1)(n-2)\dots(n-k+1)}{k!} (\frac{\lambda}{n})^k (1-\frac{\lambda}{n})^{n} (1-\frac{\lambda}{n})^{-k} \\
       & = \frac{n(n-1)(n-2)\dots(n-k+1) \times \lambda^k }{n n n \dots n k!} (1-\frac{\lambda}{n})^{n} (1-\frac{\lambda}{n})^{-k} \\
       & \lim_{n \to \infty} \frac{n(n-1)(n-2)\dots(n-k+1) \times \lambda^k }{n n n \dots n k!} (1-\frac{\lambda}{n})^{n} (1-\frac{\lambda}{n})^{-k} \\
       & = \frac{\lambda^k}{k!} (1-\frac{\lambda}{n})^{n} \\
       & = \frac{\lambda^k}{k!} e^{-\lambda} \\
\end{align}
$$

#### Example 1 : 被馬踢死的士兵

Ladislaus von Bortkiewicz 於 _小數法則_ 書中提到的經典案例：

普魯士軍團在 1875~1894 間共 20 年，14 個軍團中每年被馬踢死的士兵數量共有 196 人。
總共有 n 個[團年] = 20*14 = 280

計算前提: 

1. 在每個 [團年] 出現馬踢死亡的 `機會很小`。
2. 總 [團年] 數夠多。

在每個 [團年] 做了一次實驗，其 [發生踢死事件] 的機率為 p, 那麼發生了 k 次的機率為何？ 
為二項分佈 ~ Bin(n,p), P(X=k)

`方式 A` : 利用 Bin(n, p) 計算
X~Bin(n,p) ; X: n=280年中，每年出現死亡的機率 p = 0.7 / 280 = 0.0025 (假設每團年只可能 1人 或 0人 死)
某團年出現有 1 人死亡的機率 P(X=k) = 

平均每 [團年] 死亡人數 &alpha; = 196 / 280 = 0.7
令 &lambda; = 0.7 = n * p
如果看每個 [團年] 死亡 k 人的實際 [團年] 數，與利用 Poisson 分佈機率算出的數字相當吻合:



```R
[1] "某團年有0人死的機率 p = 0.49615 ~ 0.49659 (Pois趨近公式) = 0.49659 (Pois趨近回歸), 估計有 139.044 個[團年]死亡 0 人, 實際:144"
[1] "某團年有1人死的機率 p = 0.34818 ~ 0.34761 (Pois趨近公式) = 0.34761 (Pois趨近回歸), 估計有  97.331 個[團年]死亡 1 人, 實際: 91"
[1] "某團年有2人死的機率 p = 0.12173 ~ 0.12166 (Pois趨近公式) = 0.12166 (Pois趨近回歸), 估計有  34.066 個[團年]死亡 2 人, 實際: 32"
[1] "某團年有3人死的機率 p = 0.02827 ~ 0.02839 (Pois趨近公式) = 0.02839 (Pois趨近回歸), 估計有   7.949 個[團年]死亡 3 人, 實際: 11"
[1] "某團年有4人死的機率 p = 0.00491 ~ 0.00497 (Pois趨近公式) = 0.00497 (Pois趨近回歸), 估計有   1.391 個[團年]死亡 4 人, 實際:  2"
[1] "某團年有5人死的機率 p = 0.00068 ~ 0.00070 (Pois趨近公式) = 0.00070 (Pois趨近回歸), 估計有   0.195 個[團年]死亡 5 人, 實際:  0"
[1] "某團年有6人死的機率 p = 0.00008 ~ 0.00008 (Pois趨近公式) = 0.00008 (Pois趨近回歸), 估計有   0.023 個[團年]死亡 6 人, 實際:  0"
[1] "某團年有7人死的機率 p = 0.00001 ~ 0.00001 (Pois趨近公式) = 0.00001 (Pois趨近回歸), 估計有   0.002 個[團年]死亡 7 人, 實際:  0"

cal_recursive <- function(k, lamb) {
  if (k <= 0) {
    return(exp(-lamb))
  }
  return(cal_recursive(k-1,lamb) * lamb / k)
}

cal_pos <- function(k, lamb, n, actual) {
  e <- exp(1)

  # 利用原始Poisson公式計算 approx. poisson P(X=k)
  k_fact <- factorial(k)
  e_over_neg_lamb <- e ^ (-lamb)
  lamb_over_k <- lamb ^ k
  p <- lamb_over_k / k_fact * e_over_neg_lamb

  # 利用遞迴方式計算 approx. poisson P(X=k)
  p_recur <- rr <- cal_recursive(k=k, lamb=lamb)

  # 利用Bin(n,p)方式計算準確 P(X=k)
  rp <- lamb / 280
  r <- choose(n,k) * (rp^k) * ((1-rp)^(n-k))
  print(sprintf(
    paste('某團年有%d人死的機率',
          'p = %.5f ~ %.5f (Pois趨近公式) = %.5f (Pois趨近回歸),',
          '估計有 %7.3f 個[團年]死亡 %d 人, 實際:%3d')
    , k, r, p, p_recur, p*n, k, actual))
}
actual_nums <- c(144,91,32,11,2,0,0,0)
for (k in c(0:7)) cal_pos(k=k, lamb=0.7, n=280, actual=real_nums[k+1])
```

[source code](/src/2016/20161223-poisson-dist.R)

__Example__ : 雨滴落在畫了許多小方格的地上。是為 Binomial 分佈，但不利計算。若視作 Poisson 分佈，可方便運算。

__Example__ : n人 中至少 3人 同天生日的 approximate prob = ?

仨 為 三人組合。共有 C(n,3) 種仨組合。
A事件為 仨組合 中的三人生日都相同 的 組合數量。期望值是 (總組合數*第二及第三人可選364天): $ E(A)=\binom{n}{3} \frac{1}{364^2} $
E(A) 為精確值的公式，但數字太大不易計算；因此可以利用趨近於 Poisson 分佈的特性，求近似值。
趨近 Poisson 分佈的理由是:

- n 可能相當大
- p 同樣生日的機率相當小
- 每 仨組合 間雖非獨立事件，但是為低相依性。

X ~ Pois(&lambda;), &lambda; = $ \binom{n}{3} \frac{1}{364^2} $
P(X &ge; 1) = 1 - P(X = 0)

$$
1 - \frac{e^{-\lambda} \lambda^0}{0!} = 1 - \frac{e^{-\lambda} 1}{1} = 1 - e^{-\lambda}
$$
