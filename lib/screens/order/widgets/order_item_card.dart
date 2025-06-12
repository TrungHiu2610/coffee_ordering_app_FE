import 'package:flutter/material.dart';
import 'package:flutter_coffee_shop_app/models/api_models.dart';
import 'package:intl/intl.dart';

class OrderItemCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;

  const OrderItemCard({Key? key, required this.order, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Order ID and time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Đơn hàng #${order.id}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (order.table != null && order.table!.tableNumber != null)
                        Text('Bàn số: ${order.table!.tableNumber}', style: TextStyle(fontSize: 13, color: Colors.brown))
                      else if (order.tableId != null)
                        Text('Bàn số: ${order.tableId}', style: TextStyle(fontSize: 13, color: Colors.brown)),
                    ],
                  ),
                  Text(DateFormat('dd/MM/yyyy HH:mm').format(order.createdAt)),
                ],
              ),
              const SizedBox(height: 8),
              
              // Status and payment method
              Row(
                children: [
                  _statusDot(order.status),
                  const SizedBox(width: 6),
                  Text(_getTranslatedStatus(order.status)), // Sử dụng hàm dịch
                  const Spacer(),
                  _paymentDot(order.isPaid),
                  const SizedBox(width: 6),
                  Text(order.isPaid ? 'Đã thanh toán' : 'Chưa thanh toán'),
                ],
              ),
              
              const Divider(height: 20),
              
              // Order items
              if (order.orderItems != null && order.orderItems!.isNotEmpty)
                ...order.orderItems!.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    '${item.product?.name ?? 'Unknown'} - ${item.size?.name ?? 'Unknown'}'
                    '${item.orderItemToppings != null && item.orderItemToppings!.isNotEmpty 
                      ? " - ${item.orderItemToppings!.map((t) => t.topping?.name ?? 'Unknown').join(', ')}" 
                      : ""}'
                    '${item.notes != null && item.notes!.isNotEmpty ? " - ${item.notes}" : ""}',
                  ),
                )),

              const SizedBox(height: 8),
              Text(
                'Tổng tiền: ${NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0).format(order.totalAmount ?? 0)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTranslatedStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Chờ xác nhận';
      case 'confirmed': // Giữ lại nếu API có thể trả về confirmed
        return 'Đã xác nhận';
      case 'processing':
      case 'making':
        return 'Bắt đầu pha chế';
      case 'ready':
        return 'Chờ nhận món';      case 'completed':
        return 'Hoàn thành';
      case 'cancelled':
      case 'canceled':
        return 'Đã hủy';
      default:
        return status; // Trả về trạng thái gốc nếu không khớp
    }
  }

  Widget _statusDot(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'pending':
      case 'chờ xác nhận':
        color = Colors.grey;
        break;
      case 'confirmed':
      case 'đã xác nhận':
        color = Colors.blue;
        break;
      case 'processing':
      case 'đang xử lý':
      case 'making': // Thêm making
      case 'bắt đầu pha chế': // Thêm bản dịch mới
      case 'đang chế biến':
        color = Colors.orange;
        break;
      case 'ready':
      case 'sẵn sàng':
      case 'chờ nhận món': // Thêm bản dịch mới
      case 'tới quầy nhận nước':
        color = Colors.green;
        break;      case 'completed':
      case 'hoàn thành':
      case 'đã hoàn thành':
        color = Colors.teal;
        break;
      case 'cancelled':
      case 'canceled':
      case 'đã hủy':
        color = Colors.red;
        break;
      default:
        color = Colors.black;
    }
    return CircleAvatar(radius: 5, backgroundColor: color);
  }

  Widget _paymentDot(bool isPaid) {
    return CircleAvatar(
      radius: 5,
      backgroundColor: isPaid ? Colors.green : Colors.amber,
    );
  }
}
