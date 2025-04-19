import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_coffee_shop_app/screens/cart/cart_screen.dart';
import 'package:flutter_coffee_shop_app/screens/home/home_screen.dart';
import 'package:flutter_coffee_shop_app/screens/profile/profile_screen.dart';
import 'package:flutter_coffee_shop_app/screens/widgets/appbar_home.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => LayoutScreenState();
}

class LayoutScreenState extends State<LayoutScreen> {

  int selectedBottomBarIndex = 0;
  Widget bodyContent = HomeScreen();
  PreferredSizeWidget? appBarContent = AppBarHome();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarContent,
      body: bodyContent,
      bottomNavigationBar:BottomNavigationBar(
        backgroundColor: Color(0xFF124258),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        onTap: (index){
          setState(()
          {
            selectedBottomBarIndex = index;

            switch(selectedBottomBarIndex){
              case 0:
                appBarContent = AppBarHome();
                bodyContent = HomeScreen();
                break;
              case 1:
                final cartProvider = Provider.of<CartProvider>(context, listen: false);
                cartProvider.clearCart();
                bodyContent = HomeScreen();
                break;
              case 3:
                bodyContent = ProfileScreen();
                break;
            }
          });
        },
        currentIndex: selectedBottomBarIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Clear cart'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.checklist),
              label: 'My order'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.perm_identity),
              label: 'Profile'
          ),
        ],
      )
    );
  }
}
