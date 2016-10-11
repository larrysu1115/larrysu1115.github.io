---
layout: post
title: "R - Make new package with git in R Studio"
description: ""
category: programming
tags: [r]
---

### 0. 大綱

本文說明如何製作一個 R package。

1. 環境設定
1. 建立基本的 R Project, push 到 git 中
1. 使用 library, 以及編寫自己的 function
1. 使用 master, develop 分支

參考這兩篇文章: [Write an R package from scratch](https://hilaryparker.com/2014/04/29/writing-an-r-package-from-scratch/), and [Designing Projects](http://nicercode.github.io/blog/2013-04-05-projects/)

### 1. 環境設定

由系統管理員使用下面的命令，建立用戶(用戶名: andy)

```bash
# add linux user
$ sudo useradd -m -s /bin/bash andy
# 設定密碼
$ sudo passwd andy
# 接著重複輸入密碼兩次確認
```

接著使用者 andy 可以登入系統，進行初始設定

```bash
# ssh 登入遠端服務器
$ ssh andy@your.server.com

# 設定 git 的使用者信息
$ git config --global user.email "andy@gomi.com"
$ git config --global user.name "Andy WANG"
$ git config --global merge.ff false
# 這些信息會寫入到 ~/.gitconfig 文件中
$ cat ~/.gitconfig 
[user]
	email = andy@gomi.com
	name = Andy WANG

# create SSH-Key for tester1
$ mkdir ~/.ssh && chmod 700 ~/.ssh
$ ssh-keygen -t rsa -b 4096 -C "andy@gomi" -f ~/.ssh/id_rsa
# 這個步驟會在 ~/.ssh 資料夾中建立 一對公私密鑰: id_rsa, id_rsa.pub
# 將公鑰的內容放到 BitBucket 中，登記為自己的
# BitBucket 右上角個人照片 > [Bitbucket settings] > [SSH keys] > [Add key]
# 查看 公鑰 的內容，複製貼上:
$ cat ~/.ssh/id_rsa.pub

# 完成後試試看，下面指令，bitbucket應該可以認出使用者是 andy
$ ssh -v git@bitbucket.org
...
logged in as andy.
...

# 建立一個 repos 資料夾，之後的 repository 都放在這裡
$ mkdir ~/repos
```

### 2. 建立基本的 R Project, push 到 git 中

建立一個 git 的 repository, 這裡以 BitBucket 為例, 名稱為 `fufu`

獲得該 repository 的位置: `git clone git@bitbucket.org:goming/fufu.git`

登入 web 介面的 R Server

用 R-Studio 新建 project: [New Project] > [Version Control] > [Git], 輸入

- Repository URL: git@bitbucket.org:goming/fufu.git
- Project directory name: fufu
- Create project as subdirectory of: ~/repos

用 git, clone 回來 project, 獲得 project 的基礎資料夾: fufu。

```R
# 在 R studio 查看當前路徑
> getwd()
[1] "/home/andy/repos/fufu"
# 到上一層目錄
> setwd('..')
# 引用工具: devtools 
> library(devtools)
# 初始化 R package, 會多出 DESCRIPTION, NAMESPACE... 文件。overwrite? 選 Yes
> devtools::create('fufu')

# 完成後，將目前路徑設定回到 fufu
setwd('fufu')
```

接下來新增 R 的程式: 一個叫做 dodo 的 function。

新增一個文件: ./R/dodo.R 內容如下:

```R
#' My First Function
#'
#' dodo will loggin a message, and return "a" multiply by 11
#' @param params explain parameter 1
#' @param today  explain parameter 2
#' @return ball
#' @export

dodo <- function(a) {
  return(a * 11)
}
```

測試一下新的 function:

```R
# 到 R Console 試著運行 dodo
> dodo(123)
Error: could not find function "dodo"
# 找不到剛才添加的函數

# 使用 devtools::document() ，將 dodo 函數加入 R package 的設定。
# 注意當前目錄需要是 "/home/andy/repos/fufu"
> document()
Updating fufu documentation
...

# 接著就可以成功呼叫 dodo(123)
# 這種方式，不需要事先 source('./R/dodo.R')
> dodo(123)
[1] 1353
```

#### 將現有的 R project 放入 git 中

- 現在還沒有 git 分支(branch), 所以先新增一個分支: master
- 將現有的 project commit 到 本地的 master 分支上。
- 將本地的 master 分支 push 到遠端的 BitBucket 服務器上。

到命令行，[git TAB] > [齒輪] > [shell]

```bash
# 建立 git master 分支
git checkout -b master
```

到 R Studio 的 [git TAB] >> [commit] 

- commit message: 隨便寫，如 "initial project structure"
- 選擇左側的文件 staged 打勾

確認按下 [Commit] 按鈕，將這些文件在自己機器上加入源碼管理。
然後按下 [Push] 按鈕，將這些文件同步傳送到遠端 BitBucket 的管理中。

這時候到 BitBucket 左側的 [Source] menu，就可以看到剛才 push 上的文件，在 master 分支中。

### 3. 使用 library, 以及編寫自己的 function

重新打開 R Studio Project，應該`多了一個 [Build TAB]`，打開文件 DESCRIPTION，在裡頭加入兩個部分: Imports, Suggests 

- Imports: 必須使用到的 library
- Suggests: 建議使用到的 library (通常是開發用的，如文件產生器 roxygen2)

如下:

```conf
Description: What the package does (one paragraph).
Depends:
    R (>= 3.3.1)
Imports:
    bigrquery,
    futile.logger
Suggests:
    devtools,
    roxygen2
```

此時可以點擊 右上 [Build TAB] > [Build & Reload]，會進行程式的重新編譯，並載入更新的程序。

接著新建立一個 analysis.R 文件，在 fufu 資料夾中；注意**不是在** fufu/R/ 資料夾下。

analysis.R 中可以寫不是 function 的 R Script, 然後呼叫 fufu/R/ 資料夾下的 R function，運行這些自訂的 function。

analysis.R 中需要引用 library(xxx), 在 fufu/R/ 資料夾下的 R function 文件中，不需要再引用 library(xxx)

analysis.R 的內容如下:

```R
#!/usr/bin/env Rscript

library(fufu)
library(futile.logger)
result <- dodo(11)
sprintf('the result of my program is: %d', result)
```

修改 ./R/dodo.R 的 function 內容，加上呼叫其他 library (futil.logger) 的內容:

```R
dodo <- function(a) {
  flog.info('this is a 3rd library call!!!')
  return(a * 11)
}
```

```R
# 試試看在 R Console 呼叫 dodo(11)，沒有變化！
> dodo(11)
[1] 121

# 重新編譯並載入：點擊 [Build TAB] > [Build & Reload]
> dodo(11)
INFO [2016-10-11 11:19:16] this is a 3rd library call!!!
[1] 121
# 可以看到剛才對 dodo function 的修改已經生效
```

接著可以到 linux 命令行試試看使用 RScript 運行程式，也可以獲得一樣的結果。

```bash
$ Rscript --vanilla ~/repos/fufu/analysis.R
INFO [2016-10-11 11:27:17] this is a 3rd library call!!!
[1] "the result of my program is: 121"
```

將目前為止的原始碼，再 commit, push 同步到 BitBucket 服務器上；注意看看有哪些文件被修改了。

### 4. 使用 master, develop 分支

看看 git flow 的做法

#### 最簡單的兩個分支 master, develop

- master: 對應生產環境的正式代碼
- develop: 對應還在不停開發，修修改改的 開發中版本

![img](http://nvie.com/img/main-branches@2x.png)

#### gitflow 全貌，熟悉後再引入

- feature: 某個功能
- hotfix: 某個BUG修正

![img](http://nvie.com/img/git-model@2x.png)

回到 R Studio, 在 git shell 中建立新的 develop 分支 (基於 master 上長出來的)

```bash
# 建立 git develop 分支
git checkout -b develop
```

隨便改點東西，例如把 dodo.R 改成 return(a * 11 + 99000)

然後 commit 這些變動到 本地的 develop 分支中。

此時遠端 BitBucket 中仍然沒有 新的 develop 分支，利用下面的命令，將 本地的 develop 分支放上 遠端(origin)的 BitBucket 服務器

```bash
# 在 R Studio 中的 [git TAB] > [shell] 中輸入
git push -u origin develop
``` 

到 BitBucket 中看到已經有兩個分支 master, develop。
剛才的修改只能在 develop 中看到。master 中沒有變化。

接下來先在 [Git TAB] 中，使用右側的 下拉框，選擇 master 分支；然後打開 [Git TAB] > [shell] 。輸入下面指令將 develop 分支合併到 master 上

```bash
# 在 R Studio 中的 [git TAB] > [shell] 中輸入

# 確認現在停留在 master 分支上 (前面有*符號)
$ git branch
  develop
* master

# 將 develop 分支合併回到 master 上
# 註: 最早的 環境設定 將 fast forward 取消了 (merge.ff = false)。
$ git merge -m "something is done" develop
Merge made by the 'recursive' strategy.
 R/dodo.R | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
```

再將 master 分支 push 同步上 BitBucket 服務器。然後打開 [Git TAB] > [Commit] > [History]，可以看到類似的圖：

![img](/assets/img/2016-Q3/161011-git-r-graph.png)

這張圖說明了:

- 總共有四次 commit
- 本地 master 分支 與 遠端 origin/master 分支同步 (在同一水平上)
- 本地 develop 分支 與 遠端 origin/develop 分支同步
- develop 分支已經合併回到 master 分支。

