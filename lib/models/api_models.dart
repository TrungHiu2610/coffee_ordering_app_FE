import 'package:json_annotation/json_annotation.dart';

part 'api_models.g.dart';

@JsonSerializable()
class Table {
  final int id;
  final int tableNumber;
  final bool isOccupied;
  final DateTime? occupiedAt;
  final DateTime? lastUpdated;

  Table({
    required this.id,
    required this.tableNumber,
    required this.isOccupied,
    this.occupiedAt,
    this.lastUpdated,
  });

  factory Table.fromJson(Map<String, dynamic> json) {
    return Table(
      id: json['id'],
      tableNumber: json['tableNumber'],
      isOccupied: json['isOccupied'],
      occupiedAt: json['occupiedAt'] != null ? DateTime.parse(json['occupiedAt']) : null,
      lastUpdated: json['lastUpdated'] != null ? DateTime.parse(json['lastUpdated']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'tableNumber': tableNumber,
    'isOccupied': isOccupied,
    'occupiedAt': occupiedAt?.toIso8601String(),
    'lastUpdated': lastUpdated?.toIso8601String(),
  };
}

@JsonSerializable()
class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});


  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

@JsonSerializable()
class Product {
  final int id;
  final String name;
  final double price;
  final String description;
  @JsonKey(name: 'imageUrl')
  final String imageUrl;
  @JsonKey(name: 'isAvailable')
  final bool isAvailable;
  @JsonKey(name: 'categoryId')
  final int categoryId;  final Category? category;
  final List<Review>? reviews;
  @JsonKey(name: 'productSizes')
  final List<ProductSize>? productSizes;
  @JsonKey(name: 'productToppings')
  final List<ProductTopping>? productToppings;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.isAvailable,
    required this.categoryId,
    this.category,
    this.reviews,
    this.productSizes,
    this.productToppings,
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}

@JsonSerializable()
class Size {
  final int id;
  final String name;

  Size({required this.id, required this.name});

  factory Size.fromJson(Map<String, dynamic> json) => _$SizeFromJson(json);
  Map<String, dynamic> toJson() => _$SizeToJson(this);
}

@JsonSerializable()
class ProductSize {
  final int id;
  @JsonKey(name: 'productId')
  final int productId;
  @JsonKey(name: 'sizeId')
  final int sizeId;
  @JsonKey(name: 'additionalPrice')
  final double additionalPrice;
  final Size? size;

  ProductSize({
    required this.id,
    required this.productId,
    required this.sizeId,
    required this.additionalPrice,
    this.size,
  });

  factory ProductSize.fromJson(Map<String, dynamic> json) => _$ProductSizeFromJson(json);
  Map<String, dynamic> toJson() => _$ProductSizeToJson(this);
}

@JsonSerializable()
class Topping {
  final int id;
  final String name;
  final double price;

  Topping({required this.id, required this.name, required this.price});

  factory Topping.fromJson(Map<String, dynamic> json) => _$ToppingFromJson(json);
  Map<String, dynamic> toJson() => _$ToppingToJson(this);
}

@JsonSerializable()
class ProductTopping {
  final int id;
  @JsonKey(name: 'productId')
  final int productId;
  @JsonKey(name: 'toppingId')
  final int toppingId;
  final Topping? topping;

  ProductTopping({
    required this.id,
    required this.productId,
    required this.toppingId,
    this.topping,
  });

  factory ProductTopping.fromJson(Map<String, dynamic> json) => _$ProductToppingFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToppingToJson(this);
}

