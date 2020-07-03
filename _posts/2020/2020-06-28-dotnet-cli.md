---
layout: post
title: "Notes on .NET CLI"
description: ""
category: programming
tags: [dotnet]
---

紀錄 .NET CLI 指令的基本用法  
Usage of .NET CLI command

```bash
$ mkdir DemoDotnetCli
$ cd DemoDotnetCli
$ dotnet new sln --name DemoDotnetCli

$ dotnet new classlib --name CoreLib --output ./CoreLib -f netstandard2.1
$ dotnet sln add ./CoreLib/CoreLib.csproj

$ dotnet new classlib --name CoreLib.Test --output ./CoreLib.Test -f netcoreapp3.1
$ dotnet sln add ./CoreLib.Test/CoreLib.Test.csproj

$ dotnet new console --name App --output ./App -f netcoreapp3.1
$ dotnet sln add ./App/App.csproj

# add testing nuget packages to Unit Test project
$ dotnet add CoreLib.Test package NUnit
$ dotnet add CoreLib.Test package NUnit3TestAdapter
$ dotnet add CoreLib.Test package Microsoft.NET.Test.Sdk

# Unit Test project depend on the Core project
$ dotnet add CoreLib.Test reference CoreLib

# Execute unit tests
$ dotnet test CoreLib.Test
```
