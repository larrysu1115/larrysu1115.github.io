---
layout: post
title: "Python - number, string, list"
description: ""
category: programming
tags: [python]
---

### Basic calculation

~~~python
>>> 17 / 3   # classic division returns a float
5.666666666666667
>>> 17 // 3  # floor division discards the fractional part
5
>>> 5 ** 2   # 5 squared
25
>>> _        # ‘_’ is last printed expression in interactive mode 
25
~~~

### String

~~~python
>>> print('ab\tc')
ab	c
>>> print(r'ab\tc')  # raw string with 'r'
ab\tc
>>> print("""
... a
... b
... """)     # triple-quotes, without \

a
b

>>> print("""\
... a
... b\
... """)     # triple-quotes, with \, remove new-line character.
a
b
>>> 2 * 'ab' + '_123'  # string repeat with '*', concatenate with '+'
'abab_123'
>>> 'ab' '_xyz'        # automatically concatenated
'ab_xyz'
>>> word = 'Python'
 +---+---+---+---+---+---+
 | P | y | t | h | o | n |
 +---+---+---+---+---+---+
 0   1   2   3   4   5   6
-6  -5  -4  -3  -2  -1
>>> word[0]
'P'
>>> word[-2]  # second-last character: Pyth{O}n
'o'
>>> word[1:3] # 1~2 chars, 3rd char excluded: P{yt}hon
'yt'
>>> word[2:]  # 2~last chars: Py{thon}
'thon'
>>> word[:2]  # 0~1 chars, 2nd char excluded: {Py}thon
'Py'
>>> word[:2] + word[2:]
'Python'
>>> a,b = 1,2 # multiple assignment
>>> print('add something at end', end='X\n')
add something at endX
~~~
