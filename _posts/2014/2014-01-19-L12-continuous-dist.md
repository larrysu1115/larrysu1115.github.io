---
layout: post
title: "L12 - Continuous distribution"
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

---

|         |  Discrete                 | Continuous                      |
|-|-|-|
| R.V.    | X                         | X                               |
| PMF/PDF | P(X=x)                    | PDF $ f_x(x) = F_x'(x) $        |
| CDF     | $ F_x(x) = P(X \le x) $   | $ F_x(x) = P(X \le x) $         |
| E(X)    | $ E(X) = \sum_x x \times P(X=x) $ | $ E(X) = \int_{-\infty}^{\infty} x \times f_x(x) d_x  $ |
| Variance | $ Var(X) = E(X^2) - (EX)^2 $ | $ Var(X) = E(X^2) - (EX)^2 $ |
| LOTUS   | $ E g(X) = \sum_x g(x) P(X=x) $ | $ E( g(X) ) = \int_{-\infty}^{\infty} g(x) f_x(x) d_x $ |


PDF: Probability density function
Defn: a random variable X has PDF f(x) if $$ P(a \le X \le b) = \int_{a}^{b} f(x) d_x  $$
PDF 不是機率，將PDF進行 a~b 區間的積分後，才是 a~b 發生的機率。


PDF to be valid, $$ f(x) \ge 0, \int_{-\infty}^{\infty} f(x) d_x = 1 $$

$$ 
f(x_0) \times \epsilon \approx P\left( X \in ( x_0 - \frac{\epsilon}{2}, x_0 + \frac{\epsilon}{2} ) \right) \\
for\ \epsilon > 0 \ very \ small
$$

#### CDF

If X has PDF f, the `CDF is`:  $ F(x) = P(X \le x) = \int_{-\infty}^{x} f(t) \ d_t $

If X has CDF F (and X is cont. r.v.), then `PDF is`: $ f(x) = F'(x) $

