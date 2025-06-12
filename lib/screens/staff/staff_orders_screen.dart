import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/api_models.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_status_provider.dart';

class StaffOrdersScreen extends StatefulWidget {
  const StaffOrdersScreen({Key? key}) : super(key: key);

  @override
  State<StaffOrdersScreen> createState() => _StaffOrdersScreenState();
}

class _StaffOrdersScreenState extends State<StaffOrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    
    // Initialize order status tracking for staff immediately
    final provider = Provider.of<OrderStatusProvider>(context, listen: false);
    provider.initializeForStaff();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    // Check if user is staff
    if (authProvider.currentUser == null || authProvider.currentUser!.role != 'Staff') {
      return Scaffold(
        appBar: AppBar(title: Text('Quản lý đơn hàng')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Bạn không có quyền truy cập trang này'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Quay lại'),
              ),
            ],
          ),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý đơn hàng'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [          Tab(text: 'Đang chờ'),
            Tab(text: 'Đang pha chế'),
            Tab(text: 'Sẵn sàng'),
            Tab(text: 'Hoàn thành'),
            Tab(text: 'Đã hủy'),
          ],
        ),
      ),      body: TabBarView(
        controller: _tabController,
        children: [
          _OrderStatusTab(status: 'Pending'),
          _OrderStatusTab(status: 'Preparing'),
          _OrderStatusTab(status: 'Ready'),
          _OrderStatusTab(status: 'Completed'),
          _OrderStatusTab(status: 'Canceled'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final provider = Provider.of<OrderStatusProvider>(context, listen: false);
          provider.refreshAllOrders();
        },
        child: Icon(Icons.refresh),
        tooltip: 'Làm mới danh sách',
      ),
    );
  }
}

class _OrderStatusTab extends StatelessWidget {
  final String status;
  
  const _OrderStatusTab({Key? key, required this.status}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Consumer<OrderStatusProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        // if (provider.error != null) {
        //   return Center(
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Text(
        //           'Đã xảy ra lỗi',
        //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        //         ),
        //         const SizedBox(height: 8),
        //         Text(provider.error!),
        //         const SizedBox(height: 16),
        //         ElevatedButton(
        //           onPressed: () => provider.refreshAllOrders(),
        //           child: Text('Thử lại'),
        //         ),
        //       ],
        //     ),
        //   );
        // }
        
        final orders = provider.getOrdersByStatus(status);
        
        if (orders.isEmpty) {
          return Center(
            child: Text('Không có đơn hàng nào ở trạng thái ${_getStatusText(status)}'),
          );
        }
        
        return RefreshIndicator(
          onRefresh: () async {
            await provider.refreshAllOrders();
          },
          child: ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return _OrderCard(order: order);
            },
          ),
        );
      },
    );
  }
    String _getStatusText(String status) {
    switch (status) {
      case 'Pending':
        return 'Đang chờ';
      case 'Preparing':
        return 'Đang pha chế';
      case 'Ready':
        return 'Sẵn sàng';
      case 'Completed':
        return 'Hoàn thành';
      case 'Canceled':
        return 'Đã hủy';
      default:
        return status;
    }
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  
  const _OrderCard({Key? key, required this.order}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Đơn #${order.id}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _formatDateTime(order.createdAt),
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Khách hàng: ${order.user?.name ?? 'Không xác định'}',
            ),
            const SizedBox(height: 4),
            Text(
              'Phương thức thanh toán: ${order.paymentMethod}',
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text('Trạng thái thanh toán: '),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: order.isPaid ? Colors.green : Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    order.isPaid ? 'Đã thanh toán' : 'Chưa thanh toán',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),            Text(
              'Các món:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...(order.orderItems ?? []).map((item) => Padding(
              padding: const EdgeInsets.only(left: 8, top: 4),
              child: Text(
                '${item.quantity}x ${item.product?.name ?? 'Unknown'} (${item.size?.name ?? 'Unknown'})',
              ),
            )),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [                Text(
                  'Tổng tiền: ${order.totalAmount?.toStringAsFixed(0) ?? 'N/A'}đ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusButtons(context, order),
              ],
            )
          ],
        ),
      ),
    );
  }
    Widget _buildStatusButtons(BuildContext context, Order order) {
    final provider = Provider.of<OrderStatusProvider>(context, listen: false);
    
    switch (order.status) {
      case 'Pending':
        return Row(
          children: [
            ElevatedButton(
              onPressed: () => provider.updateOrderStatus(order.id, 'Preparing'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: Text('Bắt đầu pha chế'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => _confirmCancelOrder(context, order),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Hủy đơn'),
            ),
          ],
        );
      case 'Preparing':
        return ElevatedButton(
          onPressed: () => provider.updateOrderStatus(order.id, 'Ready'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
          child: Text('Sẵn sàng'),
        );
      case 'Ready':
        return Row(
          children: [
            if (!order.isPaid) ...[
              ElevatedButton(
                onPressed: () => _confirmPayment(context, order),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                child: Text('Xác nhận thanh toán'),
              ),
              const SizedBox(width: 8),
            ],
            ElevatedButton(
              onPressed: () => provider.updateOrderStatus(order.id, 'Completed'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('Hoàn thành'),
            ),
          ],
        );
      case 'Completed':
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'Đã hoàn thành',
            style: TextStyle(color: Colors.white),
          ),
        );
      case 'Canceled':
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'Đã hủy',
            style: TextStyle(color: Colors.white),
          ),
        );
      default:
        return Container();
    }
  }
    void _confirmCancelOrder(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Xác nhận hủy đơn'),
        content: Text('Bạn có chắc chắn muốn hủy đơn hàng #${order.id}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Không'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Provider.of<OrderStatusProvider>(context, listen: false)
                  .updateOrderStatus(order.id, 'Canceled');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Hủy đơn'),
          ),
        ],
      ),
    );
  }
  
  void _confirmPayment(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Xác nhận thanh toán'),
        content: Text('Xác nhận khách hàng đã thanh toán đơn hàng #${order.id}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // Use the new payment confirmation method
              Provider.of<OrderStatusProvider>(context, listen: false)
                  .confirmPayment(order.id);
            },
            child: Text('Xác nhận'),
          ),
        ],
      ),
    );
  }
  
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final orderDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    if (orderDate == today) {
      return 'Hôm nay ${dateTime.hour}:${_twoDigits(dateTime.minute)}';
    } else if (orderDate == today.subtract(Duration(days: 1))) {
      return 'Hôm qua ${dateTime.hour}:${_twoDigits(dateTime.minute)}';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${_twoDigits(dateTime.minute)}';
    }
  }
  
  String _twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }
}
