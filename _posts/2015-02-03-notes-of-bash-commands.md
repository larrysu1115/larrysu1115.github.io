---
layout: post
title: "Notes of bash commands"
description: ""
category: linux
tags: [bash, notes]
---

记录一些 Bash shell 的操作

清除操作纪录，并登出系统

```bash
cat /dev/null > ~/.bash_history && history -c && exit
```

```bash
# add user to group
sudo usermod -a -G GROUP1,GROUP2 USERNAME

# show user's groups
groups USERNAME
```