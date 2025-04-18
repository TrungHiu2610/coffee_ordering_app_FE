import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_coffee_shop_app/screens/cart/cart_screen.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';

class AppBarHome extends StatelessWidget implements PreferredSizeWidget
{
  @override
  Widget build(BuildContext context) {
    final cartItemCount = context.watch<CartProvider>().cart?.cartItems.length;

    return AppBar(
      centerTitle: true,
      title: Image.asset(
        'assets/images/logo.png',
        height: 50,
      ),
      leading: Icon(Icons.menu),
      actions: [
        IconButton(
            onPressed: (){}, icon: Icon(Icons.notifications)
        ),
        Stack(
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CartScreen())
                );
              },
              icon: Icon(Icons.shopping_cart),
            ),
            if (cartItemCount! > 0)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Text(
                    '$cartItemCount',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        )
      ],
      backgroundColor: Color(0xFF124258),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}