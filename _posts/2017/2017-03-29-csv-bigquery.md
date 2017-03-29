---
layout: post
title: "CSV file and hints of importing to BigQuery"
description: ""
category: bigquery
tags: [bigquery]
---

### What is CSV file

`CSV`: [Comma-Separated Values](https://zh.wikipedia.org/wiki/%E9%80%97%E5%8F%B7%E5%88%86%E9%9A%94%E5%80%BC)

```
name,address,age
Bill,Road ABC No. 32,28
Mary,Avenue Bella 2,18
```

如果地址包含符號如逗號: `,`, 要如何寫在 CSV 文件裡 ？
 
```
name,address,age
Bill,"Road ABC No.32, Tokyo",28
Mary,Avenue Bella 2,18
```

如果地址是: Avenue Bella in "small" hill  
意即地址中要包含 雙引號 ", 要如何寫在 CSV 文件裡 ？

```
name,address,age
Bill,"Road ABC No.32, Tokyo",28
Mary,"Avenue Bella in ""small"" hill",18
```

另外，CSV 既然是一種限定格式的 text file，就有相應的 編碼 ，及 斷行符號 定義:

斷行符號: 

- LF: (0x0A) Line Feed 常見於 unix-line 系統，與近代的 Mac OSX
- CR: (0x0D) Carriage Return 常見於早期的 Apple 電腦，及 Mac OS 版本9 之前
- CR + LF: (0x0D0A) Windows 微軟作業系統使用

編碼:

- UTF-8 : 逐漸變成主流的萬國字集
- UTF-16 : 萬國字集，又可分 LE / BE (Little Endian, Big Endian)
- Big5 : 台灣的繁體字集
- GB2312 : 簡體字集
- GB18030 : 簡體字集的拓展版本，可容納 中日韓 字集

另外，在 UTF-X 的編碼文件，可能會有 BOM (Byte-Order Mark)在檔案的起始處。請[參見說明](https://zh.wikipedia.org/wiki/%E4%BD%8D%E5%85%83%E7%B5%84%E9%A0%86%E5%BA%8F%E8%A8%98%E8%99%9F)。

LE / BE (Little Endian / Big Endian) 的說明，請參見 [格列佛遊記](https://zh.wikipedia.org/wiki/%E5%AD%97%E8%8A%82%E5%BA%8F)

一些處理 編碼 和 CSV文件 時用到的 linux 指令:

```
hexdump : 打印出文件的 16 進制 內容，可以確定文件實際儲存的位元內容
iconv : 轉換各種編碼用
sed : 替換文件內容
awk : 利用某種分隔符號 處理/查看 文件 
```

### 練習用的 CSV:

下載這個文件，[點擊這裡下載 csv_samples.tgz](/assets/src/2017/csv_samples.tgz)

先不要看裡面的 hints.txt 文件，這個文件提示每個 CSV 文件的特殊處。

解開壓縮後有 5 個略有不同的 csv 文件，能否都順利的導入 BigQuery? 

