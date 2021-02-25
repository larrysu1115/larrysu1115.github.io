---
layout: post
title: "Design Patterns of GoF"
description: ""
category: "software engineering"
tags: [design]
---

對 GoF design patterns 的理解摘要。

---

# Creational Design Patterns

## 1. Abstract Factory

TODO

## 2. Builder

TODO

## 3. Factory Method

- 使用 factory 建立新物件，建立新物件的邏輯集中在 factory

```csharp
class MyFactory {
    public IAnimal createAnimal(string env) {
        switch (env) {
            case "desert" : return new Lion();  // Lion implements interface: IAnimal
            case "forest" : return new Rabbit();
            case "ocean"  : return new Dolphin();
        }
    }
}
```

## 4. Prototype

TODO

## 5. Singleton

- 確保只有單例(instance) 存在
- 例如 `工廠物件` 或是 `管理器` 物件，就可能應用單例模式。
- 沒有特別意義時候，沒必要強加單例模式。

```csharp
class Solo {
    private static readonly Solo instance = new Solo();
    // static constructor makes compiler not to mark type as beforefieldinit
    static Singleton() { }
    private Singleton() { }
    public static Solo Instance
    {
        get { return instance; }
    }
}
```

### 5.1. Monostate

利用私有成員達到類似 Singleton 的效果，無論實例化多少個物件，  
背後對應的都是同樣的 private static member。

```csharp
class Monostate
{
    private static int _num;
    public int Num
    {
        get => _num;
        set => _num = value;
    }
}
```

---

# Structural Design Patterns

## 6. Adapter

TODO

## 7. Bridge

TODO

## 8. Composite

TODO

## 9. Decorator

動態替既有功能添加不同的行為。[wiki](https://zh.wikipedia.org/wiki/修饰模式)

- Decorator 與原來的類有一樣的 interface
- Decorator 包裹原來的類，成為其中被操控的 Component
- 使用類繼承也可以達到修改行為，但是類繼承需要設計時候就決定好，Decorator模式可以在運行式修改行為。

```csharp
class Car {
    public virtual void Move() {
        Console.WriteLine($"moving at {speed}");
    }
}

class abstract CarDecorator : Car {
    protected Car component;
    public void CarDecorator(Car c) { this.component = c; }
    public override void Move() {
        this.component.Move();
    }
}

// 繼承 Decorator 添加不同行為即可
class OldCar : CarDecorator {
    public override void Move() {
        base.Move();
        if (this.component.Age > 10) {
            Console.WriteLine("Warning! Must stop to rest within 2 hours.");
        }
    }
}

// 使用方式
OldCar oldCar = new OldCar();
// 需要依照運行時候狀態，也可如此設定:
oldCar.SetRuntimeStatus("hot");
// 之後當成一般對象使用
Car car = (Car)oldCar;
car.Move();
```

## 10. Façade

對複雜操作，利用一個 `單一的通用界面`，讓使用者可以進行 `簡單的操作`。  
將複雜的操作隱藏於 Façade 之下。  
需要使用者都同意接受 Façade 單一通用界面的規範，才有意義。

## 11. Flyweight

TODO

## 12. Proxy

TODO

---

# Behavior Design Patterns

## 13. Chain of Responsibility

TODO

## 14. Command

將類似的動作使用統一的 interface 操作，具體動作內容因實作而不同。

```csharp
abstract class MyCommand {
    protected Subject doer;

    public MyCommand(Subject doer) { 
        this.doer = doer;
    }
    
    abstract public void Execute()
}

class AlphaCommand : MyCommand {
    public override void Execute() {
        doer.DoSomethingAlphaNeeds();
    }
}

// 使用統一的界面操作
MyCommand a = AlphaCommand(user);
MyCommand b = BetaCommand(user);
a.Execute();
b.Execute();
```

### 14.1 Active Object

Command 模式的一種應用，可以控制多執行緒的運作，也叫做 `RTC` (Run To Completion)  
engine 中的一個 Command 物件會在執行完成時候，將自身的複製物件放到 鏈接(commands) 尾部。

```csharp
class ActiveObjectEngine
{
    List commands;
    public void AddCommand(Command c) => commands.Add(c);
    public void Run() {
        while (commands.Count > 0) {
            var c = command[0];
            commands.RemoveAt(0);
            c.Execute();
        }
    }
}
```

## 15. Interpreter

TODO

## 16. Iterator

TODO

## 17. Mediator

在使用者不需知情的狀況下，利用 Mediator 將兩個物件關聯起來，  
進行互相協同的作業，兩個關聯的物件彼此間無需知道對方存在，  
也無需知道 Mediator 的存在。  
例如 Mediator 利用 TextBox 的 OnChanged event 觸發，  
更新 ListBox 對應的 ListItem。  
ListBox 或 TextBox 都無需事先知道，只要 Mediator 協助綁定事件即可。

## 18. Memento

TODO

## 19. Observer

TODO

## 20. State

TODO

## 21. Strategy

類似 `22.Template Method`，但提供更多的彈性，  
各個 method 宣告於 interface 中，
將 `組合各個 method` 的 `策略` 實作在 AppRunner 中。

```csharp
class AppRunner
{
    public App app { get; set; }
    public void Run() {
        app.Init();
        while(!app.DoJob()) {
            Sleep(1);
        }
        app.Clean();
    }
}

class BillingApp : App
{
    public void Init() {...} //實作 Init(), DoJob()...
    public static void Main(string[] args) {
        var app = new AppRunner() { App = new BillingApp() };
        app.Run();
    }
}
```

## 22. Template Method

製作一個模板 class, 只規定組合各個 method 的方式，  
繼承的 class 負責實作各個 method 的細節。

```csharp
class App
{
    protected void Init();   //由繼承類別實作
    protected bool DoJob();  //由繼承類別實作
    protected void Clean();  //由繼承類別實作
    public void Run()
    {
        Init();
        while(!DoJob()) { 
            Sleep(1); 
        }
        Clean();
    }
}
```

## 23. Visitor

TODO

---

# Others

## Null Object

可以製造一個什麼都不做的 Null 替代物件。

```csharp
class User {
    public abstract bool DoSomething();
    public static readonly User NULL = new NullUser();
    private class NullUser : User {
        public override bool DoSomething() {
            return false; // do nothing.
        }
    }
}
```