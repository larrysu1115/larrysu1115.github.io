---
layout: post
title: "C++ Notes C05 Concurrency and Utilities"
description: ""
category: programming
tags: [c++]
---

在閱讀 The C++ Programming Language 4th Edition - Bjarne Stroustrup 過程中的紀錄。

# 5.1 - Introduction

# 5.2 - Resource Management

`RAII` : Resource Acquisition Is Initialization.

# 5.2.1 - unique_ptr and shared_ptr

```cpp
// unique_ptr
X* p = new X;
unique_ptr<X> sp { new X };

// shared_ptr
shared_ptr<fstream> fp { new fstream(name, mode)};
```

# 5.3 - Concurrency

STL support: 

- thread
- mutex
- lock()
- packaged_task
- future

## 5.3.1 - Tasks and threads

## 5.3.2 - Passing Arguments

```cpp
// function
void f(vector<double>& v);

// function object
struct F {
    vector<double>& v;
    F(vector<double>& vv) : v(vv) {}
    void operator()();
};

int main()
{
    vector<double> vec1 { 1,2,3,4,5 };

    thread t1 {f, vec1};
    thread t2 {F{vec2}};
    t1.join();
    t2.join();
}
```

## 5.3.3 - Returning Results

## 5.3.4 - Sharing Data

### 5.3.4.1 - Waiting for Events

## 5.3.5 - Communicating Tasks

### 5.3.5.1 - future and promise

- promise: 設定值
- future: 取值，等待

### 5.3.5.2 - packaged_task

```cpp
#include <vector>
#include <map>
#include <future>
#include <numeric>
using namespace std;

double accum(double* beg, double* end, double init) {
    return accumulate(beg, end, init);
}

int main() 
{
    vector<double> v1 { 5, 2, 3, 4, 1, 3 };

    using Task_type = double(double*, double*, double);
    packaged_task<Task_type> pt0 {accum};

    future<double> f0 { pt0.get_future()};
    double* first = &v1[0];
    thread t0 { move(pt0), first, first+v1.size(), 0};
    cout << "sum: " << f0.get() << "\n";
}
```

### 5.3.5.3 - async()

```cpp
auto future0 = async(accum, vec.begin(), vec.end(), 0);
```

# 5.4 - Small Utility Components

## 5.4.1 - Time

## 5.4.2 - Type Functions

### 5.4.2.1 - iterator_traits

```cpp
#include <algorithm>
#include <forward_list>
#include <iostream>
#include <iterator>
#include <vector>

using namespace std;

template<typename Ran>
void sort_helper(Ran beg, Ran end, random_access_iterator_tag) {
    sort(beg, end);
}

template<typename For>
void sort_helper(For beg, For end, forward_iterator_tag) {
    // vector<decltype(*beg)> v {beg, end};
    // above line caused error, don't know the reason yet...
    vector<int> v {beg, end};
    sort(v.begin(), v.end());
    copy(v.begin(), v.end(), beg);
}

template<typename C>
    using Iterator_type = typename C::iterator;

template<typename Iter>
    using Iterator_category = typename std::iterator_traits<Iter>::iterator_category;

template<typename C>
void sort(C& c) {
    using Iter = Iterator_type<C>;
    sort_helper(c.begin(), c.end(), Iterator_category<Iter>{} );
}

void test(vector<string>& v, forward_list<int>& lst) {
    sort(lst);
    sort(v);
}

template<typename C>
void print_list(string name, const C& c) {
    cout << name << ": ";
    for(const auto& i : c) cout << i << " ";
    cout << "\n";
}

int main() 
{
    // 宣告一個 單鏈 的 forward_list
    forward_list<int> lst1 = { 9, 7, 5, 3, 1 };
    vector<string> lst2 = { "x", "b", "a", "y", "k" };
    test(lst2, lst1);
    print_list("lst1", lst1);
    print_list("lst2", lst2);
}
```

### 5.4.2.2 - Type Predicates

## 5.4.3 - pair and tuple

# 5.5 - Regular Expressions

```cpp
string raw_str = R"(\ab\cd/ef/gh)";
cout << raw_str << endl;
```

# 5.6 - Math

## 5.6.1 - Mathematical Functions and Algorithms.

```
#include <cmath>
```

## 5.6.2 - Complex Number

## 5.6.3 - Random Numbers

```cpp
#include <iostream>
#include <random>
#include <vector>

using namespace std;
int main() 
{
    default_random_engine re {};
    uniform_int_distribution<> one_to_six { 1, 20 };
    auto die = bind(one_to_six, re);
    cout << "die()= " << die() << endl;
}
```

## 5.6.4 - Vector Arithmetic

## 5.6.5 - Numeric Limits
