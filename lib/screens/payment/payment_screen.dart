import 'package:flutter/material.dart';
import 'package:flutter_coffee_shop_app/extensions/CartItem_TotalPrice.dart';
import 'package:flutter_coffee_shop_app/models/models.dart';
import 'package:flutter_coffee_shop_app/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  String printToppings(RealmList<Topping> toppings) {
    if (toppings.isEmpty) return "Không có topping";
    return toppings.map((t) => t.name).join(", ");
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cart?.cartItems.toList() ?? [];

    final total = cartProvider.totalPrice;
    final discount = 0.0;
    final finalTotal = total - discount;

    return Scaffold(
      appBar: AppBar(
        title: Text("Xác nhận đơn hàng"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: cartItems.isEmpty
          ? Center(child: Text("Không có sản phẩm trong giỏ hàng"))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (_, index) {
                final item = cartItems[index];
                final product = item.product;

                return ListTile(
                  title: Text(
                    product?.name ?? "Unknown",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Size: ${item.productSize?.size?.name}"),
                      Text("Topping: ${printToppings(item.toppings)}"),
                      Text(
                        "${item.description.isEmpty ? "No description" : item.description}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                          "${item.totalPrice.toStringAsFixed(0)}đ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  trailing: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              cartProvider.decreaseQuantity(item);
                            },
                          ),
                          Text("${item.quantity}"),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              cartProvider.increaseQuantity(item);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              // TODO: Điều hướng đến trang sửa topping/size
                            },
                          ),
                        ],
                      ),

                    ],
                  ),
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Tạm tính: ${total.toStringAsFixed(0)}đ"),
                Text("Giảm giá: ${discount.toStringAsFixed(0)}đ"),
                Text(
                  "Tổng cộng: ${finalTotal.toStringAsFixed(0)}đ",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Xử lý xác nhận đơn hàng
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Đã chọn thanh toán tại quầy")),
                    );
                  },
                  child: Text("Xác nhận (Thanh toán tại quầy)"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Điều hướng đến trang thanh toán online
                  },
                  child: Text("Thanh toán online"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
