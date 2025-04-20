import 'package:collection/collection.dart';
import 'package:realm/realm.dart';

import '../models/models.dart';

class RealmService
{
  static final RealmService _instance = RealmService._internal();
  factory RealmService() => _instance;

  RealmService._internal(){
    final config = Configuration.local([
      Cart.schema,
      CartItem.schema,
      Category.schema,
      Invoice.schema,
      InvoiceItem.schema,
      Product.schema,
      Review.schema,
      User.schema,
      Size.schema,
      Topping.schema,
      ProductSize.schema,
      Order.schema,
      OrderItem.schema
    ], schemaVersion: 7);

    this._realm = Realm(config);
  }

  late Realm _realm;

  Realm get realm => _realm;

  User? _currentUser;

  User? get currentUser => _currentUser;

  void setCurrentUser(User user) {
    _currentUser = user;
  }

  void logout() {
    _currentUser = null;
    _currentCart = null;
  }

  Cart? _currentCart;
  Cart? get currentCart => _currentCart;
  void setCurrentCart() {
    if (_currentUser == null) return;

    final userCart = realm.all<Cart>().query('user.id == \$0', [_currentUser!.id]).firstOrNull;

    if (userCart != null) {
      _currentCart = userCart;
    } else {
      // Nếu user chưa có cart thì tạo mới
      final newCart = Cart(ObjectId(),DateTime.now(), user: _currentUser);
      realm.write(() {
        realm.add(newCart);
      });
      _currentCart = newCart;
    }
  }

  void clearCart() {
    if (_currentCart == null) return;
    realm.write(() {
      for (final item in _currentCart!.cartItems) {
        realm.delete(item);
      }
    });
  }

  Order? _currentOrder;
  Order? get currentOrder => _currentOrder;
  void setCurrentOrder() {
    if (_currentUser == null) return;

    final orders = realm.query<Order>(
        'customer.id == \$0 AND status == \$1',
        [_currentUser!.id, "Chờ quán xác nhận"]
    );
    if (orders.isNotEmpty) {
      // Lấy order mới nhất bằng tay
      Order? latestOrder = orders.reduce((a, b) => a.createdAt.isAfter(b.createdAt) ? a : b);
      _currentOrder = latestOrder;
    } else {
      _currentOrder = null;
    }
  }
}