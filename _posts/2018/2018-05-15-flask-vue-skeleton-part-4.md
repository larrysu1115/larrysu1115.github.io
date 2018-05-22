---
layout: post
title: "Flask + Vue.js : Part 4"
description: ""
category: programming
tags: [python, vue.js]
---

- Part 1 : [Environment, Flask HelloWorld, Blueprint](flask-vue-skeleton.html)
- Part 2 : [Flask config, logging, unit-testing, SQLAlchemy](flask-vue-skeleton-part-2.html)
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

## Flask-Security

接着要将权限管理整合进来，让系统具有权限管控的能力，包含:

- 使用者管理
- 权限分配
- API token 权限验证

这里使用的 Flask-Security 套件，聚焦在权限相关功能，整合了许多 python 的工具。我们来看看如何将 Flask-Security 添加进来。

```
pip install flask-security
```

file `./dodo/utils/gadget.py` 添加这两行:

```python
from flask_security import Security
security = Security()
```

file `./config/development.py` 添加:

```python
SECURITY_PASSWORD_SALT = 'askme'
# use simple crypt in dev mode.
SECURITY_HASHING_SCHEMES = 'des_crypt'
SECURITY_PASSWORD_HASH = 'des_crypt'
SECURITY_DEPRECATED_HASHING_SCHEMES = []
# for token to work
WTF_CSRF_ENABLED = False
```

file `./dodo/model/auth.py` 添加用户权限对应的 Model 数据库表 User, Role:

```python
from flask_security import UserMixin, RoleMixin

from ..utils.gadget import db

class RolesUsers(db.Model):
    __tablename__ = 'auth_roles_users'
    id = db.Column(db.Integer(), primary_key=True)
    user_id = db.Column('user_id', db.Integer(), db.ForeignKey('auth_user.id'))
    role_id = db.Column('role_id', db.Integer(), db.ForeignKey('auth_role.id'))

class Role(db.Model, RoleMixin):
    __tablename__ = 'auth_role'
    id = db.Column(db.Integer(), primary_key=True)
    name = db.Column(db.String(80), unique=True)
    description = db.Column(db.String(255))

    def __str__(self):
        return self.name

    def __hash__(self):
        return hash(self.name)

class User(db.Model, UserMixin):
    __tablename__ = 'auth_user'
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(255), unique=True)
    password = db.Column(db.String(255))
    active = db.Column(db.Boolean())
    confirmed_at = db.Column(db.DateTime())
    roles = db.relationship(
        'Role',
        secondary='auth_roles_users',
        backref=db.backref('users', lazy='dynamic'))

    def __str__(self):
        return self.email
```

file `./dodo/admin/view.py` 添加 Role, User 的 表单管理到 Flask-Admin

```python
from flask_admin.contrib import sqla
from flask_admin.menu import MenuLink
from flask_security import current_user
from wtforms.fields import PasswordField

from ..utils.gadget import fadmin, db
from ..model.warehouse import Product, Item
from ..model.auth import User, Role

...

class UserView(sqla.ModelView):
    column_exclude_list = ('password',)
    form_excluded_columns = ('password',)
    column_auto_select_related = True

    def is_accessible(self):
        return current_user.has_role('admin')

    def scaffold_form(self):
        form_class = super(UserView, self).scaffold_form()
        form_class.password2 = PasswordField('New Password')
        return form_class

    def on_model_change(self, form, model, is_created):
        if len(model.password2):
            model.password = utils.encrypt_password(model.password2)

class RoleView(sqla.ModelView):
    def is_accessible(self):
        return current_user.has_role('admin')

fadmin.add_view(RoleView(Role, db.session, category='Admin'))
fadmin.add_view(UserView(User, db.session, category='Admin'))
...
```

file `./dodo/utils/database.py` 添加用户和角色:

```python
from .gadget import security
...
def setup_database(app):
    with app.app_context():
        ...

        ds = security.datastore
        role_admin = ds.find_or_create_role(name='admin', description='Administrator')
        role_user = ds.find_or_create_role(name='user', description='Normal User')
        ds.create_user(email='user@sws9f.org', password='user')
        ds.create_user(email='admin@sws9f.org', password='admin')
        db.session.commit()

        ds.add_role_to_user('user@sws9f.org', 'user')
        ds.add_role_to_user('admin@sws9f.org', 'admin')
        db.session.commit()
```

file `./dodo/app.py` 修改成:

