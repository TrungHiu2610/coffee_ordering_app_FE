import 'package:flutter/material.dart';
import 'package:flutter_coffee_shop_app/screens/layout.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';
import '../../providers/cart_provider.dart';
import '../../services/realm.dart';

class LoginPage extends StatelessWidget {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  LoginPage({super.key});

  void _login(BuildContext context) {
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;

    final realm = RealmService().realm;
    final user = realm.query<User>('email == \$0 AND password == \$1', [email, pass]).firstOrNull;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sai email hoặc mật khẩu')),
      );
    } else {
      RealmService().setCurrentUser(user);
      RealmService().setCurrentCart();
      Provider.of<CartProvider>(context, listen: false).loadCartForUser();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LayoutScreen()));
    }
  }

  void _goToRegister(BuildContext context) {
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Đăng nhập")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _emailCtrl, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: _passCtrl, obscureText: true, decoration: InputDecoration(labelText: 'Mật khẩu')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _login(context),
              child: Text("Đăng nhập"),
            ),
            TextButton(
              onPressed: () => _goToRegister(context),
              child: Text("Chưa có tài khoản? Đăng ký"),
            ),
          ],
        ),
      ),
    );
  }
}
