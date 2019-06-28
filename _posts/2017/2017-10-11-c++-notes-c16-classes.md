
---
layout: post
title: "C++ Notes C16 Classes"
description: ""
category: programming
tags: [c++]
---

在閱讀 The C++ Programming Language 4th Edition - Bjarne Stroustrup 過程中的紀錄。

# 16.1 - Introduction

# 16.2 - Class Basics

## 16.2.1 - Member Functions

## 16.2.2 - Default Copying

## 16.2.3 - Access Control

## 16.2.4 - class and struct

## 16.2.5 - Constructors

## 16.2.6 - explicit Constructors

沒有特別理由的話，單一參數的 建構子 要宣告成 explicit，才是良好的習慣。

## 16.2.7 - In-Class Initializers

## 16.2.8 - In-Class Function Definitions

## 16.2.9 - Mutability

### 16.2.9.1 - Constant Member Functions

```cpp
// const member function 不可以改變 class 內的 member 值 (y)
int Date::year() const { return y; }
```

### 16.2.9.2 - Physical and Logical Constness

有時候，const member function 仍然會需要改變 class 內部的狀態。如 string representation 是 const function, 但有個 cache 就可以避免每次都要重新建構 string, 此時就需要在 object Date 有異動時候，去修改 cache 的 string.

### 16.2.9.3 - mutable

定義 class member 為 `mutable` 就可以在 const function 中仍然可以修改這個 mutable member.

### 16.2.9.4 - Mutability through Indirection

## 16.2.10 - Self-Reference

```cpp
// 能够 chained call functions, 如 
d.add_day(1).add_month(1);

// 讓 function 回傳 object ref
Date& Date::add_day(int n) {
    ...
    return *this;
}
```

## 16.2.11 - Member Access

## 16.2.12 - static Members

## 16.2.13 - Member Types

# 16.3 - Concrete Classes

## 16.3.1 - Member Functions

## 16.3.2 - Helping Functions

## 16.3.3 - Overloaded Operators

## 16.3.4 - The Significance of Concrete Classes

** 16.3 試做一次 **

