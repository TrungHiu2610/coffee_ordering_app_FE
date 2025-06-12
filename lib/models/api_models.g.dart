// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Table _$TableFromJson(Map<String, dynamic> json) => Table(
      id: (json['id'] as num).toInt(),
      tableNumber: (json['tableNumber'] as num).toInt(),
      isOccupied: json['isOccupied'] as bool,
      occupiedAt: json['occupiedAt'] == null
          ? null
          : DateTime.parse(json['occupiedAt'] as String),
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$TableToJson(Table instance) => <String, dynamic>{
      'id': instance.id,
      'tableNumber': instance.tableNumber,
      'isOccupied': instance.isOccupied,
      'occupiedAt': instance.occupiedAt?.toIso8601String(),
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
    };

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      isAvailable: json['isAvailable'] as bool,
      categoryId: (json['categoryId'] as num).toInt(),
      category: json['category'] == null
          ? null
          : Category.fromJson(json['category'] as Map<String, dynamic>),
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
          .toList(),
      productSizes: (json['productSizes'] as List<dynamic>?)
          ?.map((e) => ProductSize.fromJson(e as Map<String, dynamic>))
          .toList(),
      productToppings: (json['productToppings'] as List<dynamic>?)
          ?.map((e) => ProductTopping.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'isAvailable': instance.isAvailable,
      'categoryId': instance.categoryId,
      'category': instance.category,
      'reviews': instance.reviews,
      'productSizes': instance.productSizes,
      'productToppings': instance.productToppings,
    };