@JsonSerializable()
class User {
  final int id;
  final String name;
  final String email;
  late final double totalPoints;
  final String role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.totalPoints,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Review {
  final int id;
  final int rating;
  final String comment;
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  @JsonKey(name: 'userId')
  final int userId;
  @JsonKey(name: 'productId')
  final int productId;
  final User? user;

  Review({
    required this.id,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.userId,
    required this.productId,
    this.user,
  });

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}

@JsonSerializable()
class Order {
  final int id;
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  late final String status;
  @JsonKey(name: 'paymentMethod')
  final String paymentMethod;
  @JsonKey(name: 'isPaid')
  late final bool isPaid;
  @JsonKey(name: 'userId')
  final int userId;
  final User? user;
  @JsonKey(name: 'orderItems')
  final List<OrderItem>? orderItems;
  @JsonKey(name: 'totalAmount')
  final double? totalAmount;
  @JsonKey(name: 'tableId')
  final int? tableId;
  final Table? table;

  // Factory constructor for creating a minimal Order for SignalR
  factory Order.minimal({
    required int id,
    required DateTime createdAt,
    required String status,
    required String paymentMethod,
    required bool isPaid,
    required int userId,
    double? totalAmount,
  }) {
    return Order(
      id: id,
      createdAt: createdAt,
      status: status,
      paymentMethod: paymentMethod,
      isPaid: isPaid,
      userId: userId,
      totalAmount: totalAmount,
    );
  }
  Order({
    required this.id,
    required this.createdAt,
    required this.status,
    required this.paymentMethod,
    required this.isPaid,
    required this.userId,
    this.user,
    this.orderItems,
    this.totalAmount,
    this.tableId,
    this.table
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    // Handle potential type conversion issues
    int id = json['id'] is int ? json['id'] : int.parse(json['id'].toString());
    DateTime createdAt = json['createdAt'] is String ? 
        DateTime.parse(json['createdAt']) : 
        (json['createdAt'] as DateTime);
    String status = json['status'] as String;
    String paymentMethod = json['paymentMethod'] as String;
    bool isPaid = json['isPaid'] is bool ? json['isPaid'] : 
        (json['isPaid'].toString().toLowerCase() == 'true');
    int userId = json['userId'] is int ? json['userId'] : 
        int.parse(json['userId'].toString());
    
    // Handle totalAmount which could be int, double, or string
    double? totalAmount;
    if (json['totalAmount'] != null) {
      if (json['totalAmount'] is int) {
        totalAmount = (json['totalAmount'] as int).toDouble();
      } else if (json['totalAmount'] is double) {
        totalAmount = json['totalAmount'] as double;
      } else {
        try {
          totalAmount = double.parse(json['totalAmount'].toString());
        } catch (e) {
          print('Error parsing totalAmount: $e');
          totalAmount = 0.0;
        }
      }
    }
    
    // Handle tableId which could be int or null
    int? tableId;
    if (json['tableId'] != null) {
      if (json['tableId'] is int) {
        tableId = json['tableId'] as int;
      } else {
        try {
          tableId = int.parse(json['tableId'].toString());
        } catch (e) {
          print('Error parsing tableId: $e');
        }
      }
    }
    
    return Order(
      id: id,
      createdAt: createdAt,
      status: status,
      paymentMethod: paymentMethod,
      isPaid: isPaid,
      userId: userId,
      user: json['user'] == null ? null : User.fromJson(json['user'] as Map<String, dynamic>),
      orderItems: (json['orderItems'] as List<dynamic>?)?.map(
        (e) => OrderItem.fromJson(e as Map<String, dynamic>)
      ).toList(),
      totalAmount: totalAmount,
      tableId: tableId,
      table: json['table'] == null ? null : Table.fromJson(json['table'] as Map<String, dynamic>),
    );
  }
  
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}

@JsonSerializable()
class OrderItem {
  final int id;
  final int quantity;
  final double price;
  @JsonKey(name: 'additionalPrice')
  final double additionalPrice;
  final String? notes;
  @JsonKey(name: 'orderId')
  final int orderId;
  @JsonKey(name: 'productId')
  final int productId;
  @JsonKey(name: 'sizeId')
  final int sizeId;
  final Product? product;
  final Size? size;
  @JsonKey(name: 'orderItemToppings')
  final List<OrderItemTopping>? orderItemToppings;