> FTC : [Fundamental Theorem of Calculus](https://en.wikipedia.org/wiki/Fundamental_theorem_of_calculus)
> F'(x) = f(x)
>
> $$ P( a \le x \le b ) = \int_{a}^{b} f(x) d_x = F(b) - F(a) $$
>

#### Variance Var(X)

Var(X) 變異數 : 觀測值於平均值之間偏差值的平方的平均；用來量測 `資料分散的程度` : $ Var(X) = E(X - EX)^2 $
因為偏差值加總為零；所以先將偏差值平方，再加總就不為零，再開根號取平方根 還原本來的單位。即為標準差 S.D.

S.D. - Standard deviation: SD(X) = $ \sqrt{Var(X)} $

Another way to express Var:

$$
Var(X) \\
= E \left( X^2 - 2X(EX) + (EX)^2 \right) \\
= E(X^2) - 2E(X)E(X) + (EX)^2 \\
= E(X^2) - (EX)^2
$$

? How to compute E(X^2) ?

### Uniform Distribution : $$ X \sim Unif(a,b) $$

interval [a,b] , pick a completely random point in [a,b]

Unif: probability is proportional to length

PDF:

$$
f(x) = 
\begin{cases}
  c, & if \ a \le x \le b \\
  0, & \text{otherwise} 
\end{cases}
\\
\Rightarrow 1 = \int_{a}^{b} c \ d_x = c = \frac{1}{b-a}
$$

CDF:

$$
F(x) \\
= \int_{-\infty}^{x} \ f(t) \ d_t \\
= \int_{a}^{x} \ f(t) \ d_t \\
=
\begin{cases}
  0, & if \ x < a \\
  \frac{x-a}{b-a}, & if \ a \le x \le b \\
  1, & if \ x > b \\  
\end{cases}
$$

E(X)

$$
E(X) \\
= \int_{a}^{b} x f(x) d_x \\
= \int_{a}^{b} \frac{x}{b-a} d_x
= \frac{x^2}{2(b-a)} \big|_a^b
= \frac{b+a}{2}
$$

> $$ \int_{a}^{b} x^n\,dx = (\frac{1}{n+1}) (x^{n+1}) \big|_a^b = (\frac{1}{n+1})(b^{n+1} - a^{n+1}) $$ 

Variance

$$
let \  Y = X^2 \\
E(X^2) = E(Y) \\
= \int_{-\infty}^{\infty} x^2 f_x(x) d_x 
$$

> LOTUS : Law Of The Unconscious Statistician
> $ E( g(X) ) = \int_{-\infty}^{\infty} g(x) f_x(x) d_x $

Let U be Uniform between 0 and 1, 

$$
E(u) = 1/2 \\
E(u^2) = \int_{0}^{1} u^2 f_u(u) d_u = 1/3 \\
Var(u) = E(u^2) - (Eu)^2 = \frac{1}{3} - \frac{1}{4} = \frac{1}{12}

$$

#### Function of random variable

X 為 random variable 隨機變數, 而 Y = g(X), 則 Y 也是 random variable. 

Y 的 Range $ R_Y = \\{ g(x) \| x \in R_X \\} $; 

如果知道 X 的 PMF: $ P_X(x) $, 則 Y 的 PMF 為: $ P_Y(y) = P(Y=y) = P[g(x)=y] = \sum_{x:g(x)=y} P_X(x) $

Example: $ P_X(x=k) = 1/5 $, k = -1,0,1,2,3；若 Y = 2 \|X\|, 則 
Y 的 Range: 0,2,4,6
Y 的 PMF: 
$$
P_Y(y=k) = \begin{cases}
1/5 \ for \ k = 0,4,6  \\
2/5 \ for \ k = 2 \\
0   \ for \ \ others
\end{cases}
$$

#### LOTUS : Law Of The Unconscious Statistician

X 為 random variable 隨機變數, 而 Y = g(X)
X 的 PMF or PDF : $ P_X(x) $

`Discrete` case :Y 的 Expectation E(Y)

$$
EY = E[g(X)] = \sum_{x} g(x) P_X(x)
$$

`Continuous` case :Y 的 Expectation E(Y)

$$
EY = E[g(X)] = \int_{-\infty}^{\infty} g(x) P_X(x) d_x
$$

`Known CDF`, 如果已知 X 的 CDF: $ F_X(x) $ 則 Y 的 Expectation E(Y)

$$
EY = E[g(X)] = \int_{-\infty}^{\infty} g(x) d F_X(x)
$$

---

Uniform is Universal:
let U ~ Unif(0,1), F be a CDF (assume F is strictly incresing and continuous)

Theorem: Let $$ X = F^{-1}(u) $$, Then X ~ F. (X has CDF F)

Proof: $$ P(X \le x) = P( F^{-1} (u) \le x) = P(u \le F(x)) = F(x) $$, the length between [0,1]: F(x)

---

_Universality of Unif_

Let F be a cont. strictly increasing CDF,

Then $$ X = F^{-1}(U) \sim F $$ if $$ U \sim Unif(0,1) $$

Also: if $$ X \sim F $$, then $$ F(X) \sim Unif(0,1) $$

Example: ( Expo(1) )

$$
F(x) = 1 - e^{-x}, x > 0 \\
F(X) = 1 - e^{-X} \\
U ~ Unif(0,1) \\
\text{simulate} X ~ F \\
F'(U) = -ln(1-U) \\
1 - U \sim Unif(0,1)
$$

a + bU is Unif on some interval

---

### Indep. of r.v.s

r.v.s $$ X_1, X_2, ..., X_n $$ are indep. if 

$$
P(X_1 \le x_1, ..., X_n \le x_n) = P(X_1 \le x_1) \times ... \times P(X_n \le x_n)
$$

This is `joint CDF`

for all x_1, ..., x_n

_Descrete case_ :

$$
P(X_1 = x_1, ..., X_n = x_n) = P( X_1 = x_1) \times ... \times P( X_n = x_n)
$$

This is `joint PMF`

#### Example pairwise indep. does'nt imply indep.

X1, X2 ~ Bern(p)。 iid, X3 = 1 if X1 = X2, X3 = 0 otherwise.
X1, X2 是兩次不同的投擲硬幣正面或反面結果；X3為1如果兩次相同，否則X3為0
這些是兩兩獨立, 但是非獨立。
case 1: 知道X1, 但X2仍是 0 / 1 一半一半機率 - X1 vs X2 為獨立
case 2: 知道X1, 但X3仍是 0 / 1 一半一半機率 - X1 vs X3 為獨立
case 3: 知道X1 &amp; X2 即可確定X3 - X1,X2 vs X3 為 `非獨立`

### Normal (Gaussian) Distribution 

[CLT (Central Limit Theorem)](https://en.wikipedia.org/wiki/Central_limit_theorem): 
Sum of a lot of i.i.d. r.v. looks like a Normal Distribution

N(0,1) : Notation means MEAN is 0, and VARIANCE is 1.

N(0,1) has PDF:
$$
f(z) = c \  e^{\frac{-z^2}{2}}
$$

- z: using z as convention for Normal
- c: normalizing constant to make the area 1

_Question: c = ?_

$$
\int_{-\infty}^{\infty} e^{\frac{-z^2}{2}} d_z \\

\begin{align}
 \int_{-\infty}^{\infty} e^{\frac{-z^2}{2}} d_z \int_{-\infty}^{\infty} e^{\frac{-z^2}{2}} d_z
 & = \int_{-\infty}^{\infty} e^{\frac{-x^2}{2}} d_x \int_{-\infty}^{\infty} e^{\frac{-y^2}{2}} d_y \\
 & = \int_{-\infty}^{\infty} \int_{-\infty}^{\infty} e^{\frac{-(x^2+y^2)}{2}} d_x \  d_y \\
 & = \int_{0}^{2\pi} \int_{0}^{\infty} e^{\frac{-r^2}{2}} \  r \  d_r \  d_\theta \\
 & = \int_{0}^{2\pi} \left( \int_{0}^{\infty} e^{-u} \  d_u \right)  d_\theta \\ 
 & = \int_{0}^{2\pi} \left( 1 \right)  d_\theta \\  
 & = 2\pi
\end{align}
$$

$$
\int_{-\infty}^{\infty} e^{\frac{-z^2}{2}} d_z = \sqrt{2\pi} \\

c = \frac{1}{\sqrt{2\pi}}
$$

> r^2 = x^2 + y^2
> ![Pythagorean theorem](https://upload.wikimedia.org/wikipedia/commons/thumb/d/d2/Pythagorean.svg/220px-Pythagorean.svg.png)
> 
> multiply by _jacobian_ ?
> let u=r^2/2, du=rdr

_Mean_ :

$$
E \sim N(0,1), EZ = \frac{1}{\sqrt{2\pi}} \int_{-\infty}^{\infty} Z \  e^{\frac{-z^2}{2}} d_z = 0 \\

$$

> by symmetry
> if g(x) is an odd function, i.e., g(-x) = - g(x)
> then $$ \int_{-a}^{a} g(x) d_x = 0 $$
> ![Odd function](https://upload.wikimedia.org/wikipedia/commons/thumb/f/f5/Function_x%5E3.svg/220px-Function_x%5E3.svg.png)


_Variance_

$$
Var(Z) = E(X^2) - (EZ)^2 = E(Z^2) \\
= \frac{1}{\sqrt{2\pi}} \int_{-\infty}^{\infty} Z^2 \  e^{\frac{-z^2}{2}} d_z \\
= \frac{2}{\sqrt{2\pi}} \int_{0}^{\infty} Z \ Z \  e^{\frac{-z^2}{2}} d_z \\
= \frac{2}{\sqrt{2\pi}} \left( (uv)\big|_0^\infty + \int_0^\infty e^{-Z^2/2} d_z \right) 
, (uv)\big|_0^\infty = 0 \\
= 1
$$

> LOTUS
> even function
> integration by parts
> $$ u = z, d_u = d_z, d_v = Z \  e^{\frac{-z^2}{2}} d_z \Rightarrow v = - e^{-z^2 / 2} $$

Notation: $$ \Phi $$ is the Standard Normal CDF

$$
\Phi(Z) = \frac{1}{\sqrt{2\pi}} \int_{-\infty}^{Z} e^{-t^2 /2} d_t \\
\Phi(-Z) = 1 - \Phi(Z)
$$

_3rd Moment_:

$$
E(Z^3) = 0 \\

\int_{-\infty}^{\infty} Z^3 \  e^{-Z^2/2} \  d_Z , \ \text{is odd function}
$$

---

$$
Z \sim N(0,1), CDF \ \Phi, E(Z) = 0, Var(Z)=E(Z^2)=1, E(Z^3) = 0 \\
-Z \sim N(0,1) \\
$$

---