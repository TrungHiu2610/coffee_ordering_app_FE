import 'package:flutter/material.dart';
import 'package:flutter_coffee_shop_app/models/api_models.dart';
import 'package:flutter_coffee_shop_app/screens/order/order_screen.dart';
import 'package:flutter_coffee_shop_app/screens/order/real_time_order_screen.dart';
import 'package:flutter_coffee_shop_app/screens/order/widgets/order_item_card.dart';
import 'package:flutter_coffee_shop_app/services/auth_service.dart';
import 'package:flutter_coffee_shop_app/services/order_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({Key? key}) : super(key: key);

  @override
  State<OrderListScreen> createState() => OrderListScreenState();
}

class OrderListScreenState extends State<OrderListScreen> {
  final OrderService _orderService = OrderService();
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  List<Order> _orderList = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Get current user
      final currentUser = await _authService.getCurrentUser();
      
      if (currentUser == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Please login to view your orders';
        });
        return;
      }
      
      // Get orders for the current user
      final orders = await _orderService.getUserOrders(currentUser.id);
      
      setState(() {
        _isLoading = false;
        _orderList = orders;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load orders. Please try again.';
      });
      print('Error loading orders: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage, style: TextStyle(color: Colors.red)))
              : _orderList.isEmpty
                  ? const Center(child: Text('Bạn chưa có đơn hàng nào.'))
                  : RefreshIndicator(
                      onRefresh: _loadOrders,
                      child: ListView.builder(
                        itemCount: _orderList.length,
                        itemBuilder: (context, index) {
                          final order = _orderList[index];
                          return OrderItemCard(
                            order: order,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RealTimeOrderScreen(orderId: order.id),
                                ),
                              ).then((_) => _loadOrders());
                            },
                          );
                        },
                      ),
                    ),
    );
  }
}
