---
layout: post
title: "C++ Notes C11 Select Operations"
description: ""
category: programming
tags: [c++]
---

在閱讀 The C++ Programming Language 4th Edition - Bjarne Stroustrup 過程中的紀錄。

# 11.1 - Etc. Operators

## 11.1.1 - Logical Operators

## 11.1.2 - Bitwise Logical Operators

```cpp
void print_bits(string label, char a) {
    std::bitset<8> x (a);
    cout << label << ": " << x << endl;
}

int main() 
{
    char b1010 = 10;
    char b1100 = 12;
    print_bits("b1010", b1010);
    print_bits("b1100", b1100);
    print_bits("&", b1100 & b1010);
    print_bits("|", b1100 | b1010);
    print_bits("^", b1100 ^ b1010);  // XOR
    print_bits("~", ~b1100);         // Complement
    print_bits(">>1", b1100 >> 1);   // Shift
}
```

```text
b1010: 00001010
b1100: 00001100
&: 00001000
|: 00001110
^: 00000110
~: 11110011
>>1: 00000110
```

## 11.1.3 - Conditional Expressions

```cpp
max = (a<=b) ? b : a;
```

## 11.1.4 - Increment and Decrement

```cpp
void cpy(char*p, const char* q)
{
    while((*p++ = *q++));
}

int main() 
{
    char v = 'y';
    char x = 'x';
    char* q { &v };
    char* p { &x };
    cout << "p = q  :  " << (*p = *q) << endl;
    cout << "*q = " << *q << endl;
    cout << "*p = " << *p << endl;

    char str1[10] = "abcdefg";
    char* str2 = new char(10);
    
    cpy(str2, str1);
    cout << "str2 copied: " << str2 << endl;
}
```

# 11.2 - Free Store

## 11.2.1 - Memort Management

## 11.2.2 - Arrays

## 11.2.3 - Getting Memory Space

## 11.2.4 - Overloading new

### 11.2.4.1 - nothrow new

# 11.3 - Lists

## 11.3.1 - Implementation Model

## 11.3.2 - Qualified Lists

## 11.3.3 - Unqualified Lists

# 11.4 - Lambda Expressions

## 11.4.1 - Implementation Model

```cpp
class Class_print {
    ostream& os;
    int m;
    
    public:
        Class_print(ostream& s, int mm) : os(s), m(mm) {}
        void operator()(int x) const
        {
            if (x%m==0) os << x << endl;
        }
};

void func_p(const vector<int>& v, ostream& os, int m)
{
    for_each(begin(v), end(v), 
        [&os,m](int x) { if (x%m==0) os << x << endl; }
        // Class_print{os, m}
    );
}

int main() 
{
    vector<int> v1 {1,2,3,4,5,6,7,8,9};
    func_p(v1, cout, 3);
}
```

## 11.4.2 - Alternatives to Lambdas

## 11.4.3 - Capture

### 11.4.3.1 - Lambda and Lifetime

### 11.4.3.2 - Namespace Names

### 11.4.3.3 - Lambda and this

### 11.4.3.4 - mutable Lambdas

## 11.4.4 - Call and Return

```cpp
int main() 
{
    double y = 12.34;
    auto z1 = [=](int x) { return x + y; };
    auto z4 = [y]()->int { if (y > 10) return 999; else return -1; };
    cout << "z1: " << z1(2) << endl;
    cout << "z4: " << z4() << endl;
}

// z1: 14.34
// z4: 999
```

## 11.4.5 - The Type of a Lambda

`closure` object

# 11.5 - Explicit Type Conversion

- const_cast
- static_cast
- reinterpret_cast
- dynamic_cast

- narrow_cast : 轉換 Source 到 Target type, 再轉回到 Source type 之後仍然相同。

## 11.5.1 - Construction

## 11.5.2 - Named Casts

## 11.5.3 - C-Style Cast

## 11.5.4 - Function-Style Cast

最好別用 `int(x)` 進行 cast, 因為對 內建類型 來說，這樣寫就如同 `(int) x`
建議使用 `int{x}`