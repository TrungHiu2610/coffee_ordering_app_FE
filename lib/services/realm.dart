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

  User getCurrentUser() {
    final user = realm.all<User>().first; // hoặc logic login cụ thể của bạn
    return user;
  }

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

}