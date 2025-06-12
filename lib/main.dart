import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_coffee_shop_app/providers/auth_provider.dart';
import 'package:flutter_coffee_shop_app/providers/loyalty_provider.dart';
import 'package:flutter_coffee_shop_app/providers/order_status_provider.dart';
import 'package:flutter_coffee_shop_app/providers/table_provider.dart';
import 'package:flutter_coffee_shop_app/screens/layout.dart';
import 'package:flutter_coffee_shop_app/screens/auth/login_screen.dart';
import 'package:flutter_coffee_shop_app/screens/auth/register_screen.dart';
import 'package:flutter_coffee_shop_app/screens/splash_screen.dart';
import 'package:flutter_coffee_shop_app/services/dio_client.dart';
import 'package:flutter_coffee_shop_app/services/http_overrides.dart';
import 'package:flutter_coffee_shop_app/services/signalr_service.dart';
import 'package:provider/provider.dart';

import 'package:flutter_coffee_shop_app/providers/cart_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set up global HTTP overrides for SSL certificate validation
  HttpOverrides.global = MyHttpOverrides();
  
  // Initialize SignalR
  final baseUrl = DioClient().baseUrl;
  await SignalRService().initialize(baseUrl);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderStatusProvider(),
        ),        ChangeNotifierProvider(
          create: (_) => LoyaltyProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TableProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Coffee Shop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.brown,
          scaffoldBackgroundColor: Colors.grey[100],
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.brown,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const LayoutScreen(),
        },
      ),
    );
  }
}
