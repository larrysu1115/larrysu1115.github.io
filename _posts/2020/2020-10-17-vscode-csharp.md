---
layout: post
title: "Use VSCode to develop .Net Core C#"
description: ""
category: programming
tags: [dotnet]
---

使用 VSCode 開發 C#



```bash
# 建立 solution
$ mkdir DemoSolution
$ cd DemoSolution
$ dotnet new sln --name DemoSolution

# 建立一個 Console project : App, 並加入 solution 中
$ dotnet new console --name App --output ./App -f netcoreapp3.1
$ dotnet sln add ./App/App.csproj
$ dotnet run -p ./App
```

### 使用 VSCode 打開 DemoSolution 資料夾

VSCode 會自動加入兩個檔案: 
- `DemoSolution/.vscode/launch.json`
- `DemoSolution/.vscode/tasks.json`

此時運行, 會看到預設範例輸出的 Hello World!

```bash
# 加入一個 Library 專案
$ dotnet new classlib --name Lib --output ./Lib -f netstandard2.1
$ dotnet sln add ./Lib/Lib.csproj

# 加入一個 測試專案 App.Test
$ dotnet new classlib --name Lib.Tests --output ./Lib.Tests -f netcoreapp3.1
$ dotnet sln add ./Lib.Tests/Lib.Tests.csproj
$ dotnet add Lib.Tests package NUnit
$ dotnet add Lib.Tests package NUnit3TestAdapter
$ dotnet add Lib.Tests package Microsoft.NET.Test.Sdk
```

此時可以在 Lib.Tests 中編寫單元測試運行

