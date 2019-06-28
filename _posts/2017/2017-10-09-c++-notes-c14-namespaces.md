
---
layout: post
title: "C++ Notes C14 Namespaces"
description: ""
category: programming
tags: [c++]
---

在閱讀 The C++ Programming Language 4th Edition - Bjarne Stroustrup 過程中的紀錄。

# 14.1 - Composition Problems

# 14.2 - Namespaces

## 14.2.1 - Explicit Qualification

Classes are namespaces

## 14.2.2 - using-Declarations

```cpp
using std::string;     // "string" means "std::string"
```

## 14.2.3 - using-Directives

```cpp
using namespace std;
```

Don't use `using-directives` in global scope.

## 14.2.4 - Argument-Dependent Lookup

## 14.2.5 - Namespaces Are Open

# 14.3 - Modularization and Interfaces

## 14.3.1 - Namespaces as Modules

## 14.3.2 - Implementations

## 14.3.3 - Interfaces and Implementations

# 14.4 - Composition Using Namespaces

## 14.4.2 - Namespace Aliases

## 14.4.3 - Namespace Composition

## 14.4.4 - Composition and Selection

## 14.4.5 - Namespaces and Overloading

避免將 using-directives 放在 header files，因為容易造成 name clashes.

```cpp
using namespace A;
```

## 14.4.6 - Versioning

## 14.4.7 - Nested Namespaces

## 14.4.8 - Unnamed Namespaces
