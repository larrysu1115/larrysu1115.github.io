---
layout: post
title: "R - Data Structure"
description: ""
category: programming
tags: [r]
---

### data.frame

data.frame 是由相同長度的 vector 組合而成，各個 vector 可以為不同的數據類型。

```R
name   <- c('Mary', 'Jane', 'Zoe', 'Bill')
age    <- c(18, 24, 28, 37)
gender <- factor(c('F', 'F', 'F', 'M'))
df_people <- data.frame(name=name, age=age, gender=gender)
# name age gender
# 1 Mary  18      F
# 2 Jane  24      F
# 3  Zoe  28      F
# 4 Bill  37      M
summary(df_people)
# name        age        gender
# Bill:1   Min.   :18.00   F:3
# Jane:1   1st Qu.:22.50   M:1
# Mary:1   Median :26.00
# Zoe :1   Mean   :26.75
# 3rd Qu.:30.25
# Max.   :37.00

# 篩選 age>25, 顯示 Column 2, 1, 3
df_people[df_people$age > 25, c(2,1,3)]
```
