
---
layout: post
title: "C++ Notes C17 Construction Cleanup Copy and Move"
description: ""
category: programming
tags: [c++]
---

在閱讀 The C++ Programming Language 4th Edition - Bjarne Stroustrup 過程中的紀錄。

# 17.1 - Introduction

```cpp
class X {
    X(Sometype);              // ordinary constructor
    X();                      // default constructor
    X(const X&);              // copy constructor
    X(X&&);                   // move constructor
    X& operator=(const X&);   // copy assignment: clean up target and copy
    X& operapor=(X&&);        // move assignment: clean up target and move
    ~X();                     // destructor: clean up
};
```

# 17.2 - Constructor and Destructors


