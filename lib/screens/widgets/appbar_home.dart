import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppBarHome extends StatelessWidget implements PreferredSizeWidget
{
  @override
  Widget build(BuildContext context) {
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
        )
      ],
      backgroundColor: Color(0xFF124258),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}