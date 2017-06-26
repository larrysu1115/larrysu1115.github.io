---
layout: post
title: "Dotnet Development Stack"
description: "2014~15年间使用的 C#.net 开发框架，使用 Domain Driven 模式分层 Web, BLL, DAL。使用的技术包含 ORM:Entity Framework, Web:NancyFX, Dependency Injection:TinyIoC, API doc: Swagger, etc..."
category: programming
tags: [dotnet, homepage]
image-url: /assets/img/2014-11/tech_stacks.png
---

# 2014~2015 年间使用的 C#.net 开发框架

### 程序结构

使用三层Domain Driven的模式，Visual Studio Solution 中分为 4 个 Project

Project | Usage
--- | ---
MyProject.Core | 核心代码，分层如 BLL, DAL...
MyProject.Web | Web 层，使用 NancyFX
MyProject.Task | 系统后台排程, 也可作为命令行运行偶发任务
MyProject.Test | 测试代码

各个分层与相关工具

![alt text][img-tech-stacks]

[img-tech-stacks]: /assets/img/2014-11/tech_stacks.png "Text File"

<br />

---

### Continuous Integration Process
利用 Jenkins 建立在不同服务器之间的自动部署机制。

`CN - IIS` : 北京正式站台<br />
`TW - IIS` : 台北正式站台<br />
`QA - IIS` : 测试站台<br />
`Dev - IIS` : 开发RD用站台<br />

`Release Candidate (RC)` : RD发布的候选版本，需经过QA验证后，才可以成为GA版本。<br />
`General Availability (GA)` : 经过QA验证的RC版本, 由PM核可后，变为GA版本发布到正式站台。

### Frontend (react.js)

![alt text][img-ci-fe]

### Backend (C#)

![alt text][img-ci-be]

[img-ci-be]: /assets/img/2014-11/jenkins_process_be.png "Text File"

[img-ci-fe]: /assets/img/2014-11/jenkins_process_f2e.png "Text File"

### Core 核心代码 - 分层

__DAL 层 :__

- 使用 Entity Framework : Code First 开发模式

```csharp
namespace MyProjectMyProject.Core.DAL.Model{    [Table("acct_role")]    public class AccountRole    {        [Column("acct_role_id")]        public int ID { get; set; }        [Column("name")]        [MaxLength(100)]        [Required]        public string Name { get; set; }...
```

- 使用 Repository Pattern 进行实体类单元的 CRUD 处理

```csharp
namespace MyProject.Core.DAL.Repo.Simple...
public class RepoAccountUser : GenericRepository<AccountUser>, IRepoAccountUser{
    // 利用继承自 GenericRepository 的方法，
    // 即可实现基础的 Add,Update,Delete,GetById, GetList...
    // 等 CRUD 操作。
}```

- EF Database Migration: .Core.DAL.EFMigrations, 使用 ***SQL-Script 模式***

```csharp
public CoreDbContextMigrationConfiguration(){    // Use command:  Update-Database -Script -StartUpProjectName "MyProject.Core"    // if need to drop table:    // this.AutomaticMigrationDataLossAllowed = true;    this.AutomaticMigrationsEnabled =
        MyProject.Core.Helper.KitConfig.GetIsDevModeAllowEFAutomaticDbMigration();    this.ContextKey = "MyProject.Core.DAL.CoreDbContext";}
```

- 初始化数据: 使用 .Core.DAL.DataInitializer

__BLL 层__

呼叫 DAL 层的 Repository，处理业务逻辑，封装 EF 的 Transaction。

```csharp
public class SheetService : BaseService, ISheetService{
    ...
    public void AddCategory(AccountCompany company, SheetCategory cate)    {
        // 定义对 DB 操作是 Reading or Writing scope, Transaction 封装在 using 内        using (var scope = new UnitOfWorkScope<CoreDbContext>(UnitOfWorkScopePurpose.Writing))        {            var targetCompany = this.repoAccountCompany.GetByID(company.ID);            SheetCategory cateNew = new SheetCategory(targetCompany, cate.Name);            this.repoSheetCategory.Insert(cateNew);
            // Writing 操作要记得 SaveChanges()            scope.SaveChanges();
            this.Log.Info("Created new {0}", cateNew);        }    }
}    
```

__Model__ : 各种实体类，主要分为:
- ***MongoModel***: 对应 MongoDB 的 Bson Model Class<br />
- ***EFModel***: 对应 Entity Framework 的 Model Class<br />
- ***DTO***: Data Transfer Objects<br />

__其他__

Helper : 使用 static method 提供常用的辅助功能

> KitConfig : 读取 App.config, Web.config 中的各个设定<br />
> KitStr : 处理字符串<br />
> KitDate : 处理日期，例如获得每月最后一天，每天凌晨零时零秒<br />
> KitXxx... 其他<br />
