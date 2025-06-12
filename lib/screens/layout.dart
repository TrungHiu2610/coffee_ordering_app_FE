import 'package:flutter/material.dart';
import 'package:flutter_coffee_shop_app/screens/cart/cart_screen.dart';
import 'package:flutter_coffee_shop_app/screens/home/home_screen.dart';
import 'package:flutter_coffee_shop_app/screens/order/order_list_screen.dart';
import 'package:flutter_coffee_shop_app/screens/profile/profile_screen.dart';
import 'package:flutter_coffee_shop_app/screens/scan/scan_qr_screen.dart';
import 'package:flutter_coffee_shop_app/screens/staff/staff_orders_screen.dart';
import 'package:flutter_coffee_shop_app/screens/wishlist/wishlist_screen.dart';
import 'package:flutter_coffee_shop_app/screens/widgets/appbar_home.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => LayoutScreenState();
}

class LayoutScreenState extends State<LayoutScreen> {
  int _selectedIndex = 0;
  int? _tableNumber;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is int && args != _tableNumber) {
      setState(() {
        _tableNumber = args;
      });
    }
  }

  List<_NavItem> get _navItems => [
    _NavItem(
      icon: Icons.home,
      label: 'Home',
      screen: HomeScreen(),
      appBar: const AppBarHome(),
    ),
    _NavItem(
      icon: Icons.favorite,
      label: 'Yêu thích',
      screen: WishListScreen(),
      appBar: AppBar(title: const Text('Yêu thích')),
    ),
    _NavItem(
      icon: Icons.checklist,
      label: 'Đơn hàng',
      screen: const OrderListScreen(),
      appBar: AppBar(title: const Text('Đơn hàng của tôi')),
    ),
    _NavItem(
      icon: Icons.person,
      label: 'Cá nhân',
      screen: ProfileScreen(),
      appBar: null, // ProfileScreen has its own AppBar
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isStaff = authProvider.currentUser?.role == 'Staff';
    
    return Scaffold(
      appBar: _navItems[_selectedIndex].appBar,
      body: SafeArea(
        child: _navItems[_selectedIndex].screen,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isStaff) {
            // For staff, navigate to staff orders screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const StaffOrdersScreen()),
            );
          } else {
            // For customers, navigate to QR scanner
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ScanQRScreen()),
            );
          }
        },
        backgroundColor: Colors.cyan,
        tooltip: isStaff ? 'Quản lý đơn hàng' : 'Quét mã QR bàn',
        child: Icon(
          isStaff ? Icons.receipt_long : Icons.qr_code_scanner,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF124258),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        items: _navItems.map((item) => BottomNavigationBarItem(
          icon: Icon(item.icon),
          label: item.label,
        )).toList(),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final Widget screen;
  final PreferredSizeWidget? appBar;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.screen,
    this.appBar,
  });
}
