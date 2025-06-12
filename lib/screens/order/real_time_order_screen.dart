import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/api_models.dart';
import '../../providers/order_status_provider.dart';
import '../../providers/table_provider.dart';
import '../review/add_review_sheet.dart';

class RealTimeOrderScreen extends StatefulWidget {
  final int orderId;

  const RealTimeOrderScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  State<RealTimeOrderScreen> createState() => _RealTimeOrderScreenState();
}

class _RealTimeOrderScreenState extends State<RealTimeOrderScreen> {
  bool _hasHandledCompletion = false;

  @override
  void initState() {
    super.initState();
    // Initialize order status tracking
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<OrderStatusProvider>(context, listen: false);
      provider.initializeForOrder(widget.orderId);
    });
  }

  void _handleOrderCompletion(Order order) async {
    if (!_hasHandledCompletion && order.status == 'Completed' && order.tableId != null) {
      _hasHandledCompletion = true;
      // Release the table when order is completed
      try {
        final tableProvider = Provider.of<TableProvider>(context, listen: false);
        await tableProvider.releaseTable();
      } catch (e) {
        print('Error releasing table: $e');
        // Don't show error to user since order is still completed
      }
    }
  }

  // Method to show the review sheet for an order item
  void _showReviewSheet(OrderItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => AddReviewSheet(
        orderItem: item,
        onReviewSubmitted: () {
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đơn hàng #${widget.orderId}'),
      ),
      body: Consumer<OrderStatusProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Đã xảy ra lỗi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(provider.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.refreshOrder(widget.orderId),
                    child: Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          final order = provider.getOrderById(widget.orderId);
          if (order == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Không tìm thấy thông tin đơn hàng'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.refreshOrder(widget.orderId),
                    child: Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          // Handle order completion if needed
          _handleOrderCompletion(order);

          return _buildOrderDetails(order);
        },
      ),
    );
  }

  Widget _buildOrderDetails(Order order) {
    return RefreshIndicator(
      onRefresh: () async {
        await Provider.of<OrderStatusProvider>(context, listen: false)
            .refreshOrder(widget.orderId);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrderStatusTracker(order),
              const SizedBox(height: 24),
              _buildOrderInfo(order),
              const SizedBox(height: 16),
              _buildOrderItems(order),
              const SizedBox(height: 16),
              _buildPaymentInfo(order),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderStatusTracker(Order order) {
    final statusSteps = [
      'Pending',
      'Preparing',
      'Ready',
      'Completed',
    ];
    
    final currentIndex = statusSteps.indexOf(order.status);
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trạng thái đơn hàng',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: List.generate(statusSteps.length * 2 - 1, (index) {
                // For even indices, we show the circle
                if (index % 2 == 0) {
                  final stepIndex = index ~/ 2;
                  final isActive = stepIndex <= currentIndex;
                  final isCurrent = stepIndex == currentIndex;
                  
                  return Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? Colors.green : Colors.grey[300],
                      border: isCurrent
                          ? Border.all(color: Colors.green, width: 3)
                          : null,
                    ),
                    child: isActive
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
                  );
                } else {
                  // For odd indices, we show the line
                  final beforeIndex = index ~/ 2;
                  final isActive = beforeIndex < currentIndex;
                  
                  return Expanded(
                    child: Container(
                      height: 3,
                      color: isActive ? Colors.green : Colors.grey[300],
                    ),
                  );
                }
              }),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: statusSteps.map((status) {
                final isActive = statusSteps.indexOf(status) <= currentIndex;
                
                return Text(
                  _getStatusText(status),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive ? Colors.black : Colors.grey,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getStatusText(order.status),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderInfo(Order order) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thông tin đơn hàng',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: Text('Mã đơn hàng:')),
                Text('#${order.id}', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(child: Text('Ngày đặt:')),
                Text(
                  '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year} ${order.createdAt.hour}:${order.createdAt.minute}',
                ),
              ],
            ),
            if (order.user != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(child: Text('Khách hàng:')),
                  Text(order.user!.name),
                ],
              ),
            ],
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(child: Text('Bàn số: ${order.table?.tableNumber}')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItems(Order order) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Các món đã đặt',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...order.orderItems!.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item.quantity}x',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${item.product?.name ?? 'Unknown'} (${item.size?.name ?? 'Unknown'})',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (item.orderItemToppings != null &&
                            item.orderItemToppings!.isNotEmpty)
                          Text(
                            'Topping: ${item.orderItemToppings!.map((t) => t.topping?.name ?? 'Unknown').join(', ')}',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        if (item.notes != null && item.notes!.isNotEmpty)
                          Text(
                            'Ghi chú: ${item.notes}',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        // Add review button if order is completed
                        if (order.status == 'Completed')
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: TextButton.icon(
                              onPressed: () => _showReviewSheet(item),
                              icon: Icon(Icons.rate_review, size: 16),
                              label: Text('Đánh giá'),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                //minimumSize: Size(0, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                foregroundColor: Colors.brown,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    '${(item.price + item.additionalPrice) * item.quantity}đ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tổng tiền',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${order.totalAmount}đ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentInfo(Order order) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thanh toán',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: Text('Phương thức:')),
                Text(order.paymentMethod),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(child: Text('Trạng thái:')),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
          ],
        ),
      ),
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
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Preparing':
        return Colors.blue;
      case 'Ready':
        return Colors.purple;
      case 'Completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
