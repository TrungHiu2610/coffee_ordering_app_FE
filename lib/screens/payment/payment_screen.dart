import 'package:flutter/material.dart';
import 'package:flutter_coffee_shop_app/extensions/CartItem_TotalPrice.dart';
import 'package:flutter_coffee_shop_app/models/models.dart';
import 'package:flutter_coffee_shop_app/providers/cart_provider.dart';
import 'package:flutter_coffee_shop_app/screens/order/order_screen.dart';
import 'package:flutter_coffee_shop_app/services/realm.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  String printToppings(RealmList<Topping> toppings) {
    if (toppings.isEmpty) return "Không có topping";
    return toppings.map((t) => t.name).join(", ");
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = RealmService().currentCart?.cartItems.toList() ?? [];

    final total = cartProvider.totalPrice;
    final discount = 0.0;
    final finalTotal = total - discount;

    return Scaffold(
      appBar: AppBar(
        title: Text("Xác nhận đơn hàng"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: cartItems.isEmpty
          ? Center(child: Text("Không có sản phẩm trong giỏ hàng"))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (_, index) {
                final item = cartItems[index];
                final product = item.product;

                return ListTile(
                  title: Text(
                    product?.name ?? "Unknown",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Size: ${item.productSize?.size?.name}"),
                      Text("Topping: ${printToppings(item.toppings)}"),
                      Text(
                        "${item.description.isEmpty ? "No description" : item.description}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                          "${item.totalPrice.toStringAsFixed(0)}đ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  trailing: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              cartProvider.decreaseQuantity(item);
                            },
                          ),
                          Text("${item.quantity}"),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              cartProvider.increaseQuantity(item);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              // TODO: Điều hướng đến trang sửa topping/size
                            },
                          ),
                        ],
                      ),

                    ],
                  ),
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Tạm tính: ${total.toStringAsFixed(0)}đ"),
                Text("Giảm giá: ${discount.toStringAsFixed(0)}đ"),
                Text(
                  "Tổng cộng: ${finalTotal.toStringAsFixed(0)}đ",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    final realmService = RealmService();
                    final realm = realmService.realm;
                    final cart = RealmService().currentCart;
                    if (cart == null || cart.cartItems.isEmpty) return;

                    final newOrder = Order(
                        ObjectId(),
                        DateTime.now(),
                        "Chờ quán xác nhận",
                        "Tại quầy",
                        customer: RealmService().getCurrentUser(),
                        items: []
                    );

                    final newOrderItems = cart.cartItems.map((item) {
                      return OrderItem(
                        ObjectId(),
                        item.quantity,
                        item.description,
                        "Chờ xác nhận",
                        product: item.product,
                        productSize: item.productSize,
                        toppings: item.toppings,
                        order: newOrder
                      );
                    }).toList();

                    newOrder.items.addAll(newOrderItems);

                    realm.write(() {
                      realm.add(newOrder);
                    });

                    cartProvider.clearCart();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Đơn hàng đã được gửi")),
                    );

                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => OrderDetailScreen(order: newOrder))
                    );

                    // bên phía khách hàng:
                    // clear giỏ hàng
                    // tạo 1 order
                    // pttt là tại quầy, trangj thái đơn là chờ thanh toán tại quầy
                    // trạng thái xử lý:đặt hàng thành công và trạng thái gì đó là chờ xác nhận trên món mới đặt
                    // sẽ có 1 nút thêm món để khách hàng thêm tiếp món khác, trạng thái là đã thêm món gì,..., ví dụ đặt thêm cà phê sữa thì danh saách trạng thái là: 1.đặt hàng thành công 2. đã xác nhận các món trong giỏ hàng 3. đã thêm món cà phê sữa 4. đã xác nhận món cà phê sữa
                    // khi được xác nhận món mới rồi thì lúc này các món mới đó mới có trạng thái là đã xác nhận
                    // sau khi được thông báo và trạng thái được update thành chờ lấy nước, khách hàng sẽ đến quầy lấy nước, show order id và lấy nước
                    // sau đó khách hàng chọn xác nhận đơn hàng, sau khi xác nhận thì khách hàng sẽ được đánh giá review từng món nước đã đặt
                    // quá trình thanh toán tại quầy kết thúc

                    // bên phía nhân viên
                    // bên màn hình của nhân viên sẽ pop up đơn hàng chờ xác nhận
                    // khi nhân viên bấm xác nhận thì trạng thái xử lý của các sản phẩm trong đơn vừa đặt bên máy của khách hàng là đã xác nhận
                    // nếu khách hàng đặt tiếp món khác thì cũng xem chi tiết đơn, rồi bấm xác nhận.
                    // sau khi làm nước xong, sẽ bấm hòan thành đơn hàng, lúc này máy khách sẽ được thông báo và cập nhật trạng thái xử lý là chờ lấy nước
                  },
                  child: Text("Xác nhận (Thanh toán tại quầy)"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Điều hướng đến trang thanh toán online
                  },
                  child: Text("Thanh toán online"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
