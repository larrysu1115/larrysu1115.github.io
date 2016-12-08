---
layout: post
title: "Conditional Probability, Bayes' theorem"
description: ""
category: "math - probability"
tags: [probability]
---

<script type="text/javascript" async
  src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS_CHTML">
</script>

<script type="text/x-mathjax-config">
MathJax.Hub.Config({
  displayAlign: "left",
  displayIndent: "2em",
  tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}
});
</script>


## Conditional Probability

Definition:

If A and B are events with P(B) > 0, then the conditional probability of A given B:

$$ P(A|B) = \frac{P(A \cap B)}{P(B)} $$

Intuition:

$$

P(A \cap B) = \frac{3}{10}
\\
P(B) = \frac{5}{10}
\\
P(A|B) = 0.6, \text{ (5 B and 3 A)}
$$

<pre>
A            B
10101001011111  <  B  <  A
10001010010101  <  B  <  A
00111010010111  <  B
10010111011011  <  B  <  A
00110010111101  <  B
10111001001010
10101111101010
00111010011010
10110010101100
00101010010100
</pre>

---

## Bayes' theorem

$$ P(A \cap B) = P(B) \times P(A|B) = P(A) \times P(B|A) $$ 

$$ 
P(A_1,A_2,...,A_n) = P(A_1) P(A_2|A_1) P(A_3|A_1 \cap A_2) ... P(A_n| A_1 \cap A_2 \cap ... \cap A_{n-1}) 
$$

$$  
P(A|B) = \frac{P(B|A) P(A)}{P(B)}
$$

[details](https://en.wikipedia.org/wiki/Bayes%27_theorem)

---

## Law of total probability

Let $ A_1,... ,A_n $ be a partition of the sample space S (i.e., the $ A_i $ are disjoint events and their union is S), with $ P(A_i) > 0 $ for all i. Then

$$
P(B) = \sum\limits_{i=1}^{n} P(B|A_i) P(A_i)
$$

![img](https://qph.is.quoracdn.net/main-qimg-08e40c47325a6f65746eef106df0f498?convert_to_webp=true)

---

## Independence of events

Events A and B are independent if

$$ 
P(A \cap B) = P(A) \times P(B) 
$$

if P(A) > 0 and P(B) > 0, then this implies: 

$$ 
P(A|B) = P(A) 
$$

__Independence of more events__: Events A, B and C are said to be independent if all the following are true

$$
P(A \cap B) = P(A) \times P(B)
\\
P(A \cap C) = P(A) \times P(C)
\\
P(B \cap C) = P(B) \times P(C)
\\
P(A \cap B \cap C) = P(A) \times P(B) \times P(C)
$$

__conditionally independent__:

$$
P(A \cap B | C) = P(A|C) \times P(B|C)
$$


---

## pitfalls & biohazards

1. cond. independence $ \neq $ independence
2. Prosecutor’s fallacy: Should ask P(innocence\|evidence), NOT P(evidence\|innocence)

