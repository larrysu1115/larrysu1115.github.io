---
layout: post
title: "C++ Notes C06 Types and Declarations"
description: ""
category: programming
tags: [c++]
---

在閱讀 The C++ Programming Language 4th Edition - Bjarne Stroustrup 過程中的紀錄。

# 6.1 - The ISO C++ Standard

## 6.1.1 - Implementations

## 6.1.2 - The Basic Source Character Set

# 6.2 - Types

## 6.2.1 - Fundamental Types

## 6.2.2 - Booleans

```
int* p;
...
if (p) {  // p!=nullptr
    ...
}
```

## 6.2.3 - Character Types

### 6.2.3.1 - Signed and Unsigned Characters

### 6.2.3.2 - Character Literals

### 6.2.4 - Integer Types

more integer types in `<cstdint>`

### 6.2.4.1 - Integer Literals

- Decimal: 63
- Octal: 063
- Hexadecimal: 0x63

- int: 3
- unsigned int: 3U
- long: 3L

### 6.2.4.2 - Types of Integer Literals

## 6.2.5 - Floating-Point Types

### 6.2.5.1 - Floating-Point Literals

- 1.23
- 1.23e-15
- 3.1415F
- 3.1415L
- 2.9e-3L

## 6.2.6 - Prefixes and Suffixes

## 6.2.7 - void

```cpp
void f();   // function f return nothing.
void* pv;   // pointer to object of unknown type.
```

## 6.2.8 - Sizes

```cpp
    cout << "size of long: " << sizeof(1L) << endl;
    cout << "size of long long: " << sizeof(1LL) << endl;

    cout << "max float == " << numeric_limits<float>::max() << endl;
    cout << "char is signed == " << numeric_limits<char>::is_signed << endl;
    cout << "true: " << true << endl;
```

```text
size of long: 8
size of long long: 8
max float == 3.40282e+38
char is signed == 1
true: 1
```

## 6.2.9 - Alignment

# 6.3 - Declarations

## 6.3.1 - The Structure of Declarations

## 6.3.2 - Declaring Multiple Names

## 6.3.3 - Names

suggestions for naming conventions.

### 6.3.3.1 - Keywords

## 6.3.4 - Scope

- Local scope
- Class scope
- Namespace scope
- Global scope
- Statement scope
- Function scope

## 6.3.5 - Initialization

```cpp
X a1 {v};   // 建議使用這種
X a2 = {v};
X a3 = v;
X a4(v);

// trap!
auto z1 {99}   // z1 is an initializaer_list<int> !!!
auto z2 = 99   // z2 is an int

vector<int> v1 {99};  // 一個元素，值為99
vector<int> v2(99);   // 99個元素，皆為默認值0

// 最好是把默認值 {} 寫上,如:
int x {};             // 0
char buf[1024] {}     // buf[i] == 0
char* p {};           // nullptr
vector<int> v {};     // empty vector
string s {};          // ""
int* p {new int{10}}  // *p == 10
char* q { new char[1024]{} }   // q[i] == 0
```

### 6.3.5.1 - Missing Initializers

只有當使用很大的 buffer 時候，不刻意賦給初始值才有提升效能的好處。  
一般狀況下，最好賦給初始值。

`global`, `namespace`, `local static`, `static member` 的變量會被自動賦予 {} 初始值。

`local`, `heap objects` 不會自動獲得初值。

### 6.3.5.2 - Initializer Lists

## 6.3.6 - Deducting a Type: auto and decltype()

### 6.3.6.1 - The auto Type Specifier

### 6.3.6.2 - auto and {}-list

當使用 auto 宣告時候，最好使用 `=`, 不要用 `{}`, 除非是要一個 list

```cpp
auto i = 1;       //int
auto i = {1};     // list of int, one element
auto i = {1, 2};  // list of int, two elements
```

### 6.3.6.3 - The decltype() Specifier

```cpp
templace<class T, class U>
auto operator+(const Matrix<T>& a, const Matrix<U>& b)  ->  Matrix<decltype( T{}+U{} )>;
```

# 6.4 - Objects and Values

`lvalue` is an expression that refers to an object.

constants are also `lvalue`s.

## 6.4.1 - Lvalues and Rvalues

`rvalue` : a value that is not a lvalue.

- (i) Has Identity : 有變量名，指標指向，因此可辨識兩個 object 是否是同一個。
- (m) Movable : 相對 copy 來說。

- lvalue : i, !m
- rvalue : m
- prvalue : pure rvalue : !i, m
- glvalue : generalized lvalue : i
- xvalue : eXtraordinary, eXpert only : i, m

每一個 statement 必須是 lvalue 或 rvalue 的任一個；不可以都是。

## 6.4.2 - Lifetimes of Objects

- Automatic: 在 function scope 內，隨著 function 生滅的 stack 變數。
- Static: global, namespace, static 變數，在整個 program 執行期間存在。
- Free store: new / delete
- Temporary objects: like automatic
- Thread-local objects: 跟著 thread 生滅。

# 6.5 - Type Aliases

```cpp
using Pchar = char*;
using PF = int(*)(double)  //pointer to function taking a double and returning an int.

// older syntax
typedef int int32_t;        // equivalent to :  using int32_t = int;
typedef void(*PtoF)(int);   // equivalent to :  using PtoF = void(*)(int);
```
