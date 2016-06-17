---
layout: post
title: "Basics of Combinations and Permutation"
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

### Permutations

   Ordered combination.
   
   1. Permutation with repetition:
      Choose __n__ things for __r__ times
      $$ n^r $$
   
   2. Permutation without repetition:
      Take __r__ balls from a pool of __n__ balls. How many permutation?
      $$ \frac{n!}{(n-r)!} = P(n,r) = P_{r}^{n} $$

### Combinations

   1. Combination with repetition:

      Choose __r__ scoops for __n__ flavors of icecream
      
      $$ \frac{(n+r-1)!}{r!(n-1)!} $$

   2. Combination without repetition:
      Such as lottery number (2, 5, 7, 31)
      
      Choose __r__ items from __n__.
      
      $$ \frac{n!}{r!(n-r)!} = C(n,r) = C_{r}^{n} $$ 
      