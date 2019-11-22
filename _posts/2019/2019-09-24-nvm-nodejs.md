---
layout: post
title: "Use nvm to manage nodejs"
description: ""
category: programming
tags: [nodejs]
---

Using `nvm` to manage different versions of nodejs in your machine.

### 1. Install NVM by Homebrew

```bash
$ brew install nvm

# find nvm's folder
$ brew --prefix nvm
# folder is : /usr/local/opt/nvm

# add this line to file: ~/.bash_profile or ~/.zshrc
# source /usr/local/opt/nvm/nvm.sh
```

### 2. Install nodejs

```bash
# list available versions of nodejs
$ nvm ls-remote

# install the one you want
$ nvm install v10.16.3

# list installed versions
$ nvm ls

# choose one version to use
$ nvm use v10.16.3
```

### 3. Setup vue.js

```bash
$ mkdir myproj
$ cd myproj
$ npm install vue
$ npm install -g @vue/cli

# current installed npm packages
$ npm list -g --depth=0

# verify vue version
$ vue --version
```

### 4. Create vue project

```bash
$ vue create .

# serve the content
$ npm run serve
```
