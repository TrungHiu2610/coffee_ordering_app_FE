// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class User extends _User with RealmEntity, RealmObjectBase, RealmObject {
  User(
    ObjectId id,
    String name,
    String email,
    String password,
    double totalPoint,
    String role,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'email', email);
    RealmObjectBase.set(this, 'password', password);
    RealmObjectBase.set(this, 'totalPoint', totalPoint);
    RealmObjectBase.set(this, 'role', role);
  }

  User._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String get email => RealmObjectBase.get<String>(this, 'email') as String;
  @override
  set email(String value) => RealmObjectBase.set(this, 'email', value);

  @override
  String get password =>
      RealmObjectBase.get<String>(this, 'password') as String;
  @override
  set password(String value) => RealmObjectBase.set(this, 'password', value);

  @override
  double get totalPoint =>
      RealmObjectBase.get<double>(this, 'totalPoint') as double;
  @override
  set totalPoint(double value) =>
      RealmObjectBase.set(this, 'totalPoint', value);

  @override
  String get role => RealmObjectBase.get<String>(this, 'role') as String;
  @override
  set role(String value) => RealmObjectBase.set(this, 'role', value);

  @override
  RealmResults<Invoice> get invoices {
    if (!isManaged) {
      throw RealmError('Using backlinks is only possible for managed objects.');
    }
    return RealmObjectBase.get<Invoice>(this, 'invoices')
        as RealmResults<Invoice>;
  }

  @override
  set invoices(covariant RealmResults<Invoice> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmResults<Review> get reviews {
    if (!isManaged) {
      throw RealmError('Using backlinks is only possible for managed objects.');
    }
    return RealmObjectBase.get<Review>(this, 'reviews') as RealmResults<Review>;
  }

  @override
  set reviews(covariant RealmResults<Review> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<User>> get changes =>
      RealmObjectBase.getChanges<User>(this);

  @override
  Stream<RealmObjectChanges<User>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<User>(this, keyPaths);

  @override
  User freeze() => RealmObjectBase.freezeObject<User>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'name': name.toEJson(),
      'email': email.toEJson(),
      'password': password.toEJson(),
      'totalPoint': totalPoint.toEJson(),
      'role': role.toEJson(),
    };
  }

  static EJsonValue _toEJson(User value) => value.toEJson();
  static User _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'name': EJsonValue name,
        'email': EJsonValue email,
        'password': EJsonValue password,
        'totalPoint': EJsonValue totalPoint,
        'role': EJsonValue role,
      } =>
        User(
          fromEJson(id),
          fromEJson(name),
          fromEJson(email),
          fromEJson(password),
          fromEJson(totalPoint),
          fromEJson(role),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(User._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, User, 'User', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('email', RealmPropertyType.string),
      SchemaProperty('password', RealmPropertyType.string),
      SchemaProperty('totalPoint', RealmPropertyType.double),
      SchemaProperty('role', RealmPropertyType.string),
      SchemaProperty('invoices', RealmPropertyType.linkingObjects,
          linkOriginProperty: 'user',
          collectionType: RealmCollectionType.list,
          linkTarget: 'Invoice'),
      SchemaProperty('reviews', RealmPropertyType.linkingObjects,
          linkOriginProperty: 'user',
          collectionType: RealmCollectionType.list,
          linkTarget: 'Review'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Category extends _Category
    with RealmEntity, RealmObjectBase, RealmObject {
  Category(
    ObjectId id,
    String name,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
  }

  Category._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  RealmResults<Product> get products {
    if (!isManaged) {
      throw RealmError('Using backlinks is only possible for managed objects.');
    }
    return RealmObjectBase.get<Product>(this, 'products')
        as RealmResults<Product>;
  }

  @override
  set products(covariant RealmResults<Product> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<Category>> get changes =>
      RealmObjectBase.getChanges<Category>(this);

  @override
  Stream<RealmObjectChanges<Category>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Category>(this, keyPaths);

  @override
  Category freeze() => RealmObjectBase.freezeObject<Category>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'name': name.toEJson(),
    };
  }

  static EJsonValue _toEJson(Category value) => value.toEJson();
  static Category _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'name': EJsonValue name,
      } =>
        Category(
          fromEJson(id),
          fromEJson(name),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Category._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Category, 'Category', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('products', RealmPropertyType.linkingObjects,
          linkOriginProperty: 'category',
          collectionType: RealmCollectionType.list,
          linkTarget: 'Product'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Product extends _Product with RealmEntity, RealmObjectBase, RealmObject {
  Product(
    ObjectId id,
    String name,
    double price,
    String description,
    String img,
    bool state, {
    Category? category,
    Iterable<Topping> toppings = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'price', price);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'img', img);
    RealmObjectBase.set(this, 'state', state);
    RealmObjectBase.set(this, 'category', category);
    RealmObjectBase.set<RealmList<Topping>>(
        this, 'toppings', RealmList<Topping>(toppings));
  }

  Product._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  double get price => RealmObjectBase.get<double>(this, 'price') as double;
  @override
  set price(double value) => RealmObjectBase.set(this, 'price', value);

  @override
  String get description =>
      RealmObjectBase.get<String>(this, 'description') as String;
  @override
  set description(String value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  String get img => RealmObjectBase.get<String>(this, 'img') as String;
  @override
  set img(String value) => RealmObjectBase.set(this, 'img', value);

  @override
  bool get state => RealmObjectBase.get<bool>(this, 'state') as bool;
  @override
  set state(bool value) => RealmObjectBase.set(this, 'state', value);

  @override
  Category? get category =>
      RealmObjectBase.get<Category>(this, 'category') as Category?;
  @override
  set category(covariant Category? value) =>
      RealmObjectBase.set(this, 'category', value);

  @override
  RealmList<Topping> get toppings =>
      RealmObjectBase.get<Topping>(this, 'toppings') as RealmList<Topping>;
  @override
  set toppings(covariant RealmList<Topping> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmResults<Review> get reviews {
    if (!isManaged) {
      throw RealmError('Using backlinks is only possible for managed objects.');
    }
    return RealmObjectBase.get<Review>(this, 'reviews') as RealmResults<Review>;
  }

  @override
  set reviews(covariant RealmResults<Review> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<Product>> get changes =>
      RealmObjectBase.getChanges<Product>(this);

  @override
  Stream<RealmObjectChanges<Product>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Product>(this, keyPaths);

  @override
  Product freeze() => RealmObjectBase.freezeObject<Product>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'name': name.toEJson(),
      'price': price.toEJson(),
      'description': description.toEJson(),
      'img': img.toEJson(),
      'state': state.toEJson(),
      'category': category.toEJson(),
      'toppings': toppings.toEJson(),
    };
  }

  static EJsonValue _toEJson(Product value) => value.toEJson();
  static Product _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'name': EJsonValue name,
        'price': EJsonValue price,
        'description': EJsonValue description,
        'img': EJsonValue img,
        'state': EJsonValue state,
      } =>
        Product(
          fromEJson(id),
          fromEJson(name),
          fromEJson(price),
          fromEJson(description),
          fromEJson(img),
          fromEJson(state),
          category: fromEJson(ejson['category']),
          toppings: fromEJson(ejson['toppings']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Product._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Product, 'Product', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('price', RealmPropertyType.double),
      SchemaProperty('description', RealmPropertyType.string),
      SchemaProperty('img', RealmPropertyType.string),
      SchemaProperty('state', RealmPropertyType.bool),
      SchemaProperty('category', RealmPropertyType.object,
          optional: true, linkTarget: 'Category'),
      SchemaProperty('toppings', RealmPropertyType.object,
          linkTarget: 'Topping', collectionType: RealmCollectionType.list),
      SchemaProperty('reviews', RealmPropertyType.linkingObjects,
          linkOriginProperty: 'product',
          collectionType: RealmCollectionType.list,
          linkTarget: 'Review'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Cart extends _Cart with RealmEntity, RealmObjectBase, RealmObject {
  Cart(
    ObjectId id,
    DateTime createTime, {
    User? user,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'createTime', createTime);
    RealmObjectBase.set(this, 'user', user);
  }

  Cart._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  DateTime get createTime =>
      RealmObjectBase.get<DateTime>(this, 'createTime') as DateTime;
  @override
  set createTime(DateTime value) =>
      RealmObjectBase.set(this, 'createTime', value);

  @override
  User? get user => RealmObjectBase.get<User>(this, 'user') as User?;
  @override
  set user(covariant User? value) => RealmObjectBase.set(this, 'user', value);

  @override
  RealmResults<CartItem> get cartItems {
    if (!isManaged) {
      throw RealmError('Using backlinks is only possible for managed objects.');
    }
    return RealmObjectBase.get<CartItem>(this, 'cartItems')
        as RealmResults<CartItem>;
  }

  @override
  set cartItems(covariant RealmResults<CartItem> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<Cart>> get changes =>
      RealmObjectBase.getChanges<Cart>(this);

  @override
  Stream<RealmObjectChanges<Cart>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Cart>(this, keyPaths);

  @override
  Cart freeze() => RealmObjectBase.freezeObject<Cart>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'createTime': createTime.toEJson(),
      'user': user.toEJson(),
    };
  }

  static EJsonValue _toEJson(Cart value) => value.toEJson();
  static Cart _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'createTime': EJsonValue createTime,
      } =>
        Cart(
          fromEJson(id),
          fromEJson(createTime),
          user: fromEJson(ejson['user']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Cart._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Cart, 'Cart', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('createTime', RealmPropertyType.timestamp),
      SchemaProperty('user', RealmPropertyType.object,
          optional: true, linkTarget: 'User'),
      SchemaProperty('cartItems', RealmPropertyType.linkingObjects,
          linkOriginProperty: 'cart',
          collectionType: RealmCollectionType.list,
          linkTarget: 'CartItem'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class CartItem extends _CartItem
    with RealmEntity, RealmObjectBase, RealmObject {
  CartItem(
    ObjectId id,
    int quantity,
    String description, {
    Cart? cart,
    Product? product,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'quantity', quantity);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'cart', cart);
    RealmObjectBase.set(this, 'product', product);
  }

  CartItem._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  int get quantity => RealmObjectBase.get<int>(this, 'quantity') as int;
  @override
  set quantity(int value) => RealmObjectBase.set(this, 'quantity', value);

  @override
  String get description =>
      RealmObjectBase.get<String>(this, 'description') as String;
  @override
  set description(String value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  Cart? get cart => RealmObjectBase.get<Cart>(this, 'cart') as Cart?;
  @override
  set cart(covariant Cart? value) => RealmObjectBase.set(this, 'cart', value);

  @override
  Product? get product =>
      RealmObjectBase.get<Product>(this, 'product') as Product?;
  @override
  set product(covariant Product? value) =>
      RealmObjectBase.set(this, 'product', value);

  @override
  Stream<RealmObjectChanges<CartItem>> get changes =>
      RealmObjectBase.getChanges<CartItem>(this);

  @override
  Stream<RealmObjectChanges<CartItem>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<CartItem>(this, keyPaths);

  @override
  CartItem freeze() => RealmObjectBase.freezeObject<CartItem>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'quantity': quantity.toEJson(),
      'description': description.toEJson(),
      'cart': cart.toEJson(),
      'product': product.toEJson(),
    };
  }

  static EJsonValue _toEJson(CartItem value) => value.toEJson();
  static CartItem _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'quantity': EJsonValue quantity,
        'description': EJsonValue description,
      } =>
        CartItem(
          fromEJson(id),
          fromEJson(quantity),
          fromEJson(description),
          cart: fromEJson(ejson['cart']),
          product: fromEJson(ejson['product']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(CartItem._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, CartItem, 'CartItem', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('quantity', RealmPropertyType.int),
      SchemaProperty('description', RealmPropertyType.string),
      SchemaProperty('cart', RealmPropertyType.object,
          optional: true, linkTarget: 'Cart'),
      SchemaProperty('product', RealmPropertyType.object,
          optional: true, linkTarget: 'Product'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Invoice extends _Invoice with RealmEntity, RealmObjectBase, RealmObject {
  Invoice(
    ObjectId id,
    DateTime createTime,
    DateTime completeTime,
    String state,
    String paymentMethod,
    double total,
    double rewardPoint, {
    User? user,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'createTime', createTime);
    RealmObjectBase.set(this, 'completeTime', completeTime);
    RealmObjectBase.set(this, 'state', state);
    RealmObjectBase.set(this, 'paymentMethod', paymentMethod);
    RealmObjectBase.set(this, 'total', total);
    RealmObjectBase.set(this, 'rewardPoint', rewardPoint);
    RealmObjectBase.set(this, 'user', user);
  }

  Invoice._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  DateTime get createTime =>
      RealmObjectBase.get<DateTime>(this, 'createTime') as DateTime;
  @override
  set createTime(DateTime value) =>
      RealmObjectBase.set(this, 'createTime', value);

  @override
  DateTime get completeTime =>
      RealmObjectBase.get<DateTime>(this, 'completeTime') as DateTime;
  @override
  set completeTime(DateTime value) =>
      RealmObjectBase.set(this, 'completeTime', value);

  @override
  String get state => RealmObjectBase.get<String>(this, 'state') as String;
  @override
  set state(String value) => RealmObjectBase.set(this, 'state', value);

  @override
  String get paymentMethod =>
      RealmObjectBase.get<String>(this, 'paymentMethod') as String;
  @override
  set paymentMethod(String value) =>
      RealmObjectBase.set(this, 'paymentMethod', value);

  @override
  double get total => RealmObjectBase.get<double>(this, 'total') as double;
  @override
  set total(double value) => RealmObjectBase.set(this, 'total', value);

  @override
  double get rewardPoint =>
      RealmObjectBase.get<double>(this, 'rewardPoint') as double;
  @override
  set rewardPoint(double value) =>
      RealmObjectBase.set(this, 'rewardPoint', value);

  @override
  User? get user => RealmObjectBase.get<User>(this, 'user') as User?;
  @override
  set user(covariant User? value) => RealmObjectBase.set(this, 'user', value);

  @override
  RealmResults<InvoiceItem> get invoiceItems {
    if (!isManaged) {
      throw RealmError('Using backlinks is only possible for managed objects.');
    }
    return RealmObjectBase.get<InvoiceItem>(this, 'invoiceItems')
        as RealmResults<InvoiceItem>;
  }

  @override
  set invoiceItems(covariant RealmResults<InvoiceItem> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<Invoice>> get changes =>
      RealmObjectBase.getChanges<Invoice>(this);

  @override
  Stream<RealmObjectChanges<Invoice>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Invoice>(this, keyPaths);

  @override
  Invoice freeze() => RealmObjectBase.freezeObject<Invoice>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'createTime': createTime.toEJson(),
      'completeTime': completeTime.toEJson(),
      'state': state.toEJson(),
      'paymentMethod': paymentMethod.toEJson(),
      'total': total.toEJson(),
      'rewardPoint': rewardPoint.toEJson(),
      'user': user.toEJson(),
    };
  }

  static EJsonValue _toEJson(Invoice value) => value.toEJson();
  static Invoice _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'createTime': EJsonValue createTime,
        'completeTime': EJsonValue completeTime,
        'state': EJsonValue state,
        'paymentMethod': EJsonValue paymentMethod,
        'total': EJsonValue total,
        'rewardPoint': EJsonValue rewardPoint,
      } =>
        Invoice(
          fromEJson(id),
          fromEJson(createTime),
          fromEJson(completeTime),
          fromEJson(state),
          fromEJson(paymentMethod),
          fromEJson(total),
          fromEJson(rewardPoint),
          user: fromEJson(ejson['user']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Invoice._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Invoice, 'Invoice', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('createTime', RealmPropertyType.timestamp),
      SchemaProperty('completeTime', RealmPropertyType.timestamp),
      SchemaProperty('state', RealmPropertyType.string),
      SchemaProperty('paymentMethod', RealmPropertyType.string),
      SchemaProperty('total', RealmPropertyType.double),
      SchemaProperty('rewardPoint', RealmPropertyType.double),
      SchemaProperty('user', RealmPropertyType.object,
          optional: true, linkTarget: 'User'),
      SchemaProperty('invoiceItems', RealmPropertyType.linkingObjects,
          linkOriginProperty: 'invoice',
          collectionType: RealmCollectionType.list,
          linkTarget: 'InvoiceItem'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class InvoiceItem extends _InvoiceItem
    with RealmEntity, RealmObjectBase, RealmObject {
  InvoiceItem(
    ObjectId id,
    int quantity,
    double price,
    String description, {
    Invoice? invoice,
    Product? product,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'quantity', quantity);
    RealmObjectBase.set(this, 'price', price);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'invoice', invoice);
    RealmObjectBase.set(this, 'product', product);
  }

  InvoiceItem._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  int get quantity => RealmObjectBase.get<int>(this, 'quantity') as int;
  @override
  set quantity(int value) => RealmObjectBase.set(this, 'quantity', value);

  @override
  double get price => RealmObjectBase.get<double>(this, 'price') as double;
  @override
  set price(double value) => RealmObjectBase.set(this, 'price', value);

  @override
  String get description =>
      RealmObjectBase.get<String>(this, 'description') as String;
  @override
  set description(String value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  Invoice? get invoice =>
      RealmObjectBase.get<Invoice>(this, 'invoice') as Invoice?;
  @override
  set invoice(covariant Invoice? value) =>
      RealmObjectBase.set(this, 'invoice', value);

  @override
  Product? get product =>
      RealmObjectBase.get<Product>(this, 'product') as Product?;
  @override
  set product(covariant Product? value) =>
      RealmObjectBase.set(this, 'product', value);

  @override
  Stream<RealmObjectChanges<InvoiceItem>> get changes =>
      RealmObjectBase.getChanges<InvoiceItem>(this);

  @override
  Stream<RealmObjectChanges<InvoiceItem>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<InvoiceItem>(this, keyPaths);

  @override
  InvoiceItem freeze() => RealmObjectBase.freezeObject<InvoiceItem>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'quantity': quantity.toEJson(),
      'price': price.toEJson(),
      'description': description.toEJson(),
      'invoice': invoice.toEJson(),
      'product': product.toEJson(),
    };
  }

  static EJsonValue _toEJson(InvoiceItem value) => value.toEJson();
  static InvoiceItem _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'quantity': EJsonValue quantity,
        'price': EJsonValue price,
        'description': EJsonValue description,
      } =>
        InvoiceItem(
          fromEJson(id),
          fromEJson(quantity),
          fromEJson(price),
          fromEJson(description),
          invoice: fromEJson(ejson['invoice']),
          product: fromEJson(ejson['product']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(InvoiceItem._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, InvoiceItem, 'InvoiceItem', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('quantity', RealmPropertyType.int),
      SchemaProperty('price', RealmPropertyType.double),
      SchemaProperty('description', RealmPropertyType.string),
      SchemaProperty('invoice', RealmPropertyType.object,
          optional: true, linkTarget: 'Invoice'),
      SchemaProperty('product', RealmPropertyType.object,
          optional: true, linkTarget: 'Product'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Review extends _Review with RealmEntity, RealmObjectBase, RealmObject {
  Review(
    ObjectId id,
    String content,
    int starRate,
    DateTime postTime, {
    User? user,
    Product? product,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'content', content);
    RealmObjectBase.set(this, 'starRate', starRate);
    RealmObjectBase.set(this, 'postTime', postTime);
    RealmObjectBase.set(this, 'user', user);
    RealmObjectBase.set(this, 'product', product);
  }

  Review._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get content => RealmObjectBase.get<String>(this, 'content') as String;
  @override
  set content(String value) => RealmObjectBase.set(this, 'content', value);

  @override
  int get starRate => RealmObjectBase.get<int>(this, 'starRate') as int;
  @override
  set starRate(int value) => RealmObjectBase.set(this, 'starRate', value);

  @override
  DateTime get postTime =>
      RealmObjectBase.get<DateTime>(this, 'postTime') as DateTime;
  @override
  set postTime(DateTime value) => RealmObjectBase.set(this, 'postTime', value);

  @override
  User? get user => RealmObjectBase.get<User>(this, 'user') as User?;
  @override
  set user(covariant User? value) => RealmObjectBase.set(this, 'user', value);

  @override
  Product? get product =>
      RealmObjectBase.get<Product>(this, 'product') as Product?;
  @override
  set product(covariant Product? value) =>
      RealmObjectBase.set(this, 'product', value);

  @override
  Stream<RealmObjectChanges<Review>> get changes =>
      RealmObjectBase.getChanges<Review>(this);

  @override
  Stream<RealmObjectChanges<Review>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Review>(this, keyPaths);

  @override
  Review freeze() => RealmObjectBase.freezeObject<Review>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'content': content.toEJson(),
      'starRate': starRate.toEJson(),
      'postTime': postTime.toEJson(),
      'user': user.toEJson(),
      'product': product.toEJson(),
    };
  }

  static EJsonValue _toEJson(Review value) => value.toEJson();
  static Review _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'content': EJsonValue content,
        'starRate': EJsonValue starRate,
        'postTime': EJsonValue postTime,
      } =>
        Review(
          fromEJson(id),
          fromEJson(content),
          fromEJson(starRate),
          fromEJson(postTime),
          user: fromEJson(ejson['user']),
          product: fromEJson(ejson['product']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Review._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Review, 'Review', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('content', RealmPropertyType.string),
      SchemaProperty('starRate', RealmPropertyType.int),
      SchemaProperty('postTime', RealmPropertyType.timestamp),
      SchemaProperty('user', RealmPropertyType.object,
          optional: true, linkTarget: 'User'),
      SchemaProperty('product', RealmPropertyType.object,
          optional: true, linkTarget: 'Product'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Size extends _Size with RealmEntity, RealmObjectBase, RealmObject {
  Size(
    ObjectId id,
    String name,
    double price,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'price', price);
  }

  Size._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  double get price => RealmObjectBase.get<double>(this, 'price') as double;
  @override
  set price(double value) => RealmObjectBase.set(this, 'price', value);

  @override
  Stream<RealmObjectChanges<Size>> get changes =>
      RealmObjectBase.getChanges<Size>(this);

  @override
  Stream<RealmObjectChanges<Size>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Size>(this, keyPaths);

  @override
  Size freeze() => RealmObjectBase.freezeObject<Size>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'name': name.toEJson(),
      'price': price.toEJson(),
    };
  }

  static EJsonValue _toEJson(Size value) => value.toEJson();
  static Size _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'name': EJsonValue name,
        'price': EJsonValue price,
      } =>
        Size(
          fromEJson(id),
          fromEJson(name),
          fromEJson(price),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Size._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Size, 'Size', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('price', RealmPropertyType.double),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Topping extends _Topping with RealmEntity, RealmObjectBase, RealmObject {
  Topping(
    ObjectId id,
    String name,
    double price,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'price', price);
  }

  Topping._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  double get price => RealmObjectBase.get<double>(this, 'price') as double;
  @override
  set price(double value) => RealmObjectBase.set(this, 'price', value);

  @override
  Stream<RealmObjectChanges<Topping>> get changes =>
      RealmObjectBase.getChanges<Topping>(this);

  @override
  Stream<RealmObjectChanges<Topping>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Topping>(this, keyPaths);

  @override
  Topping freeze() => RealmObjectBase.freezeObject<Topping>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'name': name.toEJson(),
      'price': price.toEJson(),
    };
  }

  static EJsonValue _toEJson(Topping value) => value.toEJson();
  static Topping _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'name': EJsonValue name,
        'price': EJsonValue price,
      } =>
        Topping(
          fromEJson(id),
          fromEJson(name),
          fromEJson(price),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Topping._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Topping, 'Topping', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('price', RealmPropertyType.double),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class ProductSize extends _ProductSize
    with RealmEntity, RealmObjectBase, RealmObject {
  ProductSize(
    ObjectId id,
    double additionalPrice, {
    Product? product,
    Size? size,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'product', product);
    RealmObjectBase.set(this, 'size', size);
    RealmObjectBase.set(this, 'additionalPrice', additionalPrice);
  }

  ProductSize._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  Product? get product =>
      RealmObjectBase.get<Product>(this, 'product') as Product?;
  @override
  set product(covariant Product? value) =>
      RealmObjectBase.set(this, 'product', value);

  @override
  Size? get size => RealmObjectBase.get<Size>(this, 'size') as Size?;
  @override
  set size(covariant Size? value) => RealmObjectBase.set(this, 'size', value);

  @override
  double get additionalPrice =>
      RealmObjectBase.get<double>(this, 'additionalPrice') as double;
  @override
  set additionalPrice(double value) =>
      RealmObjectBase.set(this, 'additionalPrice', value);

  @override
  Stream<RealmObjectChanges<ProductSize>> get changes =>
      RealmObjectBase.getChanges<ProductSize>(this);

  @override
  Stream<RealmObjectChanges<ProductSize>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<ProductSize>(this, keyPaths);

  @override
  ProductSize freeze() => RealmObjectBase.freezeObject<ProductSize>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'product': product.toEJson(),
      'size': size.toEJson(),
      'additionalPrice': additionalPrice.toEJson(),
    };
  }

  static EJsonValue _toEJson(ProductSize value) => value.toEJson();
  static ProductSize _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'additionalPrice': EJsonValue additionalPrice,
      } =>
        ProductSize(
          fromEJson(id),
          fromEJson(additionalPrice),
          product: fromEJson(ejson['product']),
          size: fromEJson(ejson['size']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(ProductSize._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, ProductSize, 'ProductSize', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('product', RealmPropertyType.object,
          optional: true, linkTarget: 'Product'),
      SchemaProperty('size', RealmPropertyType.object,
          optional: true, linkTarget: 'Size'),
      SchemaProperty('additionalPrice', RealmPropertyType.double),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
