---
layout: post
title: "C++ Notes C08 Structures, Unions and Enumerations"
description: ""
category: programming
tags: [c++]
---

在閱讀 The C++ Programming Language 4th Edition - Bjarne Stroustrup 過程中的紀錄。

# 8.1 - Introduction

# 8.2 - Structures

```cpp
struct Addr {
    int pcode;
    const char* city;
    const char state[2];
};

void print_addr(Addr* a) {
    cout << "Addr(" << a->pcode << "," << a->city << "," << a->state << ")" << endl;
}

int main() 
{
    Addr a {123, "Hometown", {'a','b'}};
    print_addr(&a);
}
```

## 8.2.1 struct Layout

一般來說，struct 中的 member 所佔大小，可能會有留空 align 以符合 最佳化的 boundary。  
所以 sizeof(MyStruct) 可能會超過 所有 member 的大小加總。

如果要最小化 sizeof(MyStruct)，可以把 最大的 member 放在最前面。依序排下。

```cpp
struct MyStruct {  //    // size: 8
    int i;     // size: 4
    char c1;   // size: 1
    char c2;   // size: 1
};

int main() 
{
    MyStruct s {123, 'x', 'y'};
    cout << "sizeof(MyStruct): " << sizeof(s) << endl;
    cout << "sizeof(int  i): " << sizeof(s.i) << endl;
    cout << "sizeof(int c1): " << sizeof(s.c1) << endl;
    cout << "sizeof(int c2): " << sizeof(s.c2) << endl;
}

// sizeof(MyStruct): 8
// sizeof(int  i): 4
// sizeof(int c1): 1
// sizeof(int c2): 1
```

## 8.2.2 - struct Names

## 8.3.2 - Structures and Classes

struct 就是 "預設member都是public的class"。

## 8.2.4 - Structures and Arrays

## 8.2.5 - Type Equivalence

## 8.2.6 - Plain Old Data (POD)

```cpp
<type_traits>

is_pod(...)
```

## 8.2.7 - Fields

使用 bit 代表 boolean 的 true or false.  
注意通常不會較節省空間，因為要有程式邏輯處理 bit to byte。  
也不一定較快，因為轉換 bit to byte 型態也需要時間。

```cpp
struct MyStruct {     // size: 2 bytes
    char c;           // size: 1 byte
    bool flag1 : 1;   // size: 1 bit
    bool flag2 : 1;   // size: 1 bit
};

int main() 
{
    MyStruct s {'y', true, true};
    cout << "sizeof(MyStruct): " << sizeof(s) << endl;
    cout << "sizeof(c): " << sizeof(s.c) << endl;
    cout << "flag1 : " << s.flag1 << endl;
    s.flag1 = false;
    cout << "flag1 : " << s.flag1 << endl;
    cout << "flag2 : " << s.flag2 << endl;
}
```

# 8.3 - Unions

類似 struct, 但所有 member 共用空間，只可有一個 member 占用。  
不要藉由 union 來轉換型別 cast  
Bjarne 建議不要用這個危險容易出錯的語法。

## 8.3.1 - Unions and Classes

## 8.3.2 - Anonymous unions

利用 class 內含 union 來操作，判斷型別。

# 8.4 - Enumerations

## 8.4.1 - enum classes

scope 在所屬的 class 內。

```cpp
enum class Warning { green, yellow, red };

Warning a1 = Warning::green;
```

也可利用來做 bitwise 旗號的判斷。

```cpp
enum class Printer_flags {
    busy = 1,
    no_paper = 2,
    out_of_ink = 4,
    initializing = 8
}

Printer_flags status = ...;
if (status & Printer_flags::busy) ...
```

## 8.4.2 - Plain enums

scope 在當前區段裡，在 C or C++98 常見。

```cpp
enum Warning { green, yellow, red };
```