import 'package:flutter/material.dart';
import 'package:flutter_coffee_shop_app/models/models.dart';
import 'package:flutter_coffee_shop_app/screens/layout.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';

import '../../services/realm.dart';

class OrderDetailScreen extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return OrderDetailScreenState();
  }
}

class OrderDetailScreenState extends State<OrderDetailScreen> {

  late RealmService realmService;
  late Realm realm;
  late Order order;
  late List<OrderItem> orderItems;

  @override
  void initState() {
    super.initState();
    realmService = context.read<RealmService>();
    realm = realmService.realm;
    realmService.setCurrentOrder();
    order = realmService.currentOrder!;
    orderItems = order.items.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chi tiết đơn hàng"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Mã đơn: ${order.id}"),
            Text("Ngày tạo: ${order.createdAt}"),
            SizedBox(height: 8),
            Text("Trạng thái đơn: ${order.status}",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange)),
            SizedBox(height: 12),

            Text("Các món đã đặt:", style: TextStyle(fontSize: 16)),
            Expanded(
              child: ListView.builder(
                itemCount: orderItems.length,
                itemBuilder: (context, index) {
                  final item = orderItems[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text("${item.product?.name ?? 'Unknown'} (${item.productSize?.size?.name})"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item.toppings.isNotEmpty)
                            Text("Topping: ${item.toppings.map((t) => t.name).join(', ')}"),
                          if (item.note.isNotEmpty)
                            Text("Ghi chú: ${item.note}"),
                          Text("Trạng thái: ${item.status}"),
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
                // TODO: Điều hướng về trang menu đặt thêm món
                Navigator.push(
                    context,
                  MaterialPageRoute(builder: (_) => LayoutScreen())
                ); // hoặc chuyển sang MenuScreen
              },
              icon: Icon(Icons.add),
              label: Text("Thêm món mới"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
            )
          ],
        ),
      ),
    );
  }
}
