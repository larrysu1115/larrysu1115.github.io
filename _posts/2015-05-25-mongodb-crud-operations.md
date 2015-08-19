---
layout: post
title: "MongoDB CRUD Operations"
description: ""
category: nosql
tags: [mongodb]
---
{% include JB/setup %}

记录常用的 MongoDB 操作指令。 官方文件 [看这里](http://docs.mongodb.org/manual/tutorial/)

---

### 数据库操作

```bash
# 查看数据库
> show dbs;
admin        (empty)
local        0.078GB
mydb         0.953GB
test01       0.078GB

# 指定当前数据库为 test01
> use test01
switched to db test01

# 删除当前数据库 (test01)
> db.dropDatabase()
{ "dropped" : "test01", "ok" : 1 }
```

### 基础 CRUD 操作

```bash
# 新增一笔
> db.users.insert(
  {
    name: "Jacks",
	birthday: ISODate("1980-03-23"),
	status: "A",
	habits: [ "tennis", "literature"]
  }
)

# 删除 collection
> db.users.drop()

# 使用 JavaScript 回圈新增 多笔
for (i=1; i<=5000; i++) {
  var name = 'name_' + i;
  var rNum = Math.floor((Math.random() * 100));
  var brand = ["Lexus", "Volvo", "Benz", "Toyota", "Luxgen"];
  var date = new Date("2015");
  date = date.setDate(date.getDate() - rNum * 10);  

  db.cars.insert({
    name: name,
	brand: brand[rNum % 5],
	dateProduce: date,
	speed: rNum
  })
}

# 查询筛选结果
db.cars.find(
  { speed: { $gt: 80 } },              // query criteria
  { name:1, brand:1, speed:1, _id:0 }  // projection
).
sort({ speed:-1 }).                    // sort by 'speed' descending
skip(100).                             // skip 100 documents
limit(20)                              // limit 20 documents

# delete 动作
db.cars.remove( { name: "name_999" } );

# update 动作
db.cars.update(
  { speed: { $lt: 10 } },
  { $set: { brand: "bike" } },
  { multi: true }
)
# 看看更新后的结果
db.cars.find( { speed: { $lt: 10 } } )

```

### 索引 Index

```bash
# 在 collection:cars 上建立索引 dateProduce
db.cars.createIndex( { dateProduce: 1 } )

# 查看索引
db.cars.getIndexes()

# 删除索引
db.cars.dropIndex( { "dateProduce": 1 } )

# 在 collection:cars 上建立复合索引 brand+speed
db.cars.createIndex( { brand:1, speed:1 } )


```