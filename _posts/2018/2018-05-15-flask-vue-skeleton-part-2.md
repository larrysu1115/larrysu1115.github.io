---
layout: post
title: "Flask + Vue.js : Part 2"
description: ""
category: programming
tags: [python, vue.js]
---

- Part 1 : [Environment, Flask HelloWorld, Blueprint](flask-vue-skeleton.html)
- **Part 2 : Flask config, logging, unit-testing, SQLAlchemy**
- Part 3 : [Restful API, Marshmallow, Swagger apidoc](flask-vue-skeleton-part-3.html)
- Part 4 : [Flask-Admin, Flask-Security](flask-vue-skeleton-part-4.html)
- Part 5 : Vue.js

## flask config, logging

将配置部分分离出来，放在 config 文件中，之后可以针对不同的环境 development, production, staging... 使用不同的配置文件。

Put system settings inside a file designated for configuration, so we can customize the system for different
 environments, such as development, production, staging...

file: `./config/development.py`:

```python
LOGGER_NAME = 'dodoApp'
```

flask 已经内置了 python 的 logging 机制，我们将 logging 的设定也一并放在 config 资料夹中。

flask has built-in the logging mechanism of python, let's put the logging settings in the config folder too.

file: `./config/logging.cfg`:

```text
[loggers]
keys=root

[handlers]
keys=consoleHandler

[formatters]
keys=simpleFormatter

[logger_root]
level=DEBUG
handlers=consoleHandler

[handler_consoleHandler]
class=StreamHandler
level=DEBUG
formatter=simpleFormatter
args=(sys.stdout,)

[formatter_simpleFormatter]
format=%(asctime)s %(levelname)s - %(message)s
datefmt=%y-%m-%d %H:%M:%S
```

file: `./dodo/app.py`:

```python
from flask import Flask, jsonify
from .doggy.api import blueprint_api
import logging.config

def create_app():
    app = Flask(__name__)
    # setup configuration from ./config/development.py
    app.config.from_object('config.development')
    # setup configuration from a environment variable which contains a file path
    app.config.from_envvar('APP_CONFIG_FILE', silent=True)
    # load logging setting
    logging.config.fileConfig('./config/logging.cfg')

    app.register_blueprint(blueprint_api, url_prefix='/doggy/api')

    app.logger.info('application start. __name__ : %s', __name__)
    
    return app

if __name__ == '__main__':
    app = create_app()
    app.run()
```

file: `./dodo/doggy/api.py`:

```python
@blueprint_api.route('/list', methods=['GET'])
def get_list():
    data = [{ 'name': 'dog_aaa' }, { 'name': 'dog_bbb' }]
    app.logger.info('API_list called, will return %d objects', len(data))
    return jsonify(data)
```

Folder Structure :

```
└── b2e       
    ├── config
    │   ├── development.py
    │   └── logging.cfg
    └── dodo
        ├── doggy
        │   └── api.py
        └── app.py
```

run the application:

```bash
FLASK_DEBUG=1 FLASK_APP=dodo/app.py flask run
# ...
# 18-05-21 12:06:09 INFO - application start. __name__ : dodo.app
# ...

curl http://localhost:5000/doggy/api/list
# ...
# 18-05-21 12:07:14 INFO - API_list called, will return 2 objects
```

## Unit Test

使用单元测试，帮助确定系统每个部分运行正确无误。这里我们制作一个单元测试，确认 API 返回 2 个 object.

To assure evert system functionality is correct, use Unit Tests. Here we make an example of unit-test that asserts 2 objects are returned from API.

file `./dodo_test/test_api.py`

```python
import json
import unittest

from dodo.app import create_app

class ExampleTestCase(unittest.TestCase):

    def setUp(self):
        self.app = create_app()
        self.client = self.app.test_client()
        self.logger = self.app.logger

    def test_api_return_2_obj(self):
        rv = self.client.get(
            '/doggy/api/list',
            headers={'content-type': 'application/json'})
        self.app.logger.info('http response: %s', rv)
        data = json.loads(rv.data)
        self.app.logger.info('return object: %s', data)
        self.assertEqual(len(data), 2, 'Should return 2 objects')
```

run the unit-test:

```bash
python -m unittest dodo_test.test_api.ExampleTestCase.test_api_return_2_obj
# 18-05-21 12:27:06 INFO - application start. __name__ : dodo.app
# 18-05-21 12:27:06 INFO - API_list called, will return 2 objects
# 18-05-21 12:27:06 INFO - http response: <Response streamed [200 OK]>
# 18-05-21 12:27:06 INFO - return object: [{'name': 'dog_aaa'}, {'name': 'dog_bbb'}]
# .
# ----------------------------------------------------------------------
# Ran 1 test in 0.017s
```

## SQLAlchemy

SQLAlchemy 是 python 生态中常见的 ORM 工具。来看看如何使用 SQLAlchemy 制作 一对多，多对多 的关系。

```bash
pip install flask_sqlalchemy
```

先准备好 SQLAlchemy 起始设定，这里我们先宣告 SQLAlchemy 的实例，然后再利用 init_app 完成 SQLAlchemy 与
 Flask app 的绑定，这样的做法，配合 create_app() 这个 工厂模式 创建 Flask app，可以有效的将 SQLAlchemy 
 的 定义宣告部分，与 运行查询部分 分离开来，避免 python 文件之间产生 circular dependency。

