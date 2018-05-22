---
layout: post
title: "Flask + Vue.js : Part 3"
description: ""
category: programming
tags: [python, vue.js]
---

- Part 1 : [environment, flask HelloWorld, blueprint](flask-vue-skeleton.html)
- Part 2 : [Flask config, logging, unit-testing, SQLAlchemy](flask-vue-skeleton-part-2.html)
- **Part 3 : Restful API, Marshmallow, Swagger apidoc**
- Part 4 : [Flask-Admin, Flask-Security](flask-vue-skeleton-part-4.html)
- Part 5 : Vue.js

## Restful API, marshmallow

这个部分制作 json 格式的 API。利用 marshmallow 来定义 API 的 json 格式。

```bash
pip install flask_marshmallow
pip install marshmallow-sqlalchemy
```

file `./dodo/utils/gadget.py` 加入这两行:

```python
from flask_marshmallow import Marshmallow
ma = Marshmallow()
```

file `./dodo/warehouse/ma_schema.py`:

```python
from marshmallow import fields

from ..utils.gadget import ma
from ..model.warehouse import Product, Item

class ProductSchema(ma.Schema):
    id = fields.Int()
    name = fields.Str()

class ItemSchema(ma.Schema):
    id = fields.Int()
    name = fields.Str()
    product = fields.Nested(ProductSchema)
    date_produce = fields.Date()

schema_items = ItemSchema(many=True)
```

file `./dodo/warehouse/api.py`:

```python
from flask import Blueprint, jsonify
from flask import current_app as app
from ..model.warehouse import Item
from sqlalchemy.orm import joinedload
from .ma_schema import schema_items
from ..utils.gadget import db

blueprint_api = Blueprint('warehouse_api', __name__)

@blueprint_api.route('/item', methods=['GET'])
def get_items():
    query = db.session.query(Item).filter(Item.date_produce < '2017-08-01')
    items = query.options(joinedload(Item.product)).all()
    data = schema_items.dump(items)[0]
    return jsonify(data)
```

file `./dodo/app.py`

```python
from .warehouse.api import blueprint_api as warehouse_api

def create_app():
    ...
    app.register_blueprint(warehouse_api, url_prefix='/warehouse')
    ...
```

file `./dodo_test/test_warehouse.py`

```python
import json
from pprint import pformat

class WarehouseTestCase(DodoTestCase):
    def test_api_items(self):
        rv = self.client.get(
            '/warehouse/item',
            headers={'content-type': 'application/json'})
        data = json.loads(rv.data)
        self.app.logger.info('return object: \n%s', pformat(data))
        self.assertEqual(len(data), 2, 'Should return 2 objects')
```

Take a look at our work.

```bash
python -m unittest dodo_test.test_warehouse.WarehouseTestCase.test_api_items
# 18-05-21 18:28:29 INFO - application start. __name__ : dodo.app
# 18-05-21 18:28:29 INFO - return object: 
# [{'date_produce': '2017-07-31',
#   'id': 4,
#   'product': {'id': 2, 'name': 'curry lunchbox'}},
#  {'date_produce': '2017-06-01',
#   'id': 5,
#   'product': {'id': 3, 'name': 'instant noodle'}}]
# .
# ----------------------------------------------------------------------
# Ran 1 test in 0.047s
```

## Swagger apidoc

使用 Swagger UI 提供 Open API 格式的说明文件。

```bash
pip install flasgger
pip install apispec
```

为 API method 提供 docstring, Swagger 会将这里的讯息转换成 apidoc 在 UI 上呈现。

file `./dodo/warehouse/api.py`

```python
...
@blueprint_api.route('/item', methods=['GET'])
def get_items():
    """
    Item list
    ---
    tags:
      - warehouse
    description: Get all items in the store
    responses:
        200:
            description: list of items
            schema:
                $ref: '#/definitions/Item'
    """
    query = db.session.query(Item).filter(Item.date_produce < '2017-08-01')
...
```

file `./dodo/utils/swagger.py`

```python
from flasgger import APISpec, Swagger

from ..warehouse.api import get_items
from ..warehouse.ma_schema import ProductSchema, ItemSchema

def setup_swagger(app):
    spec = APISpec(
        title='dodo',
        version='0.0.1',
        plugins=[
            'apispec.ext.flask',
            'apispec.ext.marshmallow'
        ]
    )
    template = spec.to_flasgger(
        app,
        definitions=[ProductSchema, ItemSchema],
        paths=[get_items]
    )
    swag = Swagger(app, template=template)
```

file `./dodo/app.py`

```python
from .utils.swagger import setup_swagger
...
def create_app():
    ...
    setup_database(app)
    setup_swagger(app)

    return app
```

启动 flask 后，访问 [http://localhost:5000/apidocs/](http://localhost:5000/apidocs/) 就会看到 apidoc 的界面。

<img src="/assets/img/2018/flask-vue-api-ui.png" style="width:450px" />