---
layout: post
title: "Data Mining - Similarity"
description: ""
category: "data-mining"
tags: [data-mining]
---

<script type="text/javascript" async
  src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-MML-AM_CHTML">
</script>

<script type="text/x-mathjax-config">
MathJax.Hub.Config({
  displayAlign: "left",
  displayIndent: "0em"
});
</script>

---

相似度的計算有 cosine similarity, Pearson correlation, Spearman rank correlation

### Cosine Similarity

- 等於 0 : 不相似
- 小於 0 : 正相關
- 大於 0 : 負相關

若將 $$D_i, D_j$$ 表達為兩個向量維度:
$$D_i = (w_{i1}, w_{i2}, \dots, w_{in})$$ ,
$$D_j = (w_{j1}, w_{j2}, \dots, w_{jn})$$ ,
則兩者的 `餘弦相似度` 為:

$$
Cos(D_i, D_j) = \frac
{\sum_{k=1}^{n} w_{ik} \times w_{jk} }
{
   \sqrt{\sum_{k=1}^{n} w_{ik}^2}
   \sqrt{\sum_{k=1}^{n} w_{jk}^2}
}
$$

如果以 $$ \vec{a}, \vec{b} $$ 來表示，則為: $$
cos \theta = \frac
{\vec{a} \cdot \vec{b}}
{\Vert{a}\Vert \  \Vert{b}\Vert}
$$

以下面的例子，餘弦相似度為 15/(sqrt(14)*sqrt(18)) = `0.945`

a = [1, 2, 3]
b = [0, 3, 3]

```python
# calculate with Python
>>> from sklearn.metrics.pairwise import cosine_similarity
>>> from scipy.sparse import csr_matrix
>>> A = csr_matrix([[1, 2, 3], [0, 3, 3], [-2, 2, 1]])
>>> cosine_similarity(A[0], A)
array([[ 1.        ,  0.94491118,  0.4454354 ]])
```