---
layout: post
title: "Derivatives Basis"
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

Notes from [Paul's Online Math](http://tutorial.math.lamar.edu/Classes/CalcI/DiffTrigFcns.aspx)

### Derivatives of six trig functions

<img style="float:right;width:450px;" src="/assets/img/2016-Q3/160803-derint.gif" />

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

### Derivatives of exponential and logarithm functions

$$

\begin{align}
& \frac{d}{dx} e^x      & = & \ e^x \\
& \frac{d}{dx} a^x      & = & \ a^x \ln a \\
& \frac{d}{dx} \ln x    & = & \ \frac{1}{x} \\
& \frac{d}{dx} \log_a x & = & \ \frac{1}{x \ln a}
\end{align}
$$

### Chain Rule

Notes from [Paul's Online Math](http://tutorial.math.lamar.edu/Classes/CalcI/ChainRule.aspx)

$$
F'(x) = f' \left( g(x) \right) g'(x)
$$