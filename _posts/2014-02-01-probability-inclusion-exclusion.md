---
layout: post
title: "Probability - Inclusion Exclusion"
description: ""
category: "math - probability"
tags: [math,probability]
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


## Inclusion-exclusion

$$
P \Big( \bigcup\limits_{i=1}^n A_i \Big) =
\\ 
\sum_{i} P(A_i) 
- \sum_{i<j} P(A_i \bigcap A_j)
+ \sum_{i<j<k} P(A_i \bigcap A_j \bigcap A_k) 
- ...
+ (-1)^{n+1} \times P(A_1 \bigcap A_2 \bigcap ... \bigcap A_n)
\\
= 1 - \frac{1}{e}
$$

Solution: [Taylor series](https://en.wikipedia.org/wiki/Taylor_series)

<canvas id="myCanvas" width="600" height="200" style="border:1px solid #d3d3d3;">
Your browser does not support the HTML5 canvas tag.</canvas>

Example:
$$
P \Big( A \bigcup B \bigcup C \Big) =
\\
P(A) + P(B) + P(C) 
\color{firebrick}{ - P(A \bigcap B)- P(B \bigcap C)- P(A \bigcap C) }
+ P(A \bigcap B \bigcap C)
$$

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

