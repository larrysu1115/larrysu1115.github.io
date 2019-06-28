
---
layout: post
title: "C++ Notes C13 Exception Handling"
description: ""
category: programming
tags: [c++]
---

在閱讀 The C++ Programming Language 4th Edition - Bjarne Stroustrup 過程中的紀錄。

# 13.1 - Error Handling

## 13.1.1 - Exceptions

## 13.1.2 - Traditional Error Handling

## 13.1.3 - Muddling Through

## 13.1.4 - Alternative Views of Exceptions

### 13.1.4.1 - Asynchronous Events

### 13.1.4.2 - Exceptions That Are Not Errors

## 13.1.5 - When You Can't Use Exceptions

## 13.1.6 - Hierarchical Error Handling

## 13.1.7 - Exceptions and Efficiency

# 13.2 - Exception Guarantees

# 13.3 - Resource Management

將 resource 包在一個有 constructor / destructor 的 class, 這樣當 object 離開 scope, 觸發 destructor, 就可以有效利用 destructor 釋放資源。

## 13.3.1 - Finally

# 13.4 - Enforcing Invariants

# 13.5 - Throwing and Catching Exceptions

## 13.5.1 - Throwing Exceptions

### 13.5.1.1 - noexcept Functions

### 13.5.1.2 - noexcept Operator

### 13.5.1.3 - Exception Statement

## 13.5.2 - Catching Exceptions

### 13.5.2.1 - Rethrow

### 13.5.2.2 - Catch Every Exception

### 13.5.2.3 - Multiple Handlers

### 13.5.2.4 - Function try-Blocks

### 13.5.2.5 - Termination

## 13.5.3 - Exceptions and Threads

# 13.6 - A vector Implementation

```cpp
A* a = new A;
delete a;
```

equivalent:

```cpp
struct A {
    int val;
    char c;
};

int main() {
    // Allocate memory, but do not construct object
    void* a0 = ::operator new(sizeof(A));
    A* a = static_cast<A*>(a0);
    
    // Use the object
    a->val = 678;
    a->c = 'y';
    cout << "a: (" << a->val << "," << a->c << ")" << endl;

    // Deallocate object
    if (a != 0) {
        a->~A();
        ::operator delete(a);
    }
}
```

## 13.6.1 - A Simple Vector

## 13.6.2 - Representing Memory Explicitly

## 13.6.3 - Assignment

... not finish




