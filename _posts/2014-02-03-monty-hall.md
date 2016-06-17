---
layout: post
title: "Monty Hall problem & Simpson's paradox"
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

<script src="http://d3js.org/d3.v3.min.js"></script>

## Monty Hall problem

3 doors

![img](https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Monty_open_door.svg/220px-Monty_open_door.svg.png)

Assumptions:
- The host must always open a door that was not picked by the contestant (Mueser and Granberg 1999).
- The host must always open a door to reveal a goat and never the car.
- The host must always offer the chance to switch between the originally chosen door and the remaining closed door.

![img](https://upload.wikimedia.org/wikipedia/commons/thumb/d/de/Monty_tree_door1.svg/350px-Monty_tree_door1.svg.png)

Steps in tree diagram:
1. contestant choose a door
2. car behind which door?
3. host open which door?

What's the probability of winning a car after "Switch"? 

The moment of deciding Switch or not, we already know: __Monty open which door__

P(win\|Monty open door "2") = ?

$$
\frac{1/3}{1/6 + 1/3} = \frac{2}{3}
$$

### Solution using LOTP

__assuming we know where the car is__

S : succeeds winning the car (assuming switch)
$$ D_j $$ : Event Door j has car.

$$
P(S) = P(S|D_1) \times P(D_1) + P(S|D_2) \times P(D_2) + P(S|D_3) \times P(D_3)
\\
 = P(S|D_1) \times \frac{1}{3} + P(S|D_2) \times \frac{1}{3} + P(S|D_3) \times \frac{1}{3}
\\
 = 0 + 1 \times \frac{1}{3} + 1 \times \frac{1}{3} 
\\ 
 = \frac{2}{3} 
$$

---

## Simpson's paradox

Two kinds of candy: o & v

Two kids Coco & Fifi, each kid can have some number of candy each day.

Prefer _candy:o_ over _candy:x_.

O:pick o from jar

Each day, we have P(O) of A > P(O) of B.
Can this imply P(O) of $$ A_{day 1+2} $$ > P(O) of $$ B_{day 1+2} $$ ?

Ans: __NO__, this can ensure nothing.

|Jar  | Coco             | P(O) | prefer | Fifi    | P(O) |
|-    |-                 |-    |-|-         |-     |
|Day-1|70:o, 20:v | 0.78 |>    |  2:o,  8:v | 0.2  |
|Day-2| 9:o,  1:v | 0.9  |>    | 80:o, 10:v | 0.89 |
|Sum  |79:o, 21:v | 0.79 |__<__| 82:o, 18:v | 0.82 |




