---
layout: post
title: "C++ Notes C02 The Basics"
description: ""
category: programming
tags: [c++]
---

----------------------------------------

# C++ Notes

在閱讀 The C++ Programming Language 4th Edition - Bjarne Stroustrup 過程中的紀錄。

### Compile in macOS

```
g++ -std=c++11 -o a.out c1.cpp && ./a.out
```

## 2: A Tour of C++: The Basics

### 2.1 - Introduction

### 2.2 - The Basics

Source file >> Compile >> Object file >> Link >> Executable file

#### 2.2.1 - Hello, World!

#### 2.2.2 - Types, Variables, and Arithmetic

#### 2.2.3 - Constants

- const
- constexpr

#### 2.2.4 - Tests and Loops

#### 2.2.5 - Pointers, Arrays, and Loops

在宣告中使用 `auto&` 代表 reference, 如同 pointer, 但不需要用 `*` 就可以 access value。

```cpp
#include <iostream>
using namespace std;

int main() 
{
    int a[] = {3, 9, 27, 81}; // 宣告陣列A, 給予初始值
    int* p = &a[1];           // p 是只想 a[1] 元素位址 的 指標
    int& r = a[1];            // r 是只想 a[1] 元素的 reference
    int v = *(++p);           // p指標 下一個地址，指向的數值

    cout << "a is " << a << "\n";
    cout << "p: " << p << "\n";
    cout << "v: " << v << "\n";
    cout << "r: " << r << "\n";
}
```

```text
a is 0x7ffee63b5390
p: 0x7ffee63b5398
v: 27
r: 9
```

### 2.3 - User-Defined Types

#### 2.3.1 - Structures

#### 2.3.2 - Classes

```cpp
#include <iostream>
using namespace std;

class Vector {
    public:
        // member initializer list
        Vector(int s) :elem{new double[s] }, sz{s} {}
        // [i] return reference of ith element
        double& operator[](int i) { return elem[i]; }
        int size() { return sz; }
    private:
        double* elem;
        int sz;
};

int main() 
{
    Vector v(2);

    v[0] = 1.2;
    v[1] = 2.3;

    cout << "v: " << v[1] << "\nsize: " << v.size() << "\n";
}
```

#### 2.3.3 - Enumerations

### 2.4 - Modularity

#### 2.4.1 - Separate Compilation

#### 2.4.2 - Namespaces

#### 2.4.3 - Error Handling

##### 2.4.3.1 - Exceptions

##### 2.4.3.2 - Invariants

##### 2.4.3.3 - Static Assertions

```cpp
static_assert(size < 0, "must have some elements");
```

### 2.5 - Postscript