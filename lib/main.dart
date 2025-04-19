import 'package:flutter/material.dart';
import 'package:flutter_coffee_shop_app/screens/home/home_screen.dart';
import 'package:flutter_coffee_shop_app/screens/layout.dart';
import 'package:flutter_coffee_shop_app/screens/login/login_screen.dart';
import 'package:flutter_coffee_shop_app/screens/register/register_screen.dart';
import 'package:provider/provider.dart';

import 'package:flutter_coffee_shop_app/services/realm.dart';
import 'package:flutter_coffee_shop_app/providers/cart_provider.dart';
import 'package:realm/realm.dart';

import 'data/seed_data.dart';
import 'models/models.dart'; // tạo file này theo hướng dẫn ở trên

void regenerateDB()
{
  final realmService = RealmService();
  final realm = realmService.realm;
  final fakeUser = realm.write(() => realm.add(User(ObjectId(), "Trung Híu","hieult2610@gmail.com","h122604h",0,"user")));
  print("Đã tạo user");

  seedInitialData(realmService);
}

void main() {
  //regenerateDB();
  final realmService = RealmService();

  runApp(
    MultiProvider(
      providers: [
        Provider<RealmService>.value(value: realmService), // để inject ở nhiều nơi
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
        routes: {
          '/register': (_) => RegisterPage()
        },
      ),
    ),
  );
}
