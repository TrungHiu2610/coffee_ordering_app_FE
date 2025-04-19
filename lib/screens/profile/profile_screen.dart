import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_coffee_shop_app/providers/cart_provider.dart';
import 'package:flutter_coffee_shop_app/screens/login/login_screen.dart';
import 'package:flutter_coffee_shop_app/services/realm.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Thông tin cá nhân")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                RealmService().logout();
                Provider.of<CartProvider>(context, listen: false).clearCart();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LoginPage())
                );
              },
              child: Text("Đăng xuất"),
            ),
          ],
        ),
      ),
    );
  }

}