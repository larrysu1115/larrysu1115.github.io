---
layout: post
title: "Python - control flow"
description: ""
category: programming
tags: [python]
---

#### if ... elif ... else

```python
>>> x = input("Please enter a character: ")
Please enter a character: A
>>> if x == 'A':
...    print('Alpha')
... elif x == 'B':
...    print('Beta')
... else:
...    print('Unknown')
... 
Alpha
```

#### for loop . break . continue . pass

range(5, 10) : 5 through 9
range(0, 10, 3) : 0, 3, 6, 9
range(-10, -100, -30) : -10, -40, -70

`range` saves more space than `list`

~~~python
>>> for i in range(5):
...     print(i)

>>> a = ['a','b','c']
>>> for i in range(len(a)):
...    print(a[i], end=', ')
... 
a, b, c, 
~~~

for - else : 'else' runs when no 'break' in for loop

~~~python
for x in ["apple", "kiwi"]:
   if "b" in x:
      print('Alphabet "b" is not welcome: ', x)
      break
else:
   # 'else' runs when no 'break' in for loop 
   print('No "b" occurs', x)
~~~

pass

~~~python
>>> def initlog(*args):
...     pass   # Remember to implement this!
...
~~~

#### Functions

 variable references look up sequence:
 
1. current function's local symbol table
1. enclosing functions' local symbol table
1. global symbol table
1. finally in the table of built-in names

~~~python
>>> def myfunc(n):
...     """ docstring of myfunc, double the value of n."""
...     return n*2
... 
>>> f = myfunc
>>> f(3)
6
>>> print(print('function without return-value, returns None:'))
function without return-value, returns None:
None
>>> def demof(s, n=4, k='hello'):
...     pass
...
~~~

default value is `evaluated only once`

~~~python
>>> def f(a, L=[]):
...     L.append(a)
...     return L
... 
>>> print(f(1))
[1]
>>> print(f(2))
[1, 2]
>>>
>>> def f2(a, L=None):
...     """Do NOT share L with subsequent calls."""
...     if L is None:
...         L = []
...     L.append(a)
...     return L
... 
>>> print(f2(1))
[1]
>>> print(f2(2))
[2]
~~~

#### Keyword arguments

- *name : tuple
- **name : dictionary

~~~python
>>> def fargs(title, *args, **keywords):
...     print('title:', title)
...     for a in args:
...         print(' - arg:', a)
...     print('-' * 15)
...     for k in keywords.keys():
...         print(' ~ ', k, ':', keywords[k])
... 
>>> fargs('MY#DEMO', 'a', 'b', 3, k1='v1', k2=222)
title: MY#DEMO
 - arg: a
 - arg: b
 - arg: 3
---------------
 ~  k2 : 222
 ~  k1 : v1
~~~

Unpacking argument lists: use * for tuple, ** for dictionary

```py
>>> list(range(3, 6))
[3, 4, 5]
>>> args = [3, 6]
>>> list(range(*args))
[3, 4, 5]
```
