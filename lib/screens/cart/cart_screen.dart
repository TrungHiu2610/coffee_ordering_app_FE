import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_coffee_shop_app/extensions/CartItem_TotalPrice.dart';
import 'package:flutter_coffee_shop_app/models/models.dart';
import 'package:flutter_coffee_shop_app/screens/layout.dart';
import 'package:flutter_coffee_shop_app/screens/payment/payment_screen.dart';
import 'package:flutter_coffee_shop_app/services/realm.dart';
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

  late CartProvider cartProvider;
  late RealmService realmService;
  late User? user;
  late Cart? cart;
  late List<CartItem> cartItems;

  @override
  void initState() {
    super.initState();
    realmService = context.read<RealmService>();
    user = realmService.currentUser;
    cart = realmService.currentCart;
    loadCartItemsFromRealm();
  }

  void loadCartItemsFromRealm()
  {
    if(cart!.cartItems.isNotEmpty)
      {
        setState(() {
          cartItems = cart!.cartItems.toList();
        });
      }
    else
      {
        setState(() {
          cartItems=[];
        });
      }
  }

  String printToppings(RealmList<Topping> toppings) {
    if (toppings.isEmpty) return "Toppings: None";

    String res = "Toppings: ";
    res += toppings.map((t) => t.name).join(", ");
    return res;
  }

  void confirmRemove(CartItem item, CartProvider cartProvider)
  {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => AlertDialog(
          content: Text("Bạn chắc chắn muốn xóa sản phẩm \"${item.product?.name}\" ?"),
          title: Text("Xác nhận xóa sản phẩm"),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("Không")),
            TextButton(onPressed: (){
              cartProvider.removeItem(item);
              loadCartItemsFromRealm();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Đã xóa sản phẩm ra khỏi giỏ hàng")),
              );
            }, child: Text("Có")),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    cartProvider = Provider.of<CartProvider>(context);
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
      body: cartItems.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Giỏ hàng trống")
              ],
            ),
          )
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

                      // CRUD giỏ hàng
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              if(item.quantity > 1)
                              {
                                cartProvider.decreaseQuantity(item);
                              }
                              else{
                                confirmRemove(item, cartProvider);
                              }
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
                              confirmRemove(item, cartProvider);
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


          // thanh toán
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PaymentScreen())
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
        ],
      ),
    );
  }
}
