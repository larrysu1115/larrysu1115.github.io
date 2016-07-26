---
layout: post
title: "Basics of Derivatives and indefinite integral"
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
  displayIndent: "2em"
});
</script>

### Basic

- Definition of derivative

  $$ f' = \frac{d}{dx}f(x) = \lim_{h \to 0}\frac{f(x+h) - f(x)}{h}$$

  $$ \frac{d}{dx}cx^n = cn x^{n-1} $$

- Definition of Indefinite Integral

  $$ \int f(x) dx $$
  
  $$ \frac{d}{dx}f(x) = F(x), \int F(x) dx = f(x) + c $$
  
  $$ \int x^n dx = (\frac{1}{n+1}) x^{n+1} + c $$
  
### Properties of Indefinite Integral

  $$ \int 2 f(x) dx = 2 \int f(x) dx $$
  
  $$ \int[f(x) + g(x)] dx = \int f(x) dx + \int g(x) dx $$
  
  $$ \int (x^3+x^2+x) dx = \int x^3 dx + \int x^2 dx + \int x dx = \frac{x^4}{4} + \frac{x^3}{3} + \frac{x^2}{2} + C $$

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
  
# Common indefinite integrals

  $$ \int \frac{1}{x} dx = \ln{|x|} + c $$
  
  $$ \int 0 dx = c $$
  
  $$ \int 2 dx = 2x + c $$

  $$ \int x^a dx = \frac{x{a+1}}{a+1} + c, a \neq -1 $$
  
  $$ \int e^x dx = e^x + c $$
  
  $$ \int a^x dx = \frac{a^x}{\ln{a}} + c $$
  
  $$ \int \cos x dx = \sin x + c $$
  
  $$ \int \sin x dx = - \cos x + c $$

  $$ \int \tan x dx = \ln | \sec x | + c $$
  
  $$ \int \sec^2x\,dx = \tan x + c $$

  $$ \int \cot x dx = \ln | \sin x | + c $$
  
  $$ \int \big[ u(x) + v(x) \big] dx = \int u(x)\,dx + \int v(x)\,dx $$
  
# Definite integrals
  
  $$ \int_{a}^{b} f'(x) dx = f(b) - f(a) $$
  
  $$ F(x) \big|_{a}^{b} = F(b) - F(a) $$

  $$ \int_{a}^{b} x^n\,dx = (\frac{1}{n+1}) (x^{n+1}) \big|_a^b = (\frac{1}{n+1})(b^{n+1} - a^{n+1}) $$ 
  
  $$ \int_a^b Cf(x)\,dx = C \int_a^b f(x)\,dx $$

  $$ \int_a^b [f(x) + g(x)]\,dx = \int_a^b f(x)\,dx + \int_a^b g(x)\,dx $$
  
