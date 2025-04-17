import 'package:flutter/material.dart';
import 'package:flutter_coffee_shop_app/screens/demo_run.dart';
import 'package:flutter_coffee_shop_app/screens/home/home_screen.dart';
import 'package:flutter_coffee_shop_app/screens/layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Coffee Shop App',
      home: LayoutScreen(),
    );
  }
}