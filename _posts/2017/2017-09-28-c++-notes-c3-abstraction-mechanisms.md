---
layout: post
title: "C++ Notes C03 Abstraction Mechanisms"
description: ""
category: programming
tags: [c++]
---

# 3.1 - Introduction

在閱讀 The C++ Programming Language 4th Edition - Bjarne Stroustrup 過程中的紀錄。

# 3.2 - Classes

## 3.2.1 - Concrete Types

### 3.2.1.1 - An Arithmetic Type

如 複數 complex number.

### 3.2.1.2 - A Container

- 如 Vector
- 在 constructor / destructor 中進行 resource allocation `new` / free `delete`，可以避免 naked new operations 的問題。

### 3.2.1.3 - Initializing Containers

- Initializer-list constructor: `std::initializer_list<double>`
- push_back(double)

## 3.2.2 - Abstract Types

## 3.2.3 - Virtual Functions

## 3.2.4 - Class Hierarchies

# 3.3 - Copy and Move

## 3.3.1 - Copying Containers

```cpp
#include <iostream>
using namespace std;

class Vector {
    public:
        Vector(int s) :elem{new double[s]}, sz{s} {}
        Vector(std::initializer_list<double> lst) :elem{new double[lst.size()]}, sz{static_cast<int>(lst.size())}
        {
            copy(lst.begin(), lst.end(), elem);
        }
        ~Vector() { delete[] elem; }

        Vector(const Vector& a);
        Vector& operator=(const Vector& a);

        double& operator[](int i) { return elem[i]; }
        int size() { return sz; }

        void print() {
            for(int i = 0; i<sz; i++) cout << elem[i] << " ";
            cout << "\n" << "size: " << sz << ", p addr: " << elem << "\n";
        }
    private:
        double* elem;
        int sz;
};

Vector::Vector(const Vector& a)
    :elem{new double[a.sz]},
    sz{a.sz}
{
    for(int i=0; i!=sz; ++i) elem[i] = a.elem[i];
    cout << "COPY CONSTRUCTOR!\n";
}

Vector& Vector::operator=(const Vector& a)
{
    double* p = new double[a.sz];
    for (int i=0; i!=a.sz; ++i)
        p[i] = a.elem[i];
    delete[] elem;
    elem = p;
    sz = a.sz;
    cout << "COPY ASSIGNMENT!\n";
    return *this;
}

int main() 
{   
    Vector v1 = {1, 2, 3};
    Vector v2 = v1;   // copy constructor 
    Vector v3(3);

    v3 = v1;          // copy assignment 
    v2[2] = 99;

    cout << "v1: "; 
    v1.print();
    cout << "v2: "; 
    v2.print();
    cout << "v3: "; 
    v3.print();
}
```

## 3.3.2 - Moving Containers

`&amp;&amp;` means `rvalue reference`

```cpp
        Vector(Vector&& a) :elem{a.elem}, sz{a.sz}
        {
            cout << "MOVE CONSTRUCTOR!\n";
            a.elem = nullptr;
            a.sz = 0;
        }

//...

int main() 
{   
    Vector v1 = {1, 2, 3};

    cout << "v1 before move: "; 
    v1.print();

    Vector v3 = std::move(v1);

    cout << "v1 after move: "; 
    v1.print();
    cout << "v3: "; 
    v3.print();
}
```

```text
v1 before move: 1 2 3
size: 3, p addr: 0x7f91ba400360
MOVE CONSTRUCTOR!
v1 after move:
size: 0, p addr: 0x0
v3: 1 2 3
size: 3, p addr: 0x7f91ba400360
```

## 3.3.3 - Resource Management

## 3.3.4 - Suppressing Operations

有些不適合 copy / move operation 的 class

```cpp
Shape(const Shape&) =delete;   // 不要 copy operation
```

# 3.4 - Templates

## 3.4.1 - Parameterized Types

要使用 for-range 的用法，需要先定義 begin(...), end(...)

```cpp
template<typename T>
T* begin(Vector<T>& x)
{
    return &x[0];
}

template<typename T>
T* end(Vector<T>& x)
{
    return begin(x) + x.size();
}

template<typename T>
void printx(Vector<T>& vs)
{
    for (auto& s : vs) cout << s << " ";
    cout << "\n";
}

int main() 
{   
    Vector<char> v1 = {'A', 'B', 'C'};
    Vector<int> v2 = {1, 2, 3};

    cout << "v1: "; 
    printx(v1);
    cout << "v2: "; 
    printx(v2);
}
```

## 3.4.2 - Function Templates

## 3.4.3 - Function Objects (functor, lambda)

## 3.4.4 - Variadic Templates

利用遞迴方式，處理不定個數的參數。 `...`

```cpp
#include <iostream>
using namespace std;

void f() {
    cout << "END function f() call\n";
}

template<typename T>
void g(T h) {
    cout << "g(" << h << ")\n";
}

template<typename T, typename... Tail>
void f(T head, Tail... tail)
{
    g(head);
    f(tail...);
}

int main() 
{   
    f(1, 2.2, "Hello", ',', "World");
}
```

```text
g(1)
g(2.2)
g(Hello)
g(,)
g(World)
END function f() call
```

## 3.4.5 - Aliases

```cpp
using size_t = unsigned int;
```