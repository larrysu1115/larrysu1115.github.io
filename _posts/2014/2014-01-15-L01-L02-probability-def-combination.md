---
layout: post
title: "L01 - Combination, Permutation"
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
  displayIndent: "2em"
});
</script>

#### Binomial Coefficient

从 n 人中取 k 人出来，有多少种方式？

$$ C_k^n $$ ways to choose a subset of k elements, disregarding the order, from a total population of _n_.

$$ C_k^n = \frac{n!}{k!(n-k)!} $$

#### Sampling Table

Choose `r` objects out of `n`

| X     | 有顺序 Permutation | 无顺序 Combination |
| ---   | --- | --- |
| 可重复 | $$ n^k $$ | $$ C_k^{n+k-1} =  \frac{(n+k-1)!}{k!(n-1)!} $$ |
| 不重复 | $$ \frac{n!}{(n-k)!} = P(n,k) = P_k^n $$ | $$ \frac{n!}{k!(n-k)!} = C(n,r) = C_k^n $$ |


`choose k from n with repetition, no order` : 

```text
# 可以重复，无顺序；等同有 n 个箱子，要放入 k 个球。所以有 n-1 seperators, k dots, 举例:
# 第一颗球选了2次，第二颗球选了1次，第三,四,五颗球没选中。k=3, n=5
..|.|||
# 等于 (n+k-1)! 的排列，除以重复算过的顺序 k! , (n-1)!
```

#### Story Proof : Proof by interpretation, 利用举例说明。

`Identity 1` : $$ n \times C_{k-1}^{n-1} = k \times C_k^n $$

从n人中选出k人组成团队，团队中指定一人为队长，有几种组成团队的方法？以下两者相同:

- 从 n 人中先决定队长(有n种方式), 再从剩下的 n-1 人中, 选出剩余的 k-1 队员 C(n-1,k-1)
- 从 n 人中选出 k 位队员 (有 C(n,k) 种方式)，再从k个队员中决定队长 (有k种方式)

#### Story Proof

`Vandermonde Identity` : $$ \binom{m+n}{k} = \sum_{j=0}^k \binom{m}{j} \binom{n}{k-j} $$

从 m+n 人种取出 k 人的方法有多少种? 除了 C(m+n,k) 外，可以将 人群分为两组 M与N，人数分别为 m人, n人；

```text
所有的组合可能, 即为以下加总:
从M组取出0人，N组取出k  人的可能方式有 C(m,0) x C(n,k)   种
从M组取出1人，N组取出k-1人的可能方式有 C(m,1) x C(n,k-1) 种
从M组取出2人，N组取出k-2人的可能方式有 C(m,2) x C(n,k-2) 种
...
从M组取出k人，N组取出  0人的可能方式有 C(m,k) x C(n,0)   种
```

### Non Naïve definition

A Probability sample space consists of S and P,

S is a sample space.
A is an event, subset of samplespace. $$ A \subseteq S $$
P is a function which takes an event A as input, returns $$ P(A) \in [0,1] $$ as output, such that:

`Axiom 1` : $$ P(\emptyset)=0, P(S)=1 $$

`Axiom 2` : $$ P(\cup_{n=1}^{\infty}A_n) = \sum_{n=1}^{\infty} P(A_n) $$, if A1, A2, ..., An are disjoint, no overlap.
