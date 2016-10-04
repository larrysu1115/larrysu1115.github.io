---
layout: post
title: "Python - exception"
description: ""
category: programming
tags: [python]
---

#### try ... catch

```python
try:
    xxx
except OSError as err:
    print('OS error: {0}'.format(err))
except (RuntimeError, TypeError, NameError):
    print('xxx')
except:
    print('Unexpected error:', sys.exc_info()[0])
    raise
else:
    # when no exception happened.
    pass
finally:
    # always executes this finally block.

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
