---
layout: post
title: "Notes on A Tour of Go"
description: ""
category: programming
tags: [golang]
---

閱讀 
[A Tour of Go](https://tour.golang.org)
的重點摘要。

## Basic

- Packages : 程式從 package main 開始。
- Import
- Exported Names : package 中的首字母大寫對象會被導出。
- Function : 
```go
func add(x int, y int) int { ... }
func add(x, y int) int { ... }       // 也可以這樣寫
func swap(x, y string) (string, string) { ... }  // 返回多個值
// named results
func split(sum int) (x, y int) { 
    ...
    return
}
```
- Variables :
```go
var i, j int = 1, 2  // 類型寫在後面，可初始化值
var c, python, java = true, false, "no!"  // 也可用初始值決定類型
k := 3               // 短聲明，等同 var k int = 3，不可寫在函式外。
```
- Basic Types :
```go
bool
string
int  int8  int16  int32  int64
uint uint8 uint16 uint32 uint64 uintptr
byte // uint8 的別名
rune // int32 的別名
     // 代表一個Unicode碼
float32 float64
complex64 complex128
```
- Type Conversions : 必須顯式轉換類型，不會隱式自動轉換。
```go
i := 42
f := float64(i)
```
- Constants : `const Pi = 3.14`, 不可用 `:=` 語法

## Flow Control

- for
```go
for i := 0; i < 10; i++ { ...
for       ; i < 10;     { ...    // 也可以留空
// 類似 while 的效果
sum := 0
for sum < 100 { ...
```
- if : 可在 if 判斷前運行一個語句，v的作用域只在 if else 範圍內。
```go
if v := math.Pow(x, n); v < lim {
```
- switch : 除非以 fallthrough 語句結束，否則每個 case 會自動終止。
```go
switch os := runtime.GOOS; os {
	case "darwin": ...
	case "linux": ...
	default: ...
}
// 沒有條件的 switch 就像是比較清楚的 if-then-else 寫法
switch {
	case t.Hour() < 12: ...
	case t.Hour() < 17: ...
	default: ...
}
```

## More Types

- struct :

```go
type Vertex struct {
	X int
	Y int
}

v := Vertex{1, 2}
p := &v
p.X = 987
fmt.Println(v.X)
```

- pointer : golang 有指標，但沒有指標運算。
- struct literals
```go
var (
	p = Vertex{1, 2}   // has type Vertex
	q = &Vertex{1, 2}  // has type *Vertex
	r = Vertex{X: 1}   // Y:0 is implicit
	s = Vertex{}       // X:0 and Y:0
)
```
- new : `new(T)` 分配零初始化的 T 值，並返回它的指針。
```go
var t *T = new(T)
t := new(T)
```
- array : 陣列的長度是類型的一部分，不能改變大小
```go
var a [10]int
```
- slice : `[]T` 指向一個陣列，包含長度信息。`s[lo:hi]` 表示從 lo 到 hi-1 的 slice 元素
```go
a := make([]int, 5)     // len(a)=5
b := make([]int, 0, 5)  // len(b)=0, cap(b)=5
```
- range
```
var pow = []int{1, 2, 4, 8, 16, 32, 64, 128}
for i, v := range pow { ...
for _, v := range pow { ...
for i := range pow { ...
```
- map

```go
m = make(map[string]Vertex)
m["Bell Labs"] = Vertex{
    111, 222,
}

// literal
var m = map[string]Vertex{
	"Bell Labs": Vertex{ 1, 2 },
	"Google": Vertex{ 8, 9 },     // or "Google": { 8, 9 }
}

// manipulation
m[key] = elem
elem = m[key]
delete(m, key)
elem, ok = m[key]
```

- function is also value

```go
hypot := func(x, y float64) float64 {
		return math.Sqrt(x*x + y*y)
}
fmt.Println(hypot(3, 4))
```

- function closure : function 裡頭自帶初始化後的實例

```go
func adder() func(int) int {
	sum := 0
	return func(x int) int {
		sum += x
		return sum
	}
}

pos, neg := adder(), adder()
for i := 0; i < 10; i++ {
    fmt.Println(pos(i), neg(-2*i))
}
```

## Method

- Method: Go 沒有類。然而可在結構類型上定義方法。
- Method: 可以對包中的 任意 類型定義任意方法，而不僅是結構體。
- Method: 不能對來自其他包的類型或基礎類型定義方法。

```go
type Vertex struct { ... }

func (v *Vertex) Abs() float64 { ... }

func main() {
	v := &Vertex{3, 4}
	fmt.Println(v.Abs())
}
```

- Interface : 

```go
type Abser interface {
	Abs() float64
}

func (v *Vertex) Abs() float64 {
	return math.Sqrt(v.X*v.X + v.Y*v.Y)
}

var a Abser
v := Vertex{3, 4}
a = &v // a *Vertex implements Abser
```

- error

```go
type error interface {
    Error() string
}
```

## Concurrency

- goroutine

```go
go f(x, y, z)
```

- channel

```go
ch := make(chan int)
ch <- v
v := <-ch
// 緩衝 100
ch := make(chan int, 100)

// 關閉後，狀態就 ok == false
close(ch)
v, ok := <-ch
```

- select : 在多個channel上等待, 知道某個可執行，隨機挑選一個可執行的。default 用於非阻塞。

```go
var c, quit chan int

select {
    case c <- x:
        x, y = y, x+y
    case <-quit:
        fmt.Println("quit")
        return
    default:
        ...
}
```
