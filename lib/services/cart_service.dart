import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/api_models.dart';

class CartService {
  static const String _cartKey = 'shopping_cart';
  
  Future<List<CartItem>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getString(_cartKey);
    
    if (cartJson == null) {
      return [];
    }
    
    try {
      final List<dynamic> decodedList = jsonDecode(cartJson);
      return decodedList.map((item) => CartItem.fromJson(item)).toList();
    } catch (e) {
      print('Error parsing cart: $e');
      return [];
    }
  }
  
  Future<void> addToCart({
    required int productId,
    required int sizeId,
    required int quantity,
    String? notes,
    required List<int> toppingIds,
  }) async {
    final cartItems = await getCartItems();
    
    // Check if the item already exists with the same product, size, and toppings
    final existingItemIndex = cartItems.indexWhere(
      (item) => 
        item.productId == productId && 
        item.sizeId == sizeId && 
        _areToppingListsEqual(item.toppingIds, toppingIds)
    );
    
    if (existingItemIndex != -1) {
      // Update quantity
      cartItems[existingItemIndex] = CartItem(
        productId: productId,
        sizeId: sizeId,
        quantity: cartItems[existingItemIndex].quantity + quantity,
        notes: notes ?? cartItems[existingItemIndex].notes,
        toppingIds: toppingIds,
      );
    } else {
      // Add new item
      cartItems.add(CartItem(
        productId: productId,
        sizeId: sizeId,
        quantity: quantity,
        notes: notes,
        toppingIds: toppingIds,
      ));
    }
    
    await _saveCart(cartItems);
  }
  
  Future<void> updateCartItem({
    required int index,
    required int quantity,
    String? notes,
  }) async {
    final cartItems = await getCartItems();
    
    if (index < 0 || index >= cartItems.length) {
      return;
    }
    
    cartItems[index] = CartItem(
      productId: cartItems[index].productId,
      sizeId: cartItems[index].sizeId,
      quantity: quantity,
      notes: notes ?? cartItems[index].notes,
      toppingIds: cartItems[index].toppingIds,
    );
    
    await _saveCart(cartItems);
  }
  
  Future<void> removeCartItem(int index) async {
    final cartItems = await getCartItems();
    
    if (index < 0 || index >= cartItems.length) {
      return;
    }
    
    cartItems.removeAt(index);
    await _saveCart(cartItems);
  }
  
  Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }
  
  Future<void> _saveCart(List<CartItem> cartItems) async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = jsonEncode(cartItems.map((item) => item.toJson()).toList());
    await prefs.setString(_cartKey, cartJson);
  }
  
  bool _areToppingListsEqual(List<int> list1, List<int> list2) {
    if (list1.length != list2.length) {
      return false;
    }
    
    final sortedList1 = List<int>.from(list1)..sort();
    final sortedList2 = List<int>.from(list2)..sort();
    
    for (int i = 0; i < sortedList1.length; i++) {
      if (sortedList1[i] != sortedList2[i]) {
        return false;
      }
    }
    
    return true;
  }

  removeFromCart(int index) {}
}
