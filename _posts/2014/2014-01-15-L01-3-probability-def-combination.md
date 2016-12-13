---
layout: post
title: "L01 L02 L03 - Prob. Definition, Combination"
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

> Property 1 : $$ P(A) = 1 - P(A^c) $$

##### c:complement

> Property 2 : $$ if  A \subseteq B, then \ P(A) \le P(B) $$ 

> Property 3 : $$ P(A \cup B) = P(A) + P(B) - P(A \cap B) $$ 

##### Inclusion-Exclusion rule

> Property 3* : 

$$
\begin{align} 
P(A \cup B \cup C)
& = P(A) + P(B) + P(C) \\ 
& - P(A \cap B) - P(B \cap C) - P(C \cap A) \\ 
& + P(A \cap B \cap C)  
\end{align}
$$

$$
\begin{align}
P(A_1 \cup A_2 \cup \cdots \cup A_n)
& = \sum_{i=1}^n P(A_i) \\
& - \sum_{i<j} P(A_i \cap A_j) \\ 
& + \sum_{i<j<k} P(A_i \cap A_j \cap A_k) \\
& - \cdots \\
& (-1)^{n+1} P(A_1 \cap A_2 \cap \cdots \cap A_n)
\end{align}
$$

proof 1 : $$ 1 = P(S) = P(A \cup A^c) = P(A) + P(A^c) \ since \ A \cap A^c = \emptyset  $$

proof 2 : $$ B = A \cup ( A^c \cap B ), P(B) = P(A) + P(A^c \cap B) \ge P(A) $$, since A and (A^c & B) are disjoint.

<canvas id="myCanvas" width="600" height="200" style="border:1px solid #d3d3d3;">
Your browser does not support the HTML5 canvas tag.</canvas>

<script>
function drawCircle(x,y,color) {
	var c = document.getElementById("myCanvas");
	var ctx = c.getContext("2d");
	ctx.globalAlpha = 0.3
	ctx.beginPath();
	ctx.arc(x, y, 50, 0, 2 * Math.PI);
	ctx.fillStyle = color;
	ctx.fill();
	ctx.lineWidth = 2;
	ctx.stroke();
}

drawCircle(100,75,'blue');
drawCircle(175,75,'yellow');

drawCircle(400,75,'blue');
drawCircle(475,75,'yellow');
drawCircle(437.5,125,'red');

</script>

#### Birthday Problem : 在 k 人中，有两人以上同一天生日的几率为？

##### 假设每天有人出生的几率相同

if k > 365, Prob = 1

##### Pigeonhole principle : 有n个笼子和n+1只鸽子，鸽子都关在笼中；至少有一个笼子里有两只鸽子以上。

每个人生日都不同 的 组合方式有: 365! / (365-k)!

##### 第一个人可选365天中任何一天，第二人剩364天可选...

所有的可能组合为: 365^k

##### 每个人都可能在 365 天中任何一天出生

Pr(至少有两人生日相同) = 1 - Pr(每个人生日都不同) = $$ 1 - \frac{365!}{(365-k)!} \frac{1}{365^k} $$

```python
def docal(k):
    import math
    case_all = pow(365,k)
    case_no_match = math.factorial(365) / math.factorial(365-k)
    pr = 1 - (case_no_match / case_all)
    print('Pr(%d人中至少有两人同天生日): %f' % (k, pr))
[docal(x) for x in range(20,26)]
# Pr(21人中至少有两人同天生日): 0.443688
# Pr(22人中至少有两人同天生日): 0.475695
# Pr(23人中至少有两人同天生日): 0.507297
# Pr(24人中至少有两人同天生日): 0.538344
```

#### Capture-recapture

林中有 N 头鹿，第一次随机捕捉 n 头鹿，打上标记；第二次随机捕捉 m 头鹿。问：第二次捕捉到的m头鹿中，刚好有 k 头鹿有打上标记的几率为？

```text
n=3 . .   .
    A B C D E F G
m=4   ^   ^ ^ ^
k=2   O   O

第二次采样正好有k个标记的组合共有：在 n 中取到 k 个，在剩下的 N - n 中取到 m - k 个的方式；C(n,k) * C(N-n, m-k)
第二次采样所有的组合有:          C(N,m) 种
```

$$
Pr(tagged=k) = \frac{\binom{n}{k} \binom{N-n}{m-k} }{\binom{N}{m}}
$$

#### De Montmort - Matching Problem

有N张标记 1...n 数字的卡片，洗牌后盖牌成一叠，取第一张牌翻面喊一，取第二张翻面喊二...，取得任一张牌与喊出数字相同则胜利，否则输。问胜利的机会有多少？

let Aj = the jth card matches. $$ P(A_1 \cup A_2 \cup \dots \cup A_n) = ? $$
$$ P(A_j) = \frac{1}{n} $$, 因为对第 j 张牌来说，出现在每一个位置的机会都相同。
$$ P(A_1 \cap A_2) = \frac{(n-2)!}{n!} = \frac{1}{n(n-1)} $$ 全部排列n!；第一张牌为一号，第二张牌为二号，剩余其他排列 (n-2)! 种
$$ P(A_1 \cap A_2 \dots \cap A_k) = \frac{(n-k)!}{n!} = \frac{1}{n(n-1)(n-2) \dots (n-k+1)} $$

$$ 
\begin{align}
P(A_1 \cup A_2 \cup \dots \cup A_n) & = \binom{n}{1} \frac{1}{n} - \binom{n}{2} \frac{(n-2)!}{n!}         & + \binom{n}{3} \frac{(n-3)!}{n!} - \dots \\
                                    & = \frac{n}{1} \frac{1}{n}  - \frac{n!}{2! (n-2)!} \frac{(n-2)!}{n!} & + \frac{n!}{3! (n-3)!} \frac{(n-3)!}{n!} - \dots \\
                                    & = 1 - \frac{1}{2!} + \frac{1}{3!} \dots + (-1)^{n+1} \frac{1}{n!} \\
                                    & = 1 - (\frac{1}{2!} - \frac{1}{3!} \dots + (-1)^{n} \frac{1}{n!}) \\
                                    & = 1 - e^{-1}
\end{align}
$$

##### Taylor series, x = -1

$$ 
e^x = \sum_{n=0}^{\infty} \frac{x^n}{n!} = 1 + x + \frac{x^2}{2!} + \frac{x^3}{3!} + \dots
$$

没有任何match，输的机会为: 

$$  
P( \cap_{j=1}^{n} A_j^c ) = 1 -  P ( \cup_{j=1}^{n} A_j ) \approx \frac{1}{e}
$$