---
layout: post
title: "Python - data structure"
description: ""
category: programming
tags: [python]
---

#### Using list as Stacks

```python
# last-in, first-out
lst1 = [1,2]
lst1.append(3)
lst1.pop()
# 3
```

#### Using list as Queue

list is not efficient for queue, use `collections.deque` instead.

```python
# first-in, first-out
from collections import deque
q = deque(['A','B','C'])
q.append('D')
q.popleft()
# A
q
# deque(['B', 'C', 'D'])
```

#### List Comprehensions

for ... if ... for ... if ...

```python
for x in range(4):
    squares.append(x**2)
# squares = [0, 1, 4, 9]
squares = list(map(lambda x: x**2, range(4)))
squares = [x**2 for x in range(10)]

[(x,y) for x in [1,3] for y in [3,9] if x != y]
# [(1, 3), (1, 9), (3, 9)]

# flatten list
vec = [[1,2,3], [4,5,6], [7,8,9]]
[num for elem in vec for num in elem]
# [1, 2, 3, 4, 5, 6, 7, 8, 9]

# del - delete list
a = [1, 2, 3, 3, 4]
a[1]
# 2
del a[2:4]
a
# [1, 2, 4]
```

#### Tuple

```python
tup1 = 123, 321, 'abc'
# (123, 321, 'abc')
a, b, c = tup1
# a=123, b=321

empty = ()
single = 'hello',
# single
# ('hello',)
```

#### Sets

```python
s = {'a', 'b', 'b', 'c'}
# {'a', 'b', 'c'}
'a' in s
# True

a = set('abcde')
b = set('cdef')
a - b
# {'a', 'b'}
 a & b
# {'c', 'd', 'e'}
 a ^ b
# {'a', 'f', 'b'} # in a or b but not both

empty = set()

# set comprehension
a = {x for x in 'abbcccdef' if x not in 'def'}
# {'a', 'b', 'c'}
```

#### Dictionary

Any `immutable type` can be key

```python
d1 = {'x':11, 'y':22}
d1['z'] = 33
d1
# {'z': 33, 'y': 22, 'x': 11}
del d1['y']
d1
# {'z': 33, 'x': 11}
list(d1.keys())
# ['z', 'x']
sorted(d1.keys())
# ['x', 'z']
'x' in d1
# True

empty = {}
d2 = dict([ ('a', 11), ('b', 22), ('c', 33) ])
d2 = dict(a=11, b=22, c=33)
{'a': 11, 'b': 22, 'c': 33}

d2 = {x:x**2 for x in (2,4,6)}
# {2: 4, 4: 16, 6: 36}
```

#### Looping

```python
# dictionary : .items()
for k,v in dict(a=11,b=22,c=33).items() : 
    print('key:{}, val:{}'.format(k, v))
# key:a, val:11
# key:c, val:33
# key:b, val:22

# sequence : enumerate(...)
for i,v in enumerate(['aa','bb','cc']):
    print('index={}, value={}'.format(i,v)

# zip some sequences
quiz = ['q1', 'q2', 'q3']
ans = ['a1', 'a2', 'a3']
for q,a in zip(quiz,ans):
    print('What is {}? Answer is {}'.format(q,a))
# What is q1? Answer is a1
# What is q2? Answer is a2
# What is q3? Answer is a3
```

#### Conditions

- in, not in
- is, is not
- not

```python
# chained condition
a=1; b=2; c=2
a < b == c
# True
```