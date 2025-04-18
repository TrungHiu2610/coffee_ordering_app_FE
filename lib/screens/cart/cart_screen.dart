import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_coffee_shop_app/extensions/CartItem_TotalPrice.dart';
import 'package:flutter_coffee_shop_app/models/models.dart';
import 'package:flutter_coffee_shop_app/screens/layout.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';

import '../../providers/cart_provider.dart';

class CartScreen extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return CartScreenState();
  }
}

class CartScreenState extends State<CartScreen> {

  String printToppings(RealmList<Topping> toppings) {
    if (toppings.isEmpty) return "Toppings: None";

    String res = "Toppings: ";
    res += toppings.map((t) => t.name).join(", ");
    return res;
  }


  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cart = cartProvider.cart;

    if (cart == null) {
      return Center(child: Text("Chưa "));
    }

    final cartItems = cart.cartItems.toList();

    return Scaffold(
      appBar: AppBar(
          title: Text(
              "Giỏ hàng",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => LayoutScreen())
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
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
                      Text(
                        "${item.description.isEmpty ? "No description" : item.description} - ${printToppings(item.toppings)}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        "${item.totalPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',')}đ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  trailing: Row(
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
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          cartProvider.removeItem(item);
                        },
                      ),
                    ],
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  isThreeLine: true,
                );
              }
          )
          ),

          Text("Tổng tiền: ${cartProvider.totalPrice.toStringAsFixed(3)}đ"),

            ElevatedButton(
              onPressed: () {},
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
        ],
      ),
    );
  }
}