Folder Structure :

```
└── b2e/
    ├── config/
    │   └── development.py
    ├── dodo/
    │   ├── model/
    │   │   └── warehouse.py
    │   ├── utils/
    │   │   ├── database.py
    │   │   └── gadget.py
    │   └── app.py
    └── dodo_test/
        ├── test_warehouse.py
        └── util.py
```


file `./dodo/utils.gadget.py`

```python
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()
```

宣告对应数据库的 Model Class，这里定义了两个表: Product 产品，Item 存货。

file `./dodo/model/warehouse.py`

```python
from ..utils.gadget import db

class Product(db.Model):
    __tablename__ = 'tb_product'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255))
    expiration_days = db.Column(db.Integer)
    
    def __str__(self):
        return self.name

    def __repr__(self):
        return "<Product(id=[%s])>" % self.id

    def __hash__(self):
        return hash(self.id)

class Item(db.Model):
    __tablename__ = 'tb_item'
    id = db.Column(db.Integer, primary_key=True)
    date_produce = db.Column(db.Date)
    product_id = db.Column(db.Integer, db.ForeignKey('tb_product.id'))
    product = db.relationship("Product", back_populates="items")

    def __str__(self):
        return "<Item(id=%d, product=%s)>" % (self.id, self.product.name)

    def __repr__(self):
        return "<Item(id=%d)>" % self.id

    def __hash__(self):
        return hash(self.id)

Product.items = db.relationship("Item", order_by=Item.id, back_populates="product")
```

产生一些数据来查询

file `./dodo/utils/database.py`:

```python
from .gadget import db
from ..model.warehouse import Product, Item
from datetime import date

def setup_database(app):
    with app.app_context():
        db.drop_all()
        db.create_all()

        milk = Product(name='milk', expiration_days=6)
        lunchbox = Product(name='curry lunchbox', expiration_days=3)
        noodle = Product(name='instant noodle', expiration_days=200)
        products = [milk, lunchbox, noodle]

        items = [Item(product=milk, date_produce=date(2017, 8, 1)),
                 Item(product=milk, date_produce=date(2017, 8, 3)),
                 Item(product=lunchbox, date_produce=date(2017, 8, 8)),
                 Item(product=lunchbox, date_produce=date(2017, 7, 31)),
                 Item(product=noodle, date_produce=date(2017, 6, 1)),
                 Item(product=noodle, date_produce=date(2017, 8, 5))]

        db.session.add_all(products)
        db.session.add_all(items)
        db.session.commit()
```

在 create_app() 中，加上 SQLAlchemy db 的初始化设置。

file: `./dodo/app.py`

```python
from .utils.database import setup_database
from .utils.gadget import db

def create_app():
    ...
    db.init_app(app)
    setup_database(app)

    return app
...
```

在配置文件中，添加 SQLAlchemy 的设定

```python
DEBUG = True
LOGGER_NAME = 'dodoApp'

SQLALCHEMY_ECHO = False
SQLALCHEMY_TRACK_MODIFICATIONS = True
SQLALCHEMY_DATABASE_URI = 'sqlite:////tmp/test.db'
# SQLALCHEMY_DATABASE_URI = 'mysql+pymysql://root:@localhost:3306/dodo'
```

接下来写个 unit test 来做个数据库查询，测试这段程序。我们先将 unit test 中常用的的部分，抽离出来成为所有 unit test 的父类: class DodoTestCase。

file `./dodo_test/util.py`:

```python
from dodo.app import create_app
from dodo.utils.gadget import db
import unittest

class DodoTestCase(unittest.TestCase):

    def setUp(self):
        self.app = create_app()
        self.client = self.app.test_client()
        self.logger = self.app.logger
        self.db = db
```

进行查询的 unit test, 查询 Item 对象，条件为 生产日期在 2017-08-01 之前，并且要 `Eager Fetch` 出关联的 Product 讯息。

注意到这里使用了 `with self.app.app_context():` 这样的写法，提供了 flask 运行环境的 context, 内含 SQLAlchemy 的 运行 session。如果不这么使用，会发生找不到 session 的错误。

file `./dodo_test/test_warehouse.py`:

```python
from dodo.model.warehouse import Item
from .util import DodoTestCase
from sqlalchemy.orm import joinedload

class WarehouseTestCase(DodoTestCase):
    def test_read_items(self):
        with self.app.app_context():
            query = self.db.session.query(Item).filter(Item.date_produce < '2017-08-01')
            items = query.options(joinedload(Item.product)).all()

        self.assertEqual(len(items), 2)
        for i in items:
            self.logger.info(i)
```

Run unit test

```bash
python -m unittest dodo_test.test_warehouse.WarehouseTestCase.test_read_items
# 18-05-21 17:00:01 INFO - application start. __name__ : dodo.app
# 18-05-21 17:00:01 INFO - <Item(id=4, product=curry lunchbox)>
# 18-05-21 17:00:01 INFO - <Item(id=5, product=instant noodle)>
# .
# ----------------------------------------------------------------------
# Ran 1 test in 0.058s
```