---
layout: post
title: "Notes of java"
description: ""
category: programming
tag: [java]

---

### running java program

```bash
# make the classpath including all jars
$ CLASSPATH=`find lib_managed -name '*.jar' | xargs echo | tr ' ' ':'`; echo $CLASSPATH

```
