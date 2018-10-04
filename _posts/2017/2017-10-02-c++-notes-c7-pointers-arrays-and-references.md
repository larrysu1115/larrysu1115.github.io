---
layout: post
title: "C++ Notes C07 Pointers, Arrays and References"
description: ""
category: programming
tags: [c++]
---

在閱讀 The C++ Programming Language 4th Edition - Bjarne Stroustrup 過程中的紀錄。

# 7.1 - Introduction

- Pointer : holding address
- Reference : using address

# 7.2 - Pointers

```cpp
int* pi;           // pointer to int
char** ppc;        // pointer to pointer to char
int* ap[15];       // array of 15 elements of pointer to int
int (*fp)(char*);  // pointer to function taking argument:char* , return int
int* f(char*);     // function taking argument:char*, return a pointer to int
```

## 7.2.1 - void*

Point to an object of unknown type.

Pointers to functions and pointers to members cannot be assigned to void*

## 7.2.2 - nullptr

# 7.3 - Arrays

array 的大小必須是 constant expression.  
如果需要動態大小，用 vector.

```cpp
int a1[10];                 // in static storage

void f() {
    int a2 [20];            // on stack
    int* p = new int[40];   // on the free store
}
```

## 7.3.1 - Array Initializers

## 7.3.2 - String Literal

```cpp
sizeof("Bohr") == 5   // const char[5]
```

### 7.3.2.1 - Raw Character Strings

```cpp
string s = R"(ccc)"

string s = R"***("  words("))  ")***"
//               "  words("))  "
// 也可以有斷行
```

### 7.3.2.2 - Larger Character Sets

```cpp
L"abcd"     // type: const wchar_t[], terminated by L'\0'
```

# 7.4 - Pointers into Arrays

## 7.4.1 - Navigating Arrays

```cpp
    int a_size = 5;
    int a[] = {11,22,33,44,55};
 
    for(int i=0; i!=a_size; ++i) cout << a[i] << ", ";
    cout << endl;

    cout << "      a[2]  == " << a[2] << endl;
    cout << "*(&a[0]+2)  == " << *(&a[0]+2) << endl;
    cout << "  *(j + a)  == " << *(2 + a) << endl;
    cout << "      2[a]  == " << 2[a] << endl;

    // C standard defines:
    // a[b] == *(a + b)
```

range-for works for array of known size, does not work for array of unknown size.

```cpp
for(int x : a) use(x)
// okay for a[3]
// error inside: void funcp(int a[], int size)
```

array 是 low-level 的操作，最好避免；使用高階的 vector 就行。

## 7.4.2 - Multidimensional Arrays

`int ma[3][5]`

## 7.4.3 - Passing Arrays

# 7.5 - Pointer and const

const 對象不可被賦值 (assigned), 所以必須宣告時候就初始化 (initialized)

```cpp
const char* pc;            // 1.a  指向 constant 的 pointer
char const* pc;            // 1.b  指向 constant 的 pointer, 同 1.a
char *const cp = s;        // 2    pointer 本身是 constant
const char *const cpc = s; // 合上兩者 1+2
```

# 7.6 - Pointers and Ownership

`new` 出來的 resource 必須被 `delete`

# 7.7 - References

## 7.7.1 - Lvalue References

## 7.7.2 - Rvalue References

Lvalue: 具有識別符，名稱，指標指向的 對象。  
Rvalue: 無識別符，無變量名稱，通常是僅存於 scope 內的 臨時數值。

```cpp
template<class T> 
class vector {
    vector(const vector& r);   // copy constructor
    vector(vector&& r);        // move constructor
};

vector<string> s;
vector<string> s2 {s};           // s is Lvalue, so use copy constructor
vector<string> s2 {s + "tail"};  // s+"tail" is Rvalue, so use move constructor
```

## 7.7.3 - References to References

## 7.7.4 - Pointers and References

```cpp
Matrix operator+(const Matrix&, const Matrix&);       // valid
Matrix operator-(const Matrix*, const Matrix*);       // error: no user-defined type argument.
```




