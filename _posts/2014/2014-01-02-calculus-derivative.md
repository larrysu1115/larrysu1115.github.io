---
layout: post
title: "Calculus - Derivative"
description: ""
category: "math"
tags: [math]
---

<script type="text/javascript" async
  src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-MML-AM_CHTML">
</script>

<script type="text/x-mathjax-config">
MathJax.Hub.Config({
  displayAlign: "left"
});
</script>

### Definition of derivative

<img style="float:right;width:450px;" src="/assets/img/2016-Q3/160803-derint.gif" />

  $$ f' = \frac{d}{dx}f(x) = \lim_{h \to 0}\frac{f(x+h) - f(x)}{h}$$

  $$ \frac{d}{dx}cx^n = cn x^{n-1} $$


`exponential and logarithm functions`

$$
\begin{align}
& \frac{d}{dx} e^x      & = & \ e^x \\
& \frac{d}{dx} a^x      & = & \ a^x \ln a \\
& \frac{d}{dx} \ln x    & = & \ \frac{1}{x} \\
& \frac{d}{dx} \log_a x & = & \ \frac{1}{x \ln a}
\end{align}
$$

#### Chain Rule

$$
F'(x) = f' \left( g(x) \right) g'(x)
$$

#### L'Hospital's Rule
 
  $$ 
  \text{在以下状况中: (a可为real number, 正负infinity) } \\
  \lim_{x \to a} \frac{f(x)}{g(x)} = \frac{0}{0}
  \text{ 或 }
  \lim_{x \to a} \frac{f(x)}{g(x)} = \frac{\pm \infty}{\pm \infty} \\
  \text{可得} \\
  \lim_{x \to a} \frac{f(x)}{g(x)} = \lim_{x \to a} \frac{f'(x)}{g'(x)}
  $$

### Derivatives of Functions

- Add and Subtract Derivatives of Functions

  $$ (f+g)' = f' + g' $$
  
  $$ \frac{d}{dx}[f(x)-g(x)] = \frac{d}{dx}f(x) + \frac{d}{dx}g(x) $$
  
- Derivatives of Products and Powers of Functions

  $$ (fg)' = f'g + fg' $$
  
- Derivatives of Quotients of Functions

  $$(\frac{f}{g})'  = \frac{f'g - fg'}{g^2}$$
  
- The Chain Rule for Differentiating Complicated Functions

  $$ \frac{d}{dx}f(u(x)) = \frac{d}{du}f(u) \times \frac{d}{dx}u(x) $$

- for a Point(x,y)

  $$ Point(x,y), x=f(t), y=g(t) $$

  $$ \frac{dy}{dx} = \frac{dy}{dt}\frac{dt}{dx} = \frac{\frac{dy}{dt}}{\frac{dx}{dt}} $$


### Derivatives of six trig functions

base Facts

$$
\lim_{\theta \rightarrow 0} \frac{\sin \theta}{\theta} = 1
\\
\lim_{\theta \rightarrow 0} \frac{\cos \theta - 1}{\theta} = 0
$$

derivatives for 6 trigonometry:

$$
\begin{align}
\frac{d}{dx} \sin(x) & = &   & \cos(x) \\
\frac{d}{dx} \cos(x) & = & - & \sin(x) \\
\frac{d}{dx} \tan(x) & = &   & \sec^2(x) \\
\frac{d}{dx} \cot(x) & = & - & \csc^2(x) \\
\frac{d}{dx} \sec(x) & = &   & \sec(x) \ tan(x) \\
\frac{d}{dx} \csc(x) & = & - & \csc(x) \ cot(x)
\end{align}
$$
