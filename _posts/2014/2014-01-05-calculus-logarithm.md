---
layout: post
title: "Calculus - Logarithm"
description: ""
category: "math"
tags: [math]
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

Logarithm : inverse of exponential function

$$
F(x) = 2^x \\
F^{-1}(x) = \log_2 x \\
\\
\log_2 1 = 0 \\
\log_2 2 = 1 \\
\log_2 4 = 2 \\
\log_2 32 = 5 \\
\log_2 \frac{1}{32} = -5 \\
$$

- Common Logarithm: $ \log_{10} x = \log x $ , 常用對數可以省略基底10，不寫出。
- Natual Logarithm: $ \log_e x $

#### Logarithm Identities - 對數律

- $ \log_b (1) = 0 $, b > 0 and b &ne; 1
- $ \log_b (xy) = \log_b (x) + \log_b (y) $
- $ \log_b (\frac{x}{y}) = \log_b (x) - \log_b (y) $
- $ \log_b (x^p) = p \log_b (x) $

#### Change the base

$$
\log_b (a) = \frac{\log_c (a)}{\log_c (b)} , c \gt 0, c \ne 1
\\
\log_{9} 27 = \frac{log_3 27}{log_3 9} = \frac{3}{2} = 1.5

$$

#### Common Logarithm - 常用對數

$$
\log (4) = \log (2 \times 2) = \log 2 + \log 2 = 0.301 + 0.301
\\
\log (5) = \log (10 / 2) = \log 10 - \log 2 = 1 - 0.301
\\
\\
\log A^r = r \log A
\\
10^{\log B} = B
$$

#### 換算 大數 與 科學符號

Example: 3的100次方為幾位數？其第一位數為?

```text
log 2   = 0.301   >>> 10^0.301   ~= 2
log 3   = 0.47712 >>> 10^0.47712 ~= 3
log 5   = 0.6990  >>> 10^0.699   ~= 5
log 5.1 = 0.7075  >>> 10^0.7075  ~= 5.1
log 5.2 = 0.7160  >>> 10^0.716   ~= 5.2
log 6   = 0.7781  >>> 10^0.7781  ~= 6
```

$$
3^{100} = 10^{\log(3^{100})} = 10^{100 \times \log(3)} = 10^{100 \times 0.47712} = 10^{47.712} \\
= 10^{0.712} \times 10^{47} = 5.1xxx \times 10^{47}
$$

#### 指數與對數方程式

Example: 求解 x = ? , $ \log_2(x-3) = log_4(x-1) $

`真數必須為正數`，所以 x - 3 > 0 &amp; x - 1 > 0 , 可知 x > 3

$$
\log_2(x-3) = \frac{log_2(x-1)}{log_2(4)} = \frac{log_2(x-1)}{2} \\
\log_2(x-3)^2 = \frac{log_2(x-1)}{log_2(4)} = log_2(x-1) \\
(x-2)(x-5) = 0 \\
x = 5
$$

#### Euler's number - 複利

```text
100 元 的存款，年利率 12%, 若每 x 月 計算一次利息，複利計算後，明年初有多少錢？

x = 12    >>>   100 x (1 + 0.12 / 1)^1 = 100 x 1.12^1
x =  6    >>>   100 x (1 + 0.12 / 2)^2 = 100 x 1.06^2
x =  3    >>>   100 x (1 + 0.12 / 4)^4 = 100 x 1.03^4
```

若是 年利率 100%, 每毫秒計算一次利息:

$$
\lim_{n \to \infty}(1 + \frac{1}{n})^n \to e = 2.718282...
\\
\begin{align}
(1 + \frac{1}{n})^n 
& = \binom{n}{0} (\frac{1}{n})^0 
& + \binom{n}{1} (\frac{1}{n})^1 
& + \binom{n}{2} (\frac{1}{n})^2 + \dots \\
& = 1
& + 1
& + \frac{n(n-1)}{2!n^2} + \frac{n(n-1)(n-2)}{3!n^3} + \dots \\
\end{align}
\\
\lim_{x \to \infty} 1 + 1  + \frac{n(n-1)}{2!n^2} + \frac{n(n-1)(n-2)}{3!n^3} + \dots = \\
\lim_{x \to \infty} 1 + 1  + \frac{1}{2!} + \frac{1}{3!} + \dots = e
$$

#### Monotone convergence theorem

若一數列為 `單調上升` ，並為 `有上界(Upper Bound)` 則該數列必為收斂

若一數列為 `單調下降` ，並為 `有下界(Lower Bound)` 則該數列必為收斂

#### 指數函數的微分

$$
f(x) = a^x, f'(x) = ?
\\
f'(x) 
= \lim_{\Delta x \to 0} \frac{a^{x + \Delta x} - a^x}{\Delta x}
= a^x \lim_{\Delta x \to 0} \frac{a^{\Delta x} - 1}{\Delta x}
$$

假設 a^(&Delta;x) - 1 = &Delta;x, 上面的公式極限就會趨近1，

> 等同是 a = e，結果引出 $ f'(e^x) = e^x $

下面的證明過程令 n = 1 / &Delta;x , so n &rarr; &infin;

$$
a^{\Delta x} - 1 = \Delta x \\
a^{\Delta x} = 1 + \Delta x \\
a = (1 + \Delta x)^{\frac{1}{\Delta x}} = (1 + \frac{1}{n})^n \\
a = \lim_{n \to \infty} (1 + \frac{1}{n})^n = e
$$

#### Natural Logarithm

> `Definition` : $$ f(x) = log_e x = \ln x $$

$$ \frac{d}{dx} \ln x = \frac{1}{x} $$

Prove:

$$ e^{\log_e x} = x $$
$$ e^{\ln x} = x $$
$$ \frac{d}{dx} (e^{\ln x}) = \frac{d}{dx} x $$
$$ e^{\ln x} \frac{d}{dx} (\ln x) = 1 $$
$$ \frac{d}{dx} (\ln x) = \frac{1}{e^{\ln x}} = \frac{1}{x} $$

#### 對數函數的微分

$ f(x) = log_a x = \frac{\ln x}{\ln a} $, f'(x) = $ \frac{1}{\ln a \ \  x} $


