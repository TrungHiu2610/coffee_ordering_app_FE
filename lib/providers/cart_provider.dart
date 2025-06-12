import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/api_models.dart';
import '../services/auth_service.dart';
import '../services/cart_service.dart';
import '../services/product_service.dart';

class CartProvider with ChangeNotifier {
  final CartService _cartService = CartService();
  final ProductService _productService = ProductService();
  final AuthService _authService = AuthService();
  List<CartItem> _items = [];
  List<Product> _products = [];
  List<ProductSize> _productSizes = [];
  List<Topping> _toppings = [];
  bool _isLoading = false;
  String? _error;
  int? _tableNumber;

  List<CartItem> get cartItems => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get itemCount => _items.length;
  int? get tableNumber => _tableNumber;

  void setTableNumber(int? tableNumber) {
    _tableNumber = tableNumber;
    notifyListeners();
  }

  CartProvider() {
    _initializeCart();
  }

  Future<void> _initializeCart() async {
    await _loadLocalCart();
    await _syncWithServer();
  }

  // load cart session 'shopping_cart'
  Future<void> _loadLocalCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString('shopping_cart');
      if (cartJson != null) {
        final cartData = json.decode(cartJson) as List;
        _items = cartData.map((item) => CartItem.fromJson(item)).toList();

        for (var item in _items) {
          await _updateCartItemDetails(item);
        }
        
        notifyListeners();
      }
    } catch (e) {
      print('Error loading local cart: $e');
    }
  }

  // save cart session 'shopping_cart'
  Future<void> _saveLocalCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = json.encode(_items.map((item) => item.toJson()).toList());
      await prefs.setString('shopping_cart', cartJson);
    } catch (e) {
      print('Error saving local cart: $e');
    }
  }

  // dong bo cart session voi cart db
  Future<void> _syncWithServer() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await _authService.getCurrentUser();
      if (user != null) {

        final serverItems = await _cartService.getCartItems();

        _products = await _productService.getProducts();

        for (var item in _items) {
          await _updateCartItemDetails(item);
        }

        await _mergeWithServerCart(serverItems);
      }
    } catch (e) {
      _error = e.toString();
      print('Error syncing cart: $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> _updateCartItemDetails(CartItem item) async {

    try {

      final fetchedProduct = await _productService.getProduct(item.productId);
      if (fetchedProduct != null) {
        item.product = fetchedProduct;
        

        if (item.product?.productSizes != null) {
          final productSize = item.product!.productSizes!
            .where((ps) => ps.sizeId == item.sizeId)
            .firstOrNull;
          
          if (productSize != null) {
            item.size = productSize.size;
          }
        }

        if (item.toppingIds.isNotEmpty && item.product?.productToppings != null) {
          item.toppings = [];
          for (final toppingId in item.toppingIds) {
            final productTopping = item.product!.productToppings!
              .where((pt) => pt.topping?.id == toppingId)
              .firstOrNull;
            
            if (productTopping?.topping != null) {
              item.toppings!.add(productTopping!.topping!);
            }
          }
        }
      }
    } catch (e) {
      print('Error updating cart item details for product id: ${item.productId}, error: $e');
    }
  }

  Future<void> _mergeWithServerCart(List<CartItem> serverItems) async {

    for (var serverItem in serverItems) {
      final localIndex = _items.indexWhere((item) => 
        item.productId == serverItem.productId &&
        item.sizeId == serverItem.sizeId &&
        item.toppingIds.toString() == serverItem.toppingIds.toString()
      );

      if (localIndex >= 0) {

        if (_items[localIndex].quantity != serverItem.quantity) {
          await updateCartItem(
            index: localIndex,
            quantity: _items[localIndex].quantity + serverItem.quantity,
            notes: serverItem.notes,
          );
        }
      } else {

        _items.add(serverItem);
      }
    }

    await _saveLocalCart();

    for (var item in _items) {
      await _cartService.addToCart(
        productId: item.productId,
        sizeId: item.sizeId,
        quantity: item.quantity,
        notes: item.notes,
        toppingIds: item.toppingIds,
      );
    }
  }
  Future<void> addToCart({
    required int productId,
    required int sizeId,
    required int quantity,
    String? notes,
    required List<int> toppingIds,
  }) async {
    try {
      _error = null;

      final existingIndex = _items.indexWhere((item) =>
        item.productId == productId &&
        item.sizeId == sizeId &&
        item.toppingIds.toString() == toppingIds.toString()
      );

      if (existingIndex >= 0) {
        _items[existingIndex].quantity += quantity;
        if (notes != null) {
          _items[existingIndex].notes = notes;
        }
      } else {
        final newItem = CartItem(
          productId: productId,
          sizeId: sizeId,
          quantity: quantity,
          notes: notes ?? '',
          toppingIds: toppingIds,
        );
        _items.add(newItem);

        await _updateCartItemDetails(newItem);
      }

      notifyListeners();
      await _saveLocalCart();

      try {
        await _cartService.addToCart(
          productId: productId,
          sizeId: sizeId,
          quantity: quantity,
          notes: notes,
          toppingIds: toppingIds,
        );
      } catch (e) {
        print('Error syncing cart with server: $e');
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateCartItem({
    required int index,
    required int quantity,
    String? notes,
  }) async {
    try {
      _error = null;

      if (index >= 0 && index < _items.length) {
        if (quantity <= 0) {
          _items.removeAt(index);
        } else {
          _items[index].quantity = quantity;
          if (notes != null) {
            _items[index].notes = notes;
          }
        }

        notifyListeners();
        await _saveLocalCart();

        try {
          await _cartService.updateCartItem(
            index: index,
            quantity: quantity,
            notes: notes,
          );
        } catch (e) {
          print('Error syncing cart update with server: $e');
        }
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> removeFromCart(int index) async {
    try {
      _error = null;

      if (index >= 0 && index < _items.length) {
        _items.removeAt(index);
        notifyListeners();
        await _saveLocalCart();

        try {
          await _cartService.removeFromCart(index);
        } catch (e) {
          print('Error syncing cart removal with server: $e');
        }
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    try {
      _error = null;
      _items.clear();
      notifyListeners();
      await _saveLocalCart();

      try {
        await _cartService.clearCart();
      } catch (e) {
        print('Error syncing cart clear with server: $e');
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void retrySync() {
    _syncWithServer();
  }
  double calculateItemTotal(CartItem item) {
    double total = item.product?.price ?? 0;
    
    // Add size price if applicable
    if (item.product?.productSizes != null && item.sizeId != null) {
      final size = item.product!.productSizes!
        .where((ps) => ps.sizeId == item.sizeId)
        .firstOrNull;
      if (size != null) {
        total += size.additionalPrice;
      }
    }

    // Add topping prices using the toppings list that was populated
    if (item.toppings != null && item.toppings!.isNotEmpty) {
      for (final topping in item.toppings!) {
        total += topping.price;
      }
    }
    // If toppings list is not populated yet, use the product's topping list
    else if (item.product?.productToppings != null && item.toppingIds != null && item.toppingIds!.isNotEmpty) {
      for (final toppingId in item.toppingIds!) {
        final topping = item.product!.productToppings!
          .where((pt) => pt.topping?.id == toppingId)
          .map((pt) => pt.topping)
          .firstOrNull;
        if (topping != null) {
          total += topping.price;
        }
      }
    }

    return total * item.quantity;
  }

  double calculateTotalPrice() {
    return _items.fold(0, (total, item) => total + calculateItemTotal(item));
  }

  Future<void> removeCartItem(int index) async {
    if (index < 0 || index >= _items.length) return;

    try {
      _error = null;

      // Remove from local storage
      _items.removeAt(index);
      notifyListeners();
      await _saveLocalCart();

      // Try to sync with server
      try {
        await _cartService.removeFromCart(index);
      } catch (e) {
        print('Error syncing cart removal with server: $e');
        // Don't throw here, we'll try to sync later
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}