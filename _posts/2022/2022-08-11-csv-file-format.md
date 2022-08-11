---
layout: post
title: "CSV file format explained"
description: ""
category: [software engineering]
tags: [dotnet]
---

CSV (Comma-Separated Values) 為 逗號(,) 分隔欄位的文本文件，可以用來儲存資料。  
也是常見的資料轉換格式之一。

基本格式 :

- 分隔欄位 Column, 又稱為 Delimiter :  `逗號 ,`
- 分隔列 Row : `斷行符號 CR LF` 不同作業系統可能不同
- 文字限定符號 Text Qualifier : `雙引號 "`
- 跳脫字元 (Escape Character) : `雙引號 "`

例如下面是有三個欄位的四列資料，應該如何正確地儲存為 CSV 文件？

|name|address|age
|-|-|-|
|Bill|Road ABC No. 32|28|
|Mary|Avenue Bella 2|18|
|John|Road Apple, No 18, 3F|42|
|Iris|Temple of "Heaven"|99|

## 正確的 CSV 格式

CSV 格式被廣泛用在資料交換, 與資料轉換上。 
目前最廣泛被接受為 CSV 標準格式規範的文件為 [RFC-4180](https://www.rfc-editor.org/rfc/rfc4180.html)

內容 (經過排版對齊，方便閱讀，原始文件不應有排版對齊的多餘空白字元) :

```
---- CSV content -------------------|------ 說明 ----------------
name, address,               age    | header 部份
Bill, Road ABC No. 32,       28     | 這行可以不加 Text Qualifier
Mary, Avenue Bella 2,        18     | 
John,"Road Apple, No 18, 3F",42     | 內容有逗號, 必須加文字限定符
Iris,"Temple of ""Heaven""" ,99     | 內容有雙引號, 必須使用 跳脫字元
```

原始內容 : 

```
name,address,age
Bill,Road ABC No. 32,28
Mary,Avenue Bella 2,18
John,"Road Apple, No 18, 3F",42
Iris,"Temple of ""Heaven""",99
```

## 使用 Spread Sheed 軟體開啟 CSV 文件，結果正確

Windows Excel

![img](/assets/img/2022/20220811/csv_open_with_win_excel.png)

<hr />

MacOSX Numbers

![img](/assets/img/2022/20220811/csv_open_with_mac_numbers.png)

## 撰寫程式，如何讀取 (Parse) / 寫入 CSV 文件？

絕大多數的情況下，都 `不建議` 自行撰寫程式處理 CSV 分隔欄位, 分割列，獲取資料的邏輯。  
建議要使用一些專門處理 CSV 格式的 library 去 讀取 / 寫入 CSV 文件。  
這些 library 能夠很好地處理資料中包含 逗號, 雙引號, 斷行符號 之類的問題。  

> 處理 XML, Json 格式文件同樣要避免自己去 parse 原始字串

錯誤例子, 嘗試自己按照逗號分隔:

|name|address|age|
|-|-|-|
|John|Road Apple, No "18", 地下室|42|

```
# 原始內容
John,"Road Apple, No ""18"", 地下室",42
```

錯誤例子, 嘗試自己去解析:

```python
x = txt.split(",")

# 註 : 如果想試試看自己解析，正確的方向應該是使用 State Machine as Parser
```

C# 示例:

```csharp
// dotnet add package CsvHelper
using System.Globalization;
using CsvHelper;
using CsvHelper.Configuration;

Console.WriteLine("Parse CSV file with C#");
var config = new CsvConfiguration(CultureInfo.InvariantCulture);

using (var reader = new StreamReader("sample_a.csv"))
using (var csv = new CsvReader(reader, config))
{
    csv.Read();
    csv.ReadHeader();
    while(csv.Read())
    {
        var col1 = csv.GetField<string>(0);
        var col2 = csv.GetField<string>(1);
        var col3 = csv.GetField<int>(2);
        Console.WriteLine($"read line: [{col1}]\t[{col2}]\t[{col3}]");
    }
}
```

python 示例:

```python
from csv import reader

with open("sample_a.csv", "r") as my_file:
    file_reader = reader(my_file)
    for i in file_reader:
        print(i)
```

上面程式運行情況:

![img](/assets/img/2022/20220811/csv_read_csharp_python.png)

## 錯誤情況

一些程式沒有正確的處理 CSV 格式，例如 Microsoft 的 SSMS (SQL Server Management Studio),  
export 導出資料時候，沒有處理好資料中包含 逗號 的情況，導致導出的 CSV 文件無法使用。
