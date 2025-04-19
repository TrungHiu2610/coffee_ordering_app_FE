import 'package:flutter/material.dart';
import 'package:realm/realm.dart';

import '../../models/models.dart';
import '../../services/realm.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  bool _obscurePass = true;
  bool _obscureConfirmPass = true;

  void _register() {
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;
    final confirmPass = _confirmPassCtrl.text;

    if (pass != confirmPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mật khẩu không khớp')),
      );
      _passCtrl.clear();
      _confirmPassCtrl.clear();
      return;
    }

    final realm = RealmService().realm;
    final existingUser = realm.query<User>('email == \$0', [email]).isNotEmpty;

    if (existingUser) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email đã được đăng ký')),
      );
      return;
    }

    final user = User(ObjectId(), name, email, pass, 0, "User");
    realm.write(() => realm.add(user));
    RealmService().setCurrentUser(user);

    Navigator.pop(context); // Quay lại login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Đăng ký")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(labelText: 'Họ tên'),
            ),
            TextField(
              controller: _emailCtrl,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passCtrl,
              obscureText: _obscurePass,
              decoration: InputDecoration(
                labelText: 'Mật khẩu',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePass ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePass = !_obscurePass;
                    });
                  },
                ),
              ),
            ),
            TextField(
              controller: _confirmPassCtrl,
              obscureText: _obscureConfirmPass,
              decoration: InputDecoration(
                labelText: 'Nhập lại mật khẩu',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPass ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPass = !_obscureConfirmPass;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: Text("Đăng ký"),
            ),
          ],
        ),
      ),
    );
  }
}
