---
layout: post
title: "C++ Notes C04 Containers and Algorithms"
description: ""
category: programming
tags: [c++]
---

在閱讀 The C++ Programming Language 4th Edition - Bjarne Stroustrup 過程中的紀錄。

# 4.1 - Libraries

## 4.1.1 - Standard-Library Overview

## 4.1.2 - The Standard-Library Headers and Namespace

列舉一些常用的 std library, Headers

# 4.2 - Strings

```cpp
// append
mystr += '\n';
```

# 4.3 - Stream I/O

## 4.3.1 - Output

## 4.3.2 - Input

```cpp
string str;
cout << "Type something:";
cin >> str;
cout << "A. Input is: " << str << "\n";
getline(cin, str);  // get the whole line, including whitespace.
cout << "B. Input is: " << str << "\n";
```

```text
Type something:abc xyz kkk
A. Input is: abc
B. Input is:  xyz kkk
```

## 4.3.3 - I/O of User-Defined Types

```cpp
struct Person {
    string name;
    int age;
};

ostream& operator<<(ostream& os, const Person& p)
{
    return os << "{\"" << p.name << "\", " << p.age << "}";
}

int main() 
{   
    Person p {"Oscar", 28};
    cout << "Here is the output" << p << "\n";
    // Here is the output{"Oscar", 28}
}
```

# 4.4 - Containers

## 4.4.1 - vector

vector 在標準中沒有要求 range check；  
如果需要，可以自己製作一個有檢查的類，或是該 c++ compiler 有提供 flag switch.

```cpp
#include <vector>

template<typename T>
class Vec: public std::vector<T> {
    public:
        using vector<T>::vector;

        T& operator[](int i)
            { return vector<T>::at(i); }
        
        const T& operator[](int i) const
            { return vector<T>::at(i); }
};

int main() 
{   
    vector<Person> v1 = \{\{ "AAA", 11 \},
                         \{ "BBB", 22 \}\};
    Vec<Person> v2    = \{\{ "AAA", 11 \},
                         \{ "BBB", 22 \}\};
    try {
        cout << "Here is the output A: " << v1[99] << "\n";
        cout << "Here is the output B: " << v2[99] << "\n";
    } catch (out_of_range) {
        cerr << "range error\n";
    } catch (...) {
        cerr << "unknown exception\n";
    }
}

// Here is the output A: {"", 0}
// Here is the output B: range error
```

## 4.4.2 - list

double-linked list. 

## 4.4.3 - map

balanced binary tree.

## 4.4.4 - unordered_map

hash map.

## 4.4.5 - Container Overview

沒特殊理由的話，用 vector 比較好。

# 4.5 - Algorithms

## 4.5.1 - Use of Iterators

`find()` 如果找不到，回傳 iterator: `end()`

Iterator 將 algorithm 與 container 分離，互不相依。

## 4.5.2 - Iterator Types

## 4.5.3 - Stream Iterators

```bash
$ cat in.txt 
bb eee xx y aa eee qq
y tttt
```

```cpp
#include <iostream>
#include <fstream>
#include <vector>
using namespace std;

template<typename T>
void print_vec(vector<T>& v) {
    for(auto& s : v) cout << s << ", ";
    cout << "\n";
}

int main() 
{   
    string from = "./in.txt";
    cout << "from file: " << from << "\n";

    ifstream is {from};
    istream_iterator<string> ii {is};
    istream_iterator<string> eos {};
    
    vector<string> b {ii, eos};
    vector<string> r (b.size());
    sort(b.begin(), b.end());
    unique_copy(b.begin(), b.end(), r.begin());

    print_vec(b);
    print_vec(r);
}
```

## 4.5.4 - Predicates

```cpp
struct Greater_than {
    int val;
    Greater_than(int v) :val{v} {}
    bool operator()(const pair<string, int>& r) { return r.second>val; }
};

int main() 
{   
    map<string, int> m { { "a", 11 }, { "b", 22 }, { "c", 33 } };

    for(map<string, int>::iterator i=m.begin(); i != m.end(); ++i)
        cout << "i: " << i->second << " ";
    cout << "\n";

    auto p = find_if(m.begin(), m.end(), Greater_than(28));
    if (p == m.end())
        cout << "Not Found!\n";
    else 
        cout << "Found : " << p->second <<"\n";
}
```

## 4.5.5 Algorithm Overview

## 4.5.6 - Container Algorithms


