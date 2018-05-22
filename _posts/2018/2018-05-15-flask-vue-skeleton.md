---
layout: post
title: "Flask + Vue.js : Fullstack Development"
description: "搭建一个基于 flask + vue.js，可以快速开发的全栈框架。整合了 flask-admin, flask-security, SQLAlchemy, Swagger UI。以 json Restful API 与前端 Vue.js 交互。"
category: programming
tags: [python, vue.js, homepage]
image-url: /assets/img/2018/flask-vue.png
---

### GOAL: 搭建一个基于 flask + vue.js，可以快速开发的全栈框架。具有以下特色:

- 整体的登入验证: `flask-security`
- 便利的后台界面可供修改数据库: `flask-admin`
- 使用 `Vue.js` 开发前端 UI
- flask 提供 restful API, 包含 apidoc `Swagger UI`

This tutorial shows how to build a system with python flask and vue.js. In the end of this article, we will have a skeleton application ready for rapid development.

Here's the source code: [github repository](https://github.com/larrysu1115/flask-vue)

This series of tutorial have 6 parts:

- **Part 1 : environment, flask HelloWorld, blueprint**
- Part 2 : [flask config, logging, unit-testing, SQLAlchemy](flask-vue-skeleton-part-2.html)
- Part 3 : [Restful API, marshmallow, Swagger apidoc](flask-vue-skeleton-part-3.html)
- Part 4 : flask-admin
- Part 5 : flask-security
- Part 6 : Vue.js

## Prepare the Environment

先用 pyenv 建立一个虚拟环境；这样做的好处是可以有一个独立的开发环境，不会与其他专案不同的软件版本发生冲突。

First, Let's create a virtual environment for python using `pyenv`. In this way, we can isolate our project and eliminate potential package version conflicts with other projects in developer's computer.

```bash
# make a new environment called 'fv'
pyenv virtualenv 3.6.2 fv
# enter our project folder (~/repos/flask-vue), and assign the new env to this folder.
cd ~/repos/flask-vue
pyenv local fv
# make backend folders
mkdir b2e b2e/config b2e/dodo b2e/dodo_test
```

Project Folder Structure :

```
├── f2e                     // frontend vue.js code, explain later
└── b2e                     // backend python code
    ├── config              // python configuration
    ├── dodo                // python flask app
    └── dodo_test           // python unit tests
```

## Flask Helloworld

Install the python package: flask

```bash
pip install flask
```

Edit file: `./dodo/app1.py` as

```python
from flask import Flask, jsonify

def create_app():
    app = Flask(__name__, static_folder='./')

    @app.route('/')
    def root():
        data = dict(say="hello")
        return jsonify(data), 200
    return app

if __name__ == '__main__':
    app = create_app()
    app.run()
```

Test the hello world example!

```bash
# bring up flask app
FLASK_DEBUG=1 python dodo/app1.py
# open browser to see result, or use curl:
curl http://localhost:5000
{
  "say": "hello"
}
```

## Introducing Flask Blueprint

Flask Blueprint 可以将不同的模块、子系统，拆分开来在不同的资料夹、文件中开发。
然后利用注册每个蓝图到 flask 主要的 app 的方式整合在一起。这样的拆分方式，
利于在中到大型的系统开发项目中，繁多的原始码仍然简洁而有结构地安排在每个文件及资料夹中。

Flask Blueprint can help us to separate modules/sub-system into different files, and later register them into our main flask-app. This feature is very useful for building medium to large scale applications with succinct and structured code files.

We will make 2 blueprints : 

- `doggy_api` : APIs return json data
- `doggy_pages` : html page rendered by flask

```
└── b2e/
    └── dodo/
        ├── app2.py
        └── doggy/
            ├── api.py
            ├── pages.py
            └── templates/
                └── show.html
```

file `./dodo/doggy/api.py` :

```python
from flask import Blueprint, jsonify
from flask import current_app as app

blueprint_api = Blueprint('doggy_api', __name__)

@blueprint_api.route('/list', methods=['GET'])
def get_list():
    data = [{ 'name': 'dog_aaa' }, { 'name': 'dog_bbb' }]
    return jsonify(data)

@blueprint_api.route('/count', methods=['GET'])
def get_count():
    data = { 'count': 10 }
    return jsonify(data)
```

file `./dodo/doggy/pages.py` :

```python
from flask import Blueprint, render_template

blueprint_pages = Blueprint('doggy_pages', __name__, template_folder='templates')

@blueprint_pages.route('/<page_name>')
def show(page_name):
    return render_template('show.html', page_name=page_name)
```

file `./dodo/doggy/templates/show.html` :

```html
<html>
<head></head>
<body>
    <h2>doggy - pages</h2>
    <h2>You are visiting page: { { page_name } }</h2>
</body>
</html>
```

file `./dodo/app2.py` :

```python
from .doggy.api import blueprint_api
from .doggy.pages import blueprint_pages

def create_app():
    app = Flask(__name__, static_folder='./')
    app.register_blueprint(blueprint_api, url_prefix='/doggy/api')
    app.register_blueprint(blueprint_pages, url_prefix='/doggy/pages')
    # ...
    return app

if __name__ == '__main__':
    app = create_app()
    app.run()
```

因为程序中引用了 内部 module: doggy.api, 所以要将 dodo 资料夹视为一个 package.

Since we are referencing internal module:'doggy.api', the folder:'dodo' should be treated as a python 'package'.

```bash
# declare folder:'dodo' as a package
touch ./dodo/__init__.py
# run flask app
FLASK_DEBUG=1 FLASK_APP=dodo/app2.py flask run
# test api in blueprint
curl http://localhost:5000/doggy/api/list
# visit the html page
curl http://localhost:5000/doggy/pages/abcde
```
