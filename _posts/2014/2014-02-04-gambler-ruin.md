---
layout: post
title: "Gambler's ruin"
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

## Gambler's ruin

Two gamblers, A and B, bet $1 every round.

p = P(A wins a certain round), q = 1 - p.

__Question: P(A wins all money) = ?__

Assuming A starts with $i dollars, B with $(N - i)

Random walk: 
<pre>

0         i-2  i-1  i    i+1  i+2  i         N
|----+----+----+----+----+----+----+----+----|

</pre>

p = P(going RIGHT)

absorbing states at 0 & N

---

Strategy: conditioning on the 1st step

$$ 
p_i = P( \text{A wins the game} | \text{A starts with i dollars}) 
\\
p_i = p \times p_{i+1} + q \times p_{i-1}, \text{with}\ 1 \le i \le N-1,

\begin{cases}
P_0 = 0, \\
P_N = 1
\end{cases}

\\

\text{boundary conditions:}\ p_0 = 0, p_N = 1

$$

LOTP:

case A wins a certain round and wins the game: $$ p \times p_i $$

case A lose a certain round but wins the game: $$ q \times p_{i-1} $$

Hints:

this is a [difference equation](https://en.wikipedia.org/wiki/Recurrence_relation).

[Quadratic equation](https://en.wikipedia.org/wiki/Quadratic_equation)

$$
ax^2 + bx + c = 0
\\
x = \frac{-b\pm\sqrt{b^2-4ac}}{2a}
$$

[L'Hôpital's rule](https://en.wikipedia.org/wiki/L%27H%C3%B4pital%27s_rule)

$$
\lim_{x\to c}\frac{f(x)}{g(x)} = \lim_{x\to c}\frac{f'(x)}{g'(x)}
$$

Solution:

First guess: let $$ p_i = x^i $$

$$
x^i = p \times x^{i+1} + q \times x^{i-1}
\\
px^2 - x + q = 0
\\
x = \frac{1\pm(2p-1)}{2p} \in \{ 1, \frac{q}{p} \}
\\
\text{assuming}\ p \neq q
\\
p_i = A \times (root_1)^i + B \times (root_2)^i = A1^i + B(\frac{q}{p})^i
\\
p_0 = 0 = A + B \implies B = -A
\\
p_N = 1 = A1^N + B(\frac{q}{p})^N = A \times (1 - (\frac{q}{p})^N) \implies A = \frac{1}{1 - (\frac{q}{p})^N}
\\
p_i = A1^i + B(\frac{q}{p})^i = A \times ( 1 - (\frac{q}{p})^i ) = 
\color{blue}{ \frac{ 1 - (\frac{q}{p})^i }{ 1 - (\frac{q}{p})^N }, if\ p \neq q }

\\
\text{assuming}\ p = q,
\\
x = \frac{q}{p}
\lim_{x\to 1}\frac{1-x^i}{1-x^N} 
= \lim_{x\to 1}\frac{\frac{d}{dx}(1-x^i)}{\frac{d}{dx}(1-x^N)} 
= \lim_{x\to 1}\frac{ix^{i-1}}{Nx^{N-1}}
= \color{blue}{\frac{i}{N}, if\ p = q}

\\
\\

Solution:
\\
\begin{cases}
\frac{ 1 - (\frac{q}{p})^i }{ 1 - (\frac{q}{p})^N }, & if\ p \neq q \\
\frac{i}{N}, & if\ p = q
\end{cases}

$$

let p=0.49

|N|P(A wins)|
|-|-|
|20|0.4|
|100|0.12|
|200|0.02|


---
