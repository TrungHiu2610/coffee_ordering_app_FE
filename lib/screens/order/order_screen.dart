import 'package:flutter/material.dart';
import 'package:flutter_coffee_shop_app/models/api_models.dart';
import 'package:flutter_coffee_shop_app/screens/layout.dart';
import 'package:flutter_coffee_shop_app/services/order_service.dart';
import 'package:provider/provider.dart';

class OrderDetailScreen extends StatefulWidget {
  final int orderId;

  const OrderDetailScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OrderDetailScreenState();
  }
}

class OrderDetailScreenState extends State<OrderDetailScreen> {
  final OrderService _orderService = OrderService();
  bool _isLoading = true;
  Order? _order;
  List<OrderItem> _orderItems = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadOrderDetails();
  }

  Future<void> _loadOrderDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final order = await _orderService.getOrderDetails(widget.orderId);

      setState(() {
        _isLoading = false;
        _order = order;
        _orderItems = order?.orderItems ?? [];
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load order details. Please try again.';
      });
      print('Error loading order details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chi tiết đơn hàng")),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
              ? Center(
                child: Text(_errorMessage, style: TextStyle(color: Colors.red)),
              )
              : _order == null
              ? const Center(child: Text('Order not found'))
              : Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Mã đơn: ${_order!.id}"),
                    Text(
                      "Ngày tạo: ${_order!.createdAt.toLocal().toString().split('.')[0]}",
                    ),
                    SizedBox(height: 8),                    Text(
                      "Trạng thái đơn: ${_order!.status}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _order!.status.toLowerCase() == 'canceled' ? 
                          Colors.red : 
                          (_order!.status.toLowerCase() == 'completed' ? 
                            Colors.green : 
                            Colors.orange),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text("Bàn số: ${_order!.table?.tableNumber.toString() ?? _order!.tableId?.toString() ?? "Không rõ"}"),
                    SizedBox(height: 12),
                    Text("Các món đã đặt:", style: TextStyle(fontSize: 16)),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _orderItems.length,
                        itemBuilder: (context, index) {
                          final item = _orderItems[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              title: Text(
                                "${item.product?.name ?? 'Unknown'} (${item.size?.name ?? 'Unknown'})",
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (item.orderItemToppings != null &&
                                      item.orderItemToppings!.isNotEmpty)
                                    Text(
                                      "Topping: ${item.orderItemToppings!.map((t) => t.topping?.name ?? 'Unknown').join(', ')}",
                                    ),
                                  if (item.notes != null &&
                                      item.notes!.isNotEmpty)
                                    Text("Ghi chú: ${item.notes}"),
                                ],
                              ),
                              trailing: Text("x${item.quantity}"),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => LayoutScreen()),
                        );
                      },
                      icon: Icon(Icons.add),
                      label: Text("Thêm món mới"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
