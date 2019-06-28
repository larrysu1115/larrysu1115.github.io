
---
layout: post
title: "C++ Notes C15 Source Files and Programs"
description: ""
category: programming
tags: [c++]
---

在閱讀 The C++ Programming Language 4th Edition - Bjarne Stroustrup 過程中的紀錄。

# 15.1 - Separate Compilation

# 15.2 - Linkage

在 global, namespace scope 定義的 `static` 變數，不可被其他 source file 取用。  

`const` 默認也為 internal linkage, 如要讓 const 可以被其他 source file 取用，可加上 `extern`

```cpp
// 不可從其他 translation units 存取
static int x1 = 1;
const char x2 = 'a';

// 可以從其他 translation units 存取
int x1 = 1;
extern const char x2 = 'a';
```

## 15.2.1 - File-Local Names

`static` : use internal linkage

## 15.2.2 - Header Files

## 15.2.3 - The One-Definition Rule

## 15.2.4 - Standard-Library Headers

## 15.2.5 - Linkage to Non-C++ Code

```cpp
extern "C" char∗ strcpy(char∗, const char∗);
```

## 15.2.6 - Linkage and Pointers to Functions

# 15.3 - Using Header Files

## 15.3.1 - Single-Header Organization

## 15.3.2 - Multiple-Header Organization

### 15.3.2.1 - Other Calculator Modules

### 15.3.2.2 - Use of Headers

## 15.3.3 - Include Guards

# 15.4 - Programs

## 15.4.1 - Initialization of Nonlocal Variables

## 15.4.2 - Initialization and Concurrency

## 15.4.3 - Program Termination


