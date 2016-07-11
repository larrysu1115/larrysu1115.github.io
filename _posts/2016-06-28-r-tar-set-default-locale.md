---
layout: post
title: "R tar: Failed to set default locale"
description: ""
category: programming
tags: [r]
---

Mac OS 环境下，执行 install.packages("xxx")，发生
错误: `tar: Failed to set default locale`，如图:

![img](/assets/img/2016-Q2/160628-r-tar-failed.png)

可以在 Terminal 中设定:

```bash
defaults write org.R-project.R force.LANG en_US.UTF-8
```

然后重启 R Studio。

