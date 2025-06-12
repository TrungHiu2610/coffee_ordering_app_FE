import 'package:flutter/material.dart';
import 'package:flutter_coffee_shop_app/models/api_models.dart';
import 'package:flutter_coffee_shop_app/providers/table_provider.dart';
import 'package:flutter_coffee_shop_app/screens/layout.dart';
import 'package:flutter_coffee_shop_app/screens/payment/payment_screen.dart';
import 'package:flutter_coffee_shop_app/services/product_service.dart';
import 'package:flutter_coffee_shop_app/services/auth_service.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';

class CartScreen extends StatefulWidget {

  const CartScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CartScreenState();
  }
}

class CartScreenState extends State<CartScreen> {
  late CartProvider cartProvider;
  late ProductService _productService;
  late AuthService _authService;
  late TableProvider tableProvider;

  late int? tableNumber;
  List<CartItem> cartItems = [];
  List<Product> products = [];
  User? currentUser;
  bool isLoading = true;
  late Future<void> _tablesFuture;

  @override
  void initState() {
    super.initState();
    _productService = ProductService();
    _authService = AuthService();
    _tablesFuture = Provider.of<TableProvider>(context, listen: false).loadTables();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Get current user
      currentUser = await _authService.getCurrentUser();

      // Get cart items from provider
      cartProvider = Provider.of<CartProvider>(context, listen: false);
      cartItems = cartProvider.cartItems;

      // Get table num
      tableProvider = Provider.of<TableProvider>(context, listen: false);
      tableNumber = tableProvider.selectedTable?.tableNumber;

      // Load products for displaying details
      products = await _productService.getProducts();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error loading cart data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
  String getToppingsText(CartItem cartItem) {
    // If we have populated toppings list, use it directly
    if (cartItem.toppings != null && cartItem.toppings!.isNotEmpty) {
      return cartItem.toppings!.map((t) => t.name).join(", ");
    }
    
    // Otherwise try to get topping names from product data
    if (cartItem.toppingIds == null || cartItem.toppingIds!.isEmpty) {
      return "Không có topping";
    }

    final toppingNames = cartItem.product?.productToppings
        ?.where((pt) => cartItem.toppingIds!.contains(pt.topping?.id))
        .map((pt) => pt.topping?.name)
        .where((name) => name != null)
        .join(", ");

    return toppingNames ?? "Không có topping";
  }

  void confirmRemove(int index) {
    final cartItem = cartItems[index];
    final product = products.firstWhere(
      (p) => p.id == cartItem.productId,
      orElse:
          () => Product(
            id: 0,
            name: "Unknown Product",
            price: 0,
            description: "",
            imageUrl: "",
            isAvailable: false,
            categoryId: 0,
          ),
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (_) => AlertDialog(
            content: Text(
              "Bạn chắc chắn muốn xóa sản phẩm \"${product.name}\" ?",
            ),
            title: Text("Xác nhận xóa sản phẩm"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Không"),
              ),
              TextButton(
                onPressed: () {
                  cartProvider.removeCartItem(index);
                  setState(() {
                    cartItems = cartProvider.cartItems;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Đã xóa sản phẩm ra khỏi giỏ hàng")),
                  );
                },
                child: Text("Có"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    cartProvider = Provider.of<CartProvider>(context);
    cartItems = cartProvider.cartItems;
    tableProvider = Provider.of<TableProvider>(context);
    tableNumber = tableProvider.selectedTable?.tableNumber;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Giỏ hàng",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(
              context,
              //MaterialPageRoute(builder: (_) => LayoutScreen())
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : cartItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text("Giỏ hàng trống")],
                    ),
                  )
                : Column(
                    children: [
                      if (tableNumber == null) ...[
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Chọn số bàn:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              const SizedBox(height: 8),
                              FutureBuilder(
                                future: _tablesFuture,
                                builder: (context, snapshot) {
                                  if (tableProvider.isLoading) {
                                    return Center(child: CircularProgressIndicator());
                                  }
                                  final availableTables = tableProvider.tables.where((t) => !t.isOccupied).toList();
                                  if (availableTables.isEmpty) {
                                    return Text('Không còn bàn trống', style: TextStyle(color: Colors.red));
                                  }
                                  return DropdownButton<int>(
                                    hint: Text('Chọn số bàn'),
                                    value: null,
                                    items: availableTables.map((table) {
                                      return DropdownMenuItem<int>(
                                        value: table.tableNumber,
                                        child: Text('Bàn ${table.tableNumber}'),
                                      );
                                    }).toList(),
                                    onChanged: (value) async {
                                      if (value != null) {
                                        await tableProvider.selectTable(value);
                                        setState(() {});
                                      }
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                      Expanded(
                        child: ListView.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (_, index) {
                            final item = cartItems[index];

                            // Find product details from loaded products
                            final product = products.firstWhere(
                              (p) => p.id == item.productId,
                              orElse:
                                  () => Product(
                                    id: 0,
                                    name: "Unknown Product",
                                    price: 0,
                                    description: "",
                                    imageUrl: "",
                                    isAvailable: false,
                                    categoryId: 0,
                                  ),
                            );

                            // Find size details (would need to be loaded from API)
                            String sizeName = "Regular";
                            if (product.productSizes != null) {
                              final size = product.productSizes!.firstWhere(
                                (s) => s.sizeId == item.sizeId,
                                orElse:
                                    () => ProductSize(
                                      id: 0,
                                      productId: 0,
                                      sizeId: 0,
                                      additionalPrice: 0,
                                    ),
                              );
                              sizeName = size.size?.name ?? "Regular";
                            }

                            return ListTile(
                              title: Text(
                                "${product.name} - ($sizeName)",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${item.notes?.isEmpty ?? true ? "No notes" : item.notes} - ${getToppingsText(item)}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "${cartProvider.calculateItemTotal(item).toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',')}đ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),

                              // CRUD giỏ hàng
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () {
                                      if (item.quantity > 1) {
                                        cartProvider.updateCartItem(
                                          index: index,
                                          quantity: item.quantity - 1,
                                          notes: item.notes,
                                        );
                                      } else {
                                        confirmRemove(index);
                                      }
                                    },
                                  ),
                                  Text("${item.quantity}"),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      cartProvider.updateCartItem(
                                        index: index,
                                        quantity: item.quantity + 1,
                                        notes: item.notes,
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      confirmRemove(index);
                                    },
                                  ),
                                ],
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              isThreeLine: true,
                            );
                          },
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(0, -2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Tổng tiền: ${cartProvider.calculateTotalPrice().toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',')}đ",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),

                            if (tableNumber != null) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.amber.shade300),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.table_bar, color: Colors.brown),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Đặt tại bàn: ${tableNumber}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.brown,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],

                            SizedBox(height: 16),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (currentUser == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Vui lòng đăng nhập để thanh toán")),
                                    );
                                    return;
                                  }
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PaymentScreen(
                                        userId: currentUser!.id,
                                        totalAmount: cartProvider.calculateTotalPrice(),
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.cyan,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                                child: Text(
                                  "Thanh toán",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
