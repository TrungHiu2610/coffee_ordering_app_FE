import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_coffee_shop_app/extensions/CartItem_TotalPrice.dart';
import 'package:realm/realm.dart';

import '../models/models.dart';

class CartProvider with ChangeNotifier {
  final Realm realm;
  final ObjectId userId;

  Cart? _currentCart;

  CartProvider({required this.realm, required this.userId}) {
    _loadCart();
  }

  Cart? get cart => _currentCart;

  void _loadCart() {
    _currentCart = realm
        .all<Cart>()
        .query('user.id == \$0 SORT(createTime DESC)', [userId])
        .firstOrNull;
    notifyListeners();
  }

  void refreshCart() => _loadCart();

  double get totalPrice {
    if (_currentCart == null) return 0;
    return _currentCart!.cartItems
        .map((item) => item.totalPrice) // dùng extension totalPrice
        .fold(0, (a, b) => a + b);
  }

  void addToCart({
    required Product product,
    required ProductSize productSize,
    required List<Topping> toppings,
    int quantity = 1,
    String description = '',
  }) {
    realm.write(() {
      if (_currentCart == null) {
        _currentCart = realm.add(Cart(
          ObjectId(), DateTime.now(),user: realm.find<User>(userId)!
        ));
      }

      // kiểm tra trùng sp, size và các topping
      final existingItem = _currentCart!.cartItems.firstWhereOrNull(
            (item) =>
        item.product?.id == product.id &&
            item.productSize?.id == productSize.id &&
            _areToppingListsEqual(item.toppings, toppings),
      );

      // nếu sp đã tồn tại => cập nhật số lượng
      if (existingItem != null) {
        existingItem.quantity += quantity;
      }
      // nếu sp chưa có trong giỏ hàng => thêm mới
      else {
        final newItem = CartItem(
          ObjectId(),
          quantity,
          description,
          cart: _currentCart,
          product: product,
          productSize: productSize,
          toppings: toppings,
        );
        realm.add(newItem); // thêm vào realm, không cần add vào cartItems
      }
    });

    notifyListeners();
  }

  // kiểm tra xem topping của sản phầm có trùng với nhau ko
  bool _areToppingListsEqual(List<Topping> a, List<Topping> b) {
    if (a.length != b.length) return false;
    final aIds = a.map((e) => e.id).toSet();
    final bIds = b.map((e) => e.id).toSet();
    return aIds.containsAll(bIds);
  }

  void increaseQuantity(CartItem item) {
    realm.write((){
      item.quantity++;
    });
    notifyListeners();
  }

  void decreaseQuantity(CartItem item) {
    if (item.quantity > 1) {
      realm.write((){
        item.quantity--;
      });
      notifyListeners();
    } else {
      removeItem(item);
    }
  }

  void removeItem(CartItem item) {
    realm.write((){
      realm.delete(item);
    });
    notifyListeners();
  }

  void clearCart() {
    if (_currentCart == null) return;

    realm.write(() {
      for (final item in _currentCart!.cartItems) {
        realm.delete(item);
      }
    });

    notifyListeners();
  }
}