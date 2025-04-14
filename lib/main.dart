import 'package:flutter/material.dart';
import 'package:flutter_coffee_shop_app/screens/demo_run.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Coffee Shop App',
      home: DemoRun(),
    );
  }
}