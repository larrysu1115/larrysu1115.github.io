---
layout: post
title: "使用 VS Code 開發 CSharp 程序"
description: ""
category: programming
tags: [dotnet]
---

越來越多的 C# 項目，看中 dotnet core 跨平台的優勢，採用 dotnet core 來開發。  
VS Code 可以用來編寫 dotnet Core，  
本文記錄如何配置一個順手的 VS Code 環境開發 C# dotnet core。

## 1. 建立 solution

```bash
# 建立 solution, 並加入兩個 project
$ mkdir vscode-mysolu
$ cd vscode-mysolu
$ dotnet new sln --name MySolu
$ dotnet new console  --name App --output App
$ dotnet new classlib --name Lib --output Lib
$ dotnet sln add ./App/App.csproj
$ dotnet sln add ./Lib/Lib.csproj

# project App 引用 Lib
$ dotnet add ./App/App.csproj reference ./Lib/Lib.csproj

# 用 VS Code 開啟
$ code .
```

需要先用 VS Code 的 `Command Palette` 指令: `Shell Command: Install 'code' command in PATH`, 才可以使用命令行啟動 VS Code: `code .`。


第一次使用 VS Code 打開 solution 時，出現下面提示，回答 `YES`, 就會獲得預設的 .vscode/launch.json, tasks.json。

```bash
Required assets to build and debug are missing from 'vscode-mysolu'. Add them?
```

## 2. 設定 launch.json

改動如下

- "preLaunchTask": "build" 註解掉，不需要每次運行都 build, 這樣測試運行快很多。
- console 改成 integratedTerminal
- 加上 "internalConsoleOptions": "neverOpen", 避免按 F5 測試運行時候，Terminal 焦點會跳轉到 Debug Console 上。

```json
{
   "version": "0.2.0",
   "configurations": [
        {
            "name": ".NET Core Launch (console)",
            "type": "coreclr",
            "request": "launch",
            "program": "${workspaceFolder}/App/bin/Debug/netcoreapp2.2/App.dll",
            "args": [],
            "cwd": "${workspaceFolder}/App",
            "console": "integratedTerminal",
            "stopAtEntry": false,
            "internalConsoleOptions": "neverOpen"
        },
        {
            "name": ".NET Core Attach",
            "type": "coreclr",
            "request": "attach",
            "processId": "${command:pickProcess}"
        }
    ]
}
```

## 3. 設定 tasks.json

- "build-app" 為 default 的 build 動作
- 按下 Cmd + Shift + B 就可以進行編譯，錯誤才會跳出編譯訊息。
- 使用 Command Palette "Tasks: Run Task", public release 版本。

```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "group": {
                "kind": "build",
                "isDefault": true
            },
            "label": "build-app",
            "command": "dotnet",
            "type": "process",
            "args": [
                "build",
                "${workspaceFolder}/App/App.csproj"
            ],
            "problemMatcher": "$msCompile",
            "presentation": {
                "echo": true,
                "reveal": "silent",
                "focus": false,
                "panel": "shared",
                "showReuseMessage": true,
                "clear": false
            }
        },
        {
            "label": "publish",
            "group": "build",
            "command": "dotnet",
            "type": "process",
            "args": [
                "publish",
                "-c",
                "Release",
                "${workspaceFolder}/App/App.csproj"
            ],
            "problemMatcher": "$msCompile",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "shared",
                "showReuseMessage": true,
                "clear": false
            },
        },
        {
            "label": "watch",
            "command": "dotnet",
            "type": "process",
            "args": [
                "watch",
                "run",
                "${workspaceFolder}/App/App.csproj"
            ],
            "problemMatcher": "$tsc"
        }
    ]
}
```

## 4. 設定熱鍵

使用 [Code] - [Preference] - [Keyboard Shortcuts] - 按下 `{}`,  
就可以修改每個用戶自訂的 keybindings.json,  
加上下面設定可以使用 Cmd+r 執行 publish task.

```json
{
  "key": "cmd+r",
  "command": "workbench.action.tasks.runTask",
  "args": "publish"
}
```

## 5. 修改 csproj

加上 RootNamespace

```xml
<RootNamespace>MyOrg.MySolu.App</RootNamespace>
```
