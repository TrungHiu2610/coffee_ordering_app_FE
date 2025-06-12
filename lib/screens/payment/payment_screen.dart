import 'package:flutter/material.dart';
import 'package:flutter_coffee_shop_app/models/api_models.dart';
import 'package:flutter_coffee_shop_app/providers/cart_provider.dart';
import 'package:flutter_coffee_shop_app/providers/loyalty_provider.dart';
import 'package:flutter_coffee_shop_app/providers/table_provider.dart';
import 'package:flutter_coffee_shop_app/screens/layout.dart';
import 'package:flutter_coffee_shop_app/screens/order/order_screen.dart';
import 'package:flutter_coffee_shop_app/screens/order/real_time_order_screen.dart';
import 'package:flutter_coffee_shop_app/services/auth_service.dart';
import 'package:flutter_coffee_shop_app/services/order_service.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  final double totalAmount;
  final int userId;
  
  const PaymentScreen({
    Key? key,
    required this.totalAmount, 
    required this.userId,
  }) : super(key: key);
  
  @override
  State<PaymentScreen> createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  final OrderService _orderService = OrderService();
  final AuthService _authService = AuthService();
  
  List<CartItem> cartItems = [];
  bool isLoading = true;
  bool isProcessing = false;
  String? errorMessage;
  String selectedPaymentMethod = 'Cash';
  String? note;
  late int? tableNumber;
  
  // Loyalty points functionality
  bool useLoyaltyDiscount = false;
  bool useFreeDrink = false;
  User? currentUser;
  double discountedAmount = 0;
  
  final paymentMethods = [
    'Cash',
    'Banking',
    'Momo',
  ];
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    
    try {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final loyaltyProvider = Provider.of<LoyaltyProvider>(context, listen: false);
      tableNumber = Provider.of<TableProvider>(context, listen: false).selectedTable?.tableNumber;

      currentUser = await _authService.getCurrentUser();
      
      if (currentUser == null) {
        setState(() {
          isLoading = false;
          errorMessage = 'Please login to continue';
        });
        return;
      }
      
      // Calculate points that would be earned from this purchase
      final pointsToEarn = loyaltyProvider.calculatePointsFromPurchase(widget.totalAmount);
      
      // Check for loyalty discount eligibility
      final canUseDiscount = loyaltyProvider.userQualifiesForBenefit(currentUser!, 'discount10');
      final canGetFreeDrink = loyaltyProvider.userQualifiesForBenefit(currentUser!, 'freeDrink');
      
      // Calculate discounted amount
      double discount = 0;
      if (canUseDiscount) {
        discount = widget.totalAmount * 0.1; // 10% discount
      }
      
      setState(() {
        cartItems = cartProvider.cartItems;
        discountedAmount = discount;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load payment data: $e';
      });
    }
  }
    Future<void> _processPayment() async {
    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Giỏ hàng trống')),
      );
      return;
    }
    
    setState(() {
      isProcessing = true;
      errorMessage = null;
    });
    
    try {
      final loyaltyProvider = Provider.of<LoyaltyProvider>(context, listen: false);
      
      if (currentUser == null) {
        setState(() {
          isProcessing = false;
          errorMessage = 'Please login to continue';
        });
        return;
      }
      
      // Calculate final amount after discounts
      final finalAmount = _calculateFinalAmount();
      
      // Create order with the discounted amount if applicable
      final order = await _orderService.createOrder(
        OrderCreateDto(
          userId: currentUser!.id,
          items: cartItems.map((item) => OrderItemDto(
            productId: item.productId,
            sizeId: item.sizeId,
            quantity: item.quantity,
            toppingIds: item.toppingIds,
            note: item.notes,
          )).toList(),
          totalAmount: finalAmount,
          paymentMethod: selectedPaymentMethod,
          note: note,
          tableNumber: tableNumber,
          usedLoyaltyDiscount: useLoyaltyDiscount,
          usedFreeDrink: useFreeDrink,
        ),
      );
      
      // Add points for this purchase
      final pointsToAdd = loyaltyProvider.calculatePointsFromPurchase(widget.totalAmount);
      await loyaltyProvider.addPointsToUser(pointsToAdd);
      
      // Clear cart
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      await cartProvider.clearCart();
      
      // Navigate to order details
      if (!mounted) return;
      
      // If ordering from a table, navigate to real-time order tracking
      if (tableNumber != null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => RealTimeOrderScreen(orderId: order!.id),
          ),
          ModalRoute.withName('/home'),
        );
      } else {
        // Regular flow for non-table orders
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => RealTimeOrderScreen(orderId: order!.id),
          ),
          ModalRoute.withName('/home'),
        );
      }
    } catch (e) {
      setState(() {
        isProcessing = false;
        errorMessage = 'Failed to process payment: $e';
      });
    }
  }
  
  String _printToppings(List<Topping>? toppings) {
    if (toppings == null || toppings.isEmpty) return "Không có topping";
    return toppings.map((t) => t.name).join(", ");
  }
    // Calculate the value of a free drink
  double _calculateFreeDrinkValue() {
    if (!useFreeDrink || cartItems.isEmpty) return 0;

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    double? cheapestItemPrice;

    CartItem cheapestItem = cartItems.reduce((currentItem, nextItem) =>
    currentItem.product!.price < nextItem.product!.price ? currentItem : nextItem);
    
    return cartProvider.calculateItemTotal(cheapestItem)/cheapestItem.quantity ?? 0;
  }
    // Calculate final amount after discounts
  double _calculateFinalAmount() {
    // Get the total from cart provider to ensure all item prices include toppings
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    double finalAmount = cartProvider.calculateTotalPrice();
    
    // Apply 10% discount if selected
    if (useLoyaltyDiscount) {
      finalAmount = finalAmount * 0.9; // 10% off
    }
    
    // Apply free drink if selected
    if (useFreeDrink) {
      finalAmount = finalAmount - _calculateFreeDrinkValue();
    }
    
    return finalAmount > 0 ? finalAmount : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Xác nhận đơn hàng"),
      ),
      body: isLoading 
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Order items
                            const Text(
                              'Các món đã chọn',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...cartItems.map((item) => Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product?.name ?? 'Unknown Product',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (item.size != null) ...[
                                      const SizedBox(height: 4),
                                      Text('Size: ${item.size!.name}'),
                                    ],
                                    const SizedBox(height: 4),
                                    Text('Topping: ${_printToppings(item.toppings)}'),
                                    if (item.notes?.isNotEmpty == true) ...[
                                      const SizedBox(height: 4),
                                      Text('Ghi chú: ${item.notes}'),
                                    ],
                                    const SizedBox(height: 4),
                                    Text(
                                      'Số lượng: ${item.quantity}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )).toList(),
                            
                            const SizedBox(height: 24),
                            
                            // Payment method
                            const Text(
                              'Phương thức thanh toán',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Card(
                              child: Column(
                                children: paymentMethods.map((method) => RadioListTile<String>(
                                  title: Text(method),
                                  value: method,
                                  groupValue: selectedPaymentMethod,
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() => selectedPaymentMethod = value);
                                    }
                                  },
                                )).toList(),
                              ),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Loyalty points section
                            if (currentUser != null && currentUser!.totalPoints >= 0) ...[
                              const Text(
                                'Ưu đãi thành viên',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.card_membership, color: Colors.amber),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Điểm tích lũy: ${currentUser!.totalPoints.toStringAsFixed(0)}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      
                                      // 10% discount option
                                      if (currentUser!.totalPoints >= 100) ...[
                                        CheckboxListTile(
                                          title: const Text('Giảm giá 10%'),
                                          subtitle: Text(
                                            'Tiết kiệm ${(widget.totalAmount * 0.1).toStringAsFixed(0)}đ',
                                            style: TextStyle(color: Colors.green),
                                          ),
                                          value: useLoyaltyDiscount,
                                          onChanged: (value) {
                                            setState(() {
                                              useLoyaltyDiscount = value ?? false;
                                            });
                                          },
                                          activeColor: Colors.brown,
                                        ),
                                      ],
                                      
                                      // Free drink option
                                      if (currentUser!.totalPoints >= 200) ...[
                                        CheckboxListTile(
                                          title: const Text('Đổi 1 ly nước miễn phí'),
                                          subtitle: const Text('Áp dụng cho 1 món trong đơn hàng'),
                                          value: useFreeDrink,
                                          onChanged: (value) {
                                            setState(() {
                                              useFreeDrink = value ?? false;
                                            });
                                          },
                                          activeColor: Colors.brown,
                                        ),
                                      ],
                                      
                                      // Points to be earned
                                      const SizedBox(height: 8),
                                      const Divider(),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.add_circle_outline, color: Colors.green),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Bạn sẽ nhận được: +${(widget.totalAmount / 1000).toStringAsFixed(0)} điểm',
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                            
                            // Note
                            const Text(
                              'Ghi chú',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Nhập ghi chú cho đơn hàng (nếu có)',
                              ),
                              maxLines: 3,
                              onChanged: (value) => note = value,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Bottom section with total and confirm button
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [                              Consumer<CartProvider>(
                                builder: (context, cartProvider, child) => Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Tổng tiền hàng',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      '${cartProvider.calculateTotalPrice().toStringAsFixed(0)}đ',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            
                            // Show discount if applied
                            if (useLoyaltyDiscount) ...[
                              const SizedBox(height: 8),                              Consumer<CartProvider>(
                                builder: (context, cartProvider, child) => Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Giảm giá thành viên (10%)',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Text(
                                      '-${(cartProvider.calculateTotalPrice() * 0.1).toStringAsFixed(0)}đ',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            
                            // Show free drink if applied
                            if (useFreeDrink) ...[
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Đổi điểm - 1 ly miễn phí',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.green,
                                    ),
                                  ),
                                  Text(
                                    '-${_calculateFreeDrinkValue().toStringAsFixed(0)}đ',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            
                            const SizedBox(height: 8),
                            const Divider(),
                            const SizedBox(height: 8),
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Tổng thanh toán',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${_calculateFinalAmount().toStringAsFixed(0)}đ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: isProcessing ? null : _processPayment,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: isProcessing
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : const Text(
                                        'Xác nhận đặt hàng',
                                        style: TextStyle(fontSize: 16),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
