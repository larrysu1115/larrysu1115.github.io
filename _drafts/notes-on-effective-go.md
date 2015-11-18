---
layout: post
title: "Notes on Effective Go"
description: ""
category: programming
tags: [golang]
---

<img style="float: right; width:100px" src="/assets/img/icon/icon-golang.png">

阅读 [Effective Go](https://golang.org/doc/effective_go.html) 的一些摘要笔记

### Introduction

Go语言的概念与其它语言如 Java, C# 等不同；直接将其它语言的程式逻辑翻译为 golang 不太可能获得满意结果。因此需要先理解 golang 的概念，以 golang 的思路去撰写 go 程式。

其它三篇相关介绍文章：

- [Tour of Go](https://tour.golang.org/) *需要先看过
- [How to Write Go Code](https://golang.org/doc/code.html) *需要先看过
- [language specification](https://golang.org/ref/spec) 

__Example__

golang 有丰富的 API 文档与范例，如 [这里](https://golang.org/pkg/strings/#example_Map) 。在线上就可以直接运行，也能在线上修改代码再试。

### Formatting

使用 gofmt 指令可以自动编排源代码，变成规范的格式。例如:

```go
type App struct {
  Id string `json:"id"` //编号
  Title string `json:"title"` //名称
}

var z=x >> 1+y << 1
fmt.Printf("x = %d, y = %d, z = %d\n",x,   y,z)
```
运行 `gofmt -w src/github.com/.../xx.go` 后，变成:

```go
type App struct {
	Id    string `json:"id"`    //编号
	Title string `json:"title"` //名称
}

var z = x>>1 + y<<1
fmt.Printf("x = %d, y = %d, z = %d\n", x, y, z)
```

__格式__

- Identation: 使用 TAB 缩进
- Line length: 每行不限制字数；如果觉得某行太长，可以换行再加上一个TAB
- Parentheses: Go使用较少的括号, if/for/switch的条件不需括号

### Commentary

Go 使用 C-style 的注解形式，如:

- block 区块 : `/* ... */` 
- line 单行 : `// ...`

结合 godoc 使用

- 每个 package 都应有 comment
- 在 top-level 宣告前的注解会被当作说明使用

### Names

__package 名称__ 为 小写的一个词，不需要 `_` 或 `mixedCaps`。应该与源文件的最后一层目录名称相同。

__Get,Set__ Getter 使用 首字母大写，不需要 'Get' 前缀。 Setter 使用前缀 'Set'，如:

```go
owner := obj.Owner()
if owner != user {
    obj.SetOwner(user)
}
```

__MixedCaps__ 作为 Go 中的命名方式，不要用 `_`

### Semicolons

Go 使用 分号 作为 statement终止符号。但是多半无需特别写出分号，因为lexer会自动加上。会加上分号的逻辑为: 'if the newline comes after a token that could end a statement, insert a semicolon.'

因此，只有在 for 以及 单行多statements 的状况下才会使用到 `;`

也因为如此，opening brace `{` 不可以放在下一行，而需要放在 (if, for, switch, or select) 后面。如果不这样，lexer 会自动加上分号，造成错误！

```go
if i < f() {   // okay
	g()
}

if i < f()     // WRONG !!!
{              // WRONG !!!
	g()
}
```

### Control Structures

__for__ 有三种形式:

```go
// Like a C for
for init; condition; post { }

// Like a C while
for condition { }

// Like a C for(;;)
for { }
```