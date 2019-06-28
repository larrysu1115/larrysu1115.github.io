---
layout: post
title: "C++ Notes C12 Functions"
description: ""
category: programming
tags: [c++]
---

在閱讀 The C++ Programming Language 4th Edition - Bjarne Stroustrup 過程中的紀錄。

# 12.1 - Function Declarations

## 12.1.1 - Why Functions

function 行數建議在 avg 7 lines, or 40 lines

## 12.1.2 - Parts of a Function Declaration

## 12.1.3 - Function Definitions

## 12.1.4 - Returning Values

## 12.1.5 - inline Functions

## 12.1.6 - constexpr Functions

### 12.1.6.1 - constexpr and References

### 12.1.6.2 - Conditional Evaluation

## 12.1.7 - [[noreturn]] Functions

## 12.1.8 - Local Variables

# 12.2 - Argument Passing

## 12.2.1 - Reference Arguments

## 12.2.2 - Array Arguments

parameter of type : `reference to array`

```cpp
void f(int(&r)[4]) {
    cout << "1:" << r[0] << ", 2:" << r[2] << endl;
}

int main() {
    int a1[] = {1,2,3,4};
    f(a1);
    return 0;
}
```

## 12.2.3 - List Arguments

## 12.2.4 - Unspecified Number of Arguments

- use `variadic template`
- use `initializer_list`, single type
- using ellipsis: `...` 

## 12.2.5 - Default Arguments

# 12.3 - Overloaded Functions

## 12.3.1 - Automatic Overload Resolution

## 12.3.2 - Overloading and Return Type

## 12.3.3 - Overloading and Scope

## 12.3.4 - Resolution for Multiple Arguments

## 12.3.5 - Manual Overload Resolution

# 12.4 - Pre- and Post-conditions

# 12.5 - Pointer to Function

# 12.6 - Macros

## 12.6.1 - Conditional Compilation

## 12.6.2 - Predefined Macros

## 12.6.3 - Pragmas








