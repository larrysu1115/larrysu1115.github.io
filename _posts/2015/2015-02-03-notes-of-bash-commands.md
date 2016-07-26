---
layout: post
title: "Notes of bash commands"
description: ""
category: linux
tags: [linux, notes]
---

记录一些 Bash shell 的操作

### Logging

清除操作纪录，并登出系统

```bash
cat /dev/null > ~/.bash_history && history -c && exit
```

### User Management

```bash
# add user to group
sudo usermod -a -G GROUP1,GROUP2 USERNAME

# show user's groups
groups USERNAME
```

### Process

```bash
# find process ID
ps aux | grep 'command-name' | grep -v 'grep' | awk '{print "PID="$2}'

# tell process to terminate SIGTERM(15)
kill -SIGTERM 1234
# force process to stop SIGKILL(9)
kill -SIGKILL 1234

# [CTRL-C] : Interrupt
kill -SIGINT 1234
# [CTRL-Z]
kill -SIGSTOP 1234

# Free all memory cache
$ sudo su root
$ sync && echo 3 > /proc/sys/vm/drop_caches

```

### Text Manipulation

```bash
find ./src_folder -type f -exec cat {} + > output_cat.csv

# replace filename
for f in *.mp4; do nf=`echo $f | sed 's/BADTEXT//g'`; mv $f $nf; done
```