Size _$SizeFromJson(Map<String, dynamic> json) => Size(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$SizeToJson(Size instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

ProductSize _$ProductSizeFromJson(Map<String, dynamic> json) => ProductSize(
      id: (json['id'] as num).toInt(),
      productId: (json['productId'] as num).toInt(),
      sizeId: (json['sizeId'] as num).toInt(),
      additionalPrice: (json['additionalPrice'] as num).toDouble(),
      size: json['size'] == null
          ? null
          : Size.fromJson(json['size'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductSizeToJson(ProductSize instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'sizeId': instance.sizeId,
      'additionalPrice': instance.additionalPrice,
      'size': instance.size,
    };

Topping _$ToppingFromJson(Map<String, dynamic> json) => Topping(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$ToppingToJson(Topping instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
    };

ProductTopping _$ProductToppingFromJson(Map<String, dynamic> json) =>
    ProductTopping(
      id: (json['id'] as num).toInt(),
      productId: (json['productId'] as num).toInt(),
      toppingId: (json['toppingId'] as num).toInt(),
      topping: json['topping'] == null
          ? null
          : Topping.fromJson(json['topping'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductToppingToJson(ProductTopping instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'toppingId': instance.toppingId,
      'topping': instance.topping,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      totalPoints: (json['totalPoints'] as num).toDouble(),
      role: json['role'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'totalPoints': instance.totalPoints,
      'role': instance.role,
    };

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
      id: (json['id'] as num).toInt(),
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      userId: (json['userId'] as num).toInt(),
      productId: (json['productId'] as num).toInt(),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      'id': instance.id,
      'rating': instance.rating,
      'comment': instance.comment,
      'createdAt': instance.createdAt.toIso8601String(),
      'userId': instance.userId,
      'productId': instance.productId,
      'user': instance.user,
    };

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      id: (json['id'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: json['status'] as String,
      paymentMethod: json['paymentMethod'] as String,
      isPaid: json['isPaid'] as bool,
      userId: (json['userId'] as num).toInt(),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      orderItems: (json['orderItems'] as List<dynamic>?)
          ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      tableId: (json['tableId'] as num?)?.toInt(),
      table: json['table'] == null
          ? null
          : Table.fromJson(json['table'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'status': instance.status,
      'paymentMethod': instance.paymentMethod,
      'isPaid': instance.isPaid,
      'userId': instance.userId,
      'user': instance.user,
      'orderItems': instance.orderItems,
      'totalAmount': instance.totalAmount,
      'tableId': instance.tableId,
      'table': instance.table,
    };

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
      id: (json['id'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      additionalPrice: (json['additionalPrice'] as num).toDouble(),
      notes: json['notes'] as String?,
      orderId: (json['orderId'] as num).toInt(),
      productId: (json['productId'] as num).toInt(),
      sizeId: (json['sizeId'] as num).toInt(),
      product: json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>),
      size: json['size'] == null
          ? null
          : Size.fromJson(json['size'] as Map<String, dynamic>),
      orderItemToppings: (json['orderItemToppings'] as List<dynamic>?)
          ?.map((e) => OrderItemTopping.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'price': instance.price,
      'additionalPrice': instance.additionalPrice,
      'notes': instance.notes,
      'orderId': instance.orderId,
      'productId': instance.productId,
      'sizeId': instance.sizeId,
      'product': instance.product,
      'size': instance.size,
      'orderItemToppings': instance.orderItemToppings,
    };

OrderItemTopping _$OrderItemToppingFromJson(Map<String, dynamic> json) =>
    OrderItemTopping(
      id: (json['id'] as num).toInt(),
      orderItemId: (json['orderItemId'] as num).toInt(),
      toppingId: (json['toppingId'] as num).toInt(),
      topping: json['topping'] == null
          ? null
          : Topping.fromJson(json['topping'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderItemToppingToJson(OrderItemTopping instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderItemId': instance.orderItemId,
      'toppingId': instance.toppingId,
      'topping': instance.topping,
    };

RegisterDto _$RegisterDtoFromJson(Map<String, dynamic> json) => RegisterDto(
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$RegisterDtoToJson(RegisterDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
    };

LoginDto _$LoginDtoFromJson(Map<String, dynamic> json) => LoginDto(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$LoginDtoToJson(LoginDto instance) => <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
    };

OrderCreateDto _$OrderCreateDtoFromJson(Map<String, dynamic> json) =>
    OrderCreateDto(
      userId: (json['userId'] as num).toInt(),
      paymentMethod: json['paymentMethod'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      note: json['note'] as String?,
      tableNumber: (json['tableNumber'] as num?)?.toInt(),
      usedLoyaltyDiscount: json['usedLoyaltyDiscount'] as bool?,
      usedFreeDrink: json['usedFreeDrink'] as bool?,
    );

Map<String, dynamic> _$OrderCreateDtoToJson(OrderCreateDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'paymentMethod': instance.paymentMethod,
      'items': instance.items,
      'totalAmount': instance.totalAmount,
      'note': instance.note,
      'tableNumber': instance.tableNumber,
      'usedLoyaltyDiscount': instance.usedLoyaltyDiscount,
      'usedFreeDrink': instance.usedFreeDrink,
    };

OrderItemDto _$OrderItemDtoFromJson(Map<String, dynamic> json) => OrderItemDto(
      productId: (json['productId'] as num).toInt(),
      sizeId: (json['sizeId'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      note: json['note'] as String?,
      toppingIds: (json['toppingIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$OrderItemDtoToJson(OrderItemDto instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'sizeId': instance.sizeId,
      'quantity': instance.quantity,
      'note': instance.note,
      'toppingIds': instance.toppingIds,
    };

CartItem _$CartItemFromJson(Map<String, dynamic> json) => CartItem(
      productId: (json['productId'] as num).toInt(),
      sizeId: (json['sizeId'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      notes: json['notes'] as String?,
      toppingIds: (json['toppingIds'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      product: json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>),
      size: json['size'] == null
          ? null
          : Size.fromJson(json['size'] as Map<String, dynamic>),
      toppings: (json['toppings'] as List<dynamic>?)
          ?.map((e) => Topping.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CartItemToJson(CartItem instance) => <String, dynamic>{
      'productId': instance.productId,
      'sizeId': instance.sizeId,
      'quantity': instance.quantity,
      'notes': instance.notes,
      'toppingIds': instance.toppingIds,
      'product': instance.product,
      'size': instance.size,
      'toppings': instance.toppings,
    };
