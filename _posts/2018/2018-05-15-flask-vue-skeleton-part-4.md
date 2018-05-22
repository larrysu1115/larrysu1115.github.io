---
layout: post
title: "Flask + Vue.js : Part 4"
description: ""
category: programming
tags: [python, vue.js]
---

- Part 1 : [environment, flask HelloWorld, blueprint](flask-vue-skeleton.html)
- Part 2 : [flask config, logging, unit-testing, SQLAlchemy](flask-vue-skeleton-part-2.html)
- Part 3 : [Restful API, Marshmallow, Swagger apidoc](flask-vue-skeleton-part-3.html)
- Part 4 : **Flask-Admin, Flask-Security**
- Part 5 : Vue.js

## Flask-Admin

[Flask-Admin](https://flask-admin.readthedocs.io) 提供了一个简易的方式制作表单 增刪改查CRUD 的界面，適合作為系統後台快速開發用。

```bash
pip install flask-admin
```

先初始化 Flask-Admin，添加到 Flask app 中。

file `./dodo/utils/gadget.py` 添加这两行:

```python
from flask_admin import Admin
fadmin = Admin(name='Dodo', template_mode='bootstrap3')
```

file `./config/development.py` 添加 SECRET_KEY 的设定，在正式环境的 SECRET_KEY 必须保密不要外泄。

```python
SECRET_KEY = 'change-on-production-env'
```

接下来添加对 Model: Product, Item 的 增删改查界面

file `./dodo/admin/view.py`

```python
from flask_admin.contrib import sqla
from flask_admin.menu import MenuLink

from ..utils.gadget import fadmin, db
from ..model.warehouse import Product, Item

class ProductView(sqla.ModelView):
    can_create = False
    column_list = ('id', 'name', 'expiration_days')

class ItemView(sqla.ModelView):
    column_display_pk = True
    column_list = ('id', 'date_produce', 'product', 'product.name')

fadmin.add_view(ProductView(Product, db.session))
fadmin.add_view(ItemView(Item, db.session))

fadmin.add_link(MenuLink(name='Swagger', url='/apidocs'))
``` 

file `./dodo/app.py` 添加三行:

```python
from .utils.gadget import fadmin  # add this line

def create_app():
    ...
    db.init_app(app)
    setup_database(app)
    fadmin.init_app(app)          # add this line

    app.register_blueprint(blueprint_api, url_prefix='/doggy/api')
    app.register_blueprint(warehouse_api, url_prefix='/warehouse')
    from .admin import view       # add this line
    setup_swagger(app)

    app.logger.info('application start. __name__ : %s', __name__)
    ...
    return app
```

运行 flask，访问 [http://localhost:5000/admin](http://localhost:5000/admin) ，就可以看到 Flask-Admin 产生的后台，提供了 Model: Product, Item 两张表的增删改查界面！

<img src="/assets/img/2018/flask-vue-flask-admin.png" />