```python
from flask import Flask, jsonify, url_for
from .doggy.api import blueprint_api
from .warehouse.api import blueprint_api as warehouse_api
import logging.config
from .utils.database import setup_database
from .utils.swagger import setup_swagger
from .utils.gadget import db
from .utils.gadget import fadmin
from .utils.gadget import security
from flask_admin import helpers as admin_helpers
from flask_security import Security, SQLAlchemyUserDatastore
from .model.auth import User, Role

def create_app():
    app = Flask(__name__)
    # setup configuration from ./config/development.py
    app.config.from_object('config.development')
    # setup configuration from a environment variable which contains a file path
    app.config.from_envvar('APP_CONFIG_FILE', silent=True)
    # load logging setting
    logging.config.fileConfig('./config/logging.cfg')

    db.init_app(app)
    fadmin.init_app(app)

    user_datastore = SQLAlchemyUserDatastore(db, User, Role)
    security.init_app(app, user_datastore)
    security_app = app.extensions['security']
    @security_app.context_processor
    def security_context_processor():
        return dict(
            admin_base_template=fadmin.base_template,
            admin_view=fadmin.index_view,
            h=admin_helpers,
            get_url=url_for
        )

    setup_database(app)
    app.register_blueprint(blueprint_api, url_prefix='/doggy/api')
    app.register_blueprint(warehouse_api, url_prefix='/warehouse')
    from .admin import view
    setup_swagger(app)

    app.logger.info('application start. __name__ : %s', __name__)
    
    return app

if __name__ == '__main__':
    app = create_app()
    app.run()
```

接着启动 flask, 访问 [http://localhost:5000/login](http://localhost:5000/login) 进行登入，输入

- 管理员: admin@sws9f.org / admin
- 一般用户: user@sws9f.org / user

再访问管理后台地址 [http://localhost:5000/admin](http://localhost:5000/admin) 可以看到只有 admin 管理员才有 使用者管理 的菜单 "ADMIN"

如果使用一般用户登入，就不会有 使用者管理 的界面出现。

<img src="/assets/img/2018/flask-vue-flask-security.png" />

## API Token

Flask-Security 也可以提供 api 需要使用的 token。例如:

```bash
curl -H "content-type: application/json" -d '{"email":"user@sws9f.org", "password":"user"}' \
  http://127.0.0.1:5000/login
# output
# { "meta": { "code":200 },
#   "response": {
#     "user": { "authentication_token":"WyIxIiwicnNsU005LkIxL3BJUSJd.DeVJiQ.0QjkwA-8ZQnmTASHIS5eImX5x2A",
#               "id":"1" }
#   }
# }
```

我们可以将 api 加上 decorator : @auth_token_required，就可以限制必须带有有效的 token 才可以访问。
如下我们将 warehouse Blueprint 加上一个需要 登入后使用 token 才可以访问的 API。

file `./dodo/warehouse/ma_schema.py` 添加一行

```python
schema_products = ProductSchema(many=True)
```

file `./dodo/warehouse/api.py` 加入一个需要 token 认证才允许访问的 API

```python
...
from ..model.warehouse import Item, Product
from .ma_schema import schema_items, schema_products
from flask_security import auth_token_required, current_user

@blueprint_api.route('/product', methods=['GET'])
@auth_token_required
def get_products():
    """
    Product list
    ---
    tags:
      - warehouse
    description: Get all products in the store
    responses:
        200:
            description: list of products
            schema:
                $ref: '#/definitions/Product'
    """
    products = db.session.query(Product).all()
    products = schema_products.dump(products)[0]
    data = dict(user=current_user.email, products=products)
    return jsonify(data)
```

测试呼叫这个 API

```bash
# 没有带上 token 的访问，被限制。
curl http://127.0.0.1:5000/warehouse/product
    # <h1>Unauthorized</h1>
    # <p>The server could not verify that you are authorized to access the URL
    # requested. You either supplied the wrong credentials (e.g. a bad password),
    # or your browser doesn't understand how to supply the credentials required.
    # </p>

# 带上合法 token 的访问，则可以成功获得 API 的讯息。
# API 也可以辨识出该 token 所属的使用者。
curl -H "Authentication-Token:WyIxIiwiZnF1TUVma0ZWRnM5QSJd.DeVNqA.cPV-04NRHC0lRZFgITfGDSqtNfI" \
  http://127.0.0.1:5000/warehouse/product
# { "products" : [ {"id":1,"name":"milk"},
#                  {"id":2,"name":"curry lunchbox"},
#                  {"id":3,"name":"instant noodle"} ],
#   "user" : "user@sws9f.org"
# }
```

## Swagger UI with TOKEN

回到 Swagger UI 提供的 apidocs 文档上，我们也可以加上 token 的设置，让这个界面也使用 token 来呼叫 API。

先修正一下刚才添加的 get_products API 定义

file `./dodo/utils/swagger.py` 加入 get_products 路径的定义

```python
from ..warehouse.api import get_items, get_products

def setup_swagger(app):
    ...
    template = spec.to_flasgger(
        app,
        definitions=[ProductSchema, ItemSchema],
        paths=[get_items, get_products]
    )
    swag = Swagger(app, template=template)
    ...
```

file `./config/development.py` 加入 SWAGGER Bearer 的设定:

```python
SWAGGER = {
    "securityDefinitions": {
        "Bearer": {
            "type": "apiKey",
            "name": "Authentication-Token",
            "in": "header"
        }
    }
}
```

接着启动 Flask app, 就可以看见 Swagger UI 右上方多了 Authorize 的配置，可以输入有效的 token 来访问受限制的 API。

```bash
FLASK_APP=dodo/app.py flask run
```

<img src="/assets/img/2018/flask-vue-api-ui-auth.png" />