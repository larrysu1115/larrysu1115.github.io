---
layout: post
title: "使用 VS Code 開發 Golang 程序"
description: ""
category: programming
tags: [golang]
---

使用 VS Code 環境開發 golang

```bash
# 將 GOPATH 下的對應 source 路徑 指向 local git repository
$ ln -s ~/repos/moby $GOPATH/src/github.com/larrysu1115/moby
```

## launch.json 偵錯模式使用

使用 Command Palette, `Debug: open launch.json`,  
使用 F5 進入偵錯模式時候，會使用下面的設定。

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Launch",
            "type": "go",
            "request": "launch",
            "mode": "auto",
            "program": "main.go",
            "env": {},
            "args": []
        }
    ]
}
```

## tasks.json

使用 Command Palette, `Tasks: Configure tasks`. 

- 使用 Cmd + Shift + B, 執行 `go run ...`
- 使用 Cmd + R, 選擇 build, 執行 `go build ...`

```json
{
    "version": "2.0.0",
    "command": "go",
    "options": {
        "cwd": "${env:GOPATH}",
        "env": {
            "packageMoby" : "github.com/larrysu1115/moby"
        }
    },
    "tasks": [
        {
            "label": "build",
            "type": "shell",
            "args": [
                "build",
                "-o",
                "./bin/moby_x64",
                "src/$packageMoby/main.go"
            ],
            "group": "build",
            "problemMatcher": "$go",
            "presentation": {
                "echo": true,
                "reveal": "silent",
                "focus": false,
                "panel": "shared",
                "showReuseMessage": false,
                "clear": false
            }
        },
        {
            "label": "run",
            "type": "shell",
            "args": [
                "run",
                "src/$packageMoby/main.go"
            ],
            "group": {
                "kind": "build",
                "isDefault": true
            },
            "problemMatcher": "$go",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "shared",
                "showReuseMessage": false,
                "clear": true
            }
        }
    ]
}
```