  OrderItem({
    required this.id,
    required this.quantity,
    required this.price,
    required this.additionalPrice,
    this.notes,
    required this.orderId,
    required this.productId,
    required this.sizeId,
    this.product,
    this.size,
    this.orderItemToppings,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}

@JsonSerializable()
class OrderItemTopping {
  final int id;
  @JsonKey(name: 'orderItemId')
  final int orderItemId;
  @JsonKey(name: 'toppingId')
  final int toppingId;
  final Topping? topping;

  OrderItemTopping({
    required this.id,
    required this.orderItemId,
    required this.toppingId,
    this.topping,
  });

  factory OrderItemTopping.fromJson(Map<String, dynamic> json) => _$OrderItemToppingFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemToppingToJson(this);
}

@JsonSerializable()
class RegisterDto {
  final String name;
  final String email;
  final String password;

  RegisterDto({required this.name, required this.email, required this.password});

  factory RegisterDto.fromJson(Map<String, dynamic> json) => _$RegisterDtoFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterDtoToJson(this);
}

@JsonSerializable()
class LoginDto {
  final String email;
  final String password;

  LoginDto({required this.email, required this.password});

  factory LoginDto.fromJson(Map<String, dynamic> json) => _$LoginDtoFromJson(json);
  Map<String, dynamic> toJson() => _$LoginDtoToJson(this);
}

@JsonSerializable()
class OrderCreateDto {
  @JsonKey(name: 'userId')
  final int userId;
  @JsonKey(name: 'paymentMethod')
  final String paymentMethod;
  @JsonKey(name: 'items')
  final List<OrderItemDto> items;
  @JsonKey(name: 'totalAmount')
  final double totalAmount;
  @JsonKey(name: 'note')
  final String? note;
  @JsonKey(name: 'tableNumber')
  final int? tableNumber;
  @JsonKey(name: 'usedLoyaltyDiscount')
  final bool? usedLoyaltyDiscount;
  @JsonKey(name: 'usedFreeDrink')
  final bool? usedFreeDrink;

  OrderCreateDto({
    required this.userId,
    required this.paymentMethod,
    required this.items,
    required this.totalAmount,
    this.note,
    this.tableNumber,
    this.usedLoyaltyDiscount,
    this.usedFreeDrink,
  });

  factory OrderCreateDto.fromJson(Map<String, dynamic> json) => _$OrderCreateDtoFromJson(json);
  Map<String, dynamic> toJson() => _$OrderCreateDtoToJson(this);
}

@JsonSerializable()
class OrderItemDto {
  @JsonKey(name: 'productId')
  final int productId;
  @JsonKey(name: 'sizeId')
  final int sizeId;
  final int quantity;
  @JsonKey(name: 'note')
  final String? note;
  @JsonKey(name: 'toppingIds')
  final List<int>? toppingIds;

  OrderItemDto({
    required this.productId,
    required this.sizeId,
    required this.quantity,
    this.note,
    this.toppingIds,
  });

  factory OrderItemDto.fromJson(Map<String, dynamic> json) => _$OrderItemDtoFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemDtoToJson(this);
}

@JsonSerializable()
class CartItem {
  @JsonKey(name: 'productId')
  final int productId;
  @JsonKey(name: 'sizeId')
  final int sizeId;
  @JsonKey(name: 'quantity')
  int quantity;
  @JsonKey(name: 'notes')
  String? notes;
  @JsonKey(name: 'toppingIds')
  final List<int> toppingIds;
  @JsonKey(name: 'product')
  Product? product;
  @JsonKey(name: 'size') 
  Size? size;
  @JsonKey(name: 'toppings')
  List<Topping>? toppings;

  CartItem({
    required this.productId,
    required this.sizeId,
    required this.quantity,
    this.notes,
    required this.toppingIds,
    this.product,
    this.size,
    this.toppings,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemToJson(this);
}
