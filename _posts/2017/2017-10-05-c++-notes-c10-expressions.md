---
layout: post
title: "C++ Notes C10 Expressions"
description: ""
category: programming
tags: [c++]
---

在閱讀 The C++ Programming Language 4th Edition - Bjarne Stroustrup 過程中的紀錄。

# 10.1 - Introduction

# 10.2 - A Desk Calculator

## 10.2.1 - The Parser

## 10.2.2 - Input

## 10.2.3 - Low-Level Input

## 10.2.4 - Error Handling

## 10.2.5 - The Driver

## 10.2.6 - Headers

## 10.2.7 - Command-Line Arguments

## 10.2.8 - A Note on Style

# 10.3 - Operator Summary

## 10.3.1 - Results

## 10.3.2 - Order of Evaluation

## 10.3.3 - Operator Precedence

# 10.4 - Constant Expressions

在 編譯過程 決定的固定值。

## 10.4.1 - Symbolic Constants

## 10.4.2 - const in Constant Expressions

## 10.4.3 - Literal Types

## 10.4.4 - Reference Arguments

## 10.4.5 - Address Constant Expressions

# 10.5 - Implicit Type Conversion

## 10.5.1 - Promotions

## 10.5.2 - Conversions

```cpp
void f(double d) {
    char c {d};     // error! {}-initializer 不允許 narrowing conversion
    // 如果需要 narrowing conversion, 考慮使用: narrow_cast<>()
}
```

### 10.5.2.1 - Integral Conversions

### 10.5.2.2 - Floating-Point Conversions

### 10.5.2.3 - Pointer and Reference Conversions

### 10.5.2.4 - Pointer-to-Member Conversions

### 10.5.2.5 - Boolean Conversions

### 10.5.2.6 - Floating-Integral Conversions

## 10.5.3 - Usual Arithmetic Conversions













