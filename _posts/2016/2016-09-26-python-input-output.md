---
layout: post
title: "Python - input output"
description: ""
category: programming
tags: [python]
---

#### str() v.s. repr()

```python
print('Hello World\nLine 2')
# Hello World
# Line 2
print(repr('Hello World\nLine 2'))
# 'Hello World\nLine 2'

repr(1/7)
# '0.14285714285714285'

repr((1,2, ('good','better')))
# "(1, 2, ('good', 'better'))"
str((1,2, ('good','better')))
# "(1, 2, ('good', 'better'))"
```

#### rjust, format

```python
for x in range(2,5): print(repr(x).rjust(2), repr(x**2).rjust(3), end='\n') 
# 2   4
# 3   9
# 4  16

for x in range(2,5): print('{0:2d} {1:3d}'.format(x, x**2))
# 2   4
# 3   9
# 4  16

'My name is {fn} {ln}'.format(ln='LEE',fn='Mike')
'My name is Mike LEE'

'{0:5} --- {1:5d}'.format('ABC',123)
# 'ABC   ---   123'
'{0:5} --- {1:<5d}'.format('ABC',123)
# 'ABC   --- 123  '

'Old style %10s, end.' % 'ABCDE'
'Old style      ABCDE, end.'
```

#### file

```python
with open('work.txt', 'r') as f:
... for line in f:
...     print(line, end=' ')
```

#### Serialization json

```python
x = ([1,2,3], ('tupa','tupb'))
import json
json.dumps(x)
'[[1, 2, 3], ["tupa", "tupb"]]'
f = open('j1.txt', 'w')
json.dump(x, f)
f.close()

f = open('j1.txt', 'r+')
y = json.load(f)
[[1, 2, 3], ['tupa', 'tupb']]
```
