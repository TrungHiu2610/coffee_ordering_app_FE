import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/api_models.dart';
import '../services/order_service.dart';
import '../services/signalr_service.dart';

class OrderStatusProvider with ChangeNotifier {
  final OrderService _orderService = OrderService();
  final SignalRService _signalRService = SignalRService();
  
  Map<int, Order> _orders = {};
  bool _isLoading = false;
  String? _error;
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Get all current orders
  List<Order> get allOrders => _orders.values.toList();
  
  // Get orders filtered by status
  List<Order> getOrdersByStatus(String status) {
    return _orders.values.where((order) => order.status == status).toList();
  }
  
  // Get a specific order by ID
  Order? getOrderById(int id) => _orders[id];
  
  OrderStatusProvider() {
  // Initialize by listening to SignalR updates
    _signalRService.orderStatusUpdates.listen(_handleOrderStatusUpdate);
    _signalRService.paymentConfirmations.listen(_handlePaymentConfirmation);
    _signalRService.newOrders.listen(_handleNewOrder);
    
    // Ensure connection is maintained
    _maintainConnection();
  }
  
  // Initialize and load data for a specific order
  Future<void> initializeForOrder(int orderId) async {
    await _signalRService.joinOrderGroup(orderId);
    await refreshOrder(orderId);
  }
    // Initialize for staff view
  Future<void> initializeForStaff() async {
    try {
      print('Initializing OrderStatusProvider for staff');
      await _signalRService.ensureConnected();
      await _signalRService.joinStaffGroup();
      await refreshAllOrders();
      print('Staff initialization complete');
    } catch (e) {
      print('Error in initializeForStaff: $e');
      _setError('Failed to initialize staff view: $e');
    }
  }
  
  // Refresh a specific order
  Future<void> refreshOrder(int orderId) async {
    _setLoading(true);
    
    try {
      final order = await _orderService.getOrderDetails(orderId);
      if (order != null) {
        _orders[orderId] = order;
      }
      _setLoading(false);
    } catch (e) {
      _setError('Failed to load order: $e');
    }
  }
  
  // Refresh all orders (for staff view)
  Future<void> refreshAllOrders() async {
    _setLoading(true);
    
    try {
      final orders = await _orderService.getOrders();
      
      _orders = {};
      for (var order in orders) {
        _orders[order.id] = order;
      }
      
      _setLoading(false);
    } catch (e) {
      _setError('Failed to load orders: $e');
    }
  }
  // Update order status (for staff)
  Future<void> updateOrderStatus(int orderId, String status) async {
    try {
      await _orderService.updateOrderStatus(orderId, status);
      // Update local state immediately for better UX
      if (_orders.containsKey(orderId)) {
        _orders[orderId]!.status = status;
        notifyListeners();
      }
      // The update will come back through SignalR
    } catch (e) {
      _setError('Failed to update order status: $e');
    }
  }
  
  // Confirm payment for an order
  Future<void> confirmPayment(int orderId) async {
    try {
      await _orderService.confirmPayment(orderId);
      // Update local state immediately
      if (_orders.containsKey(orderId)) {
        _orders[orderId]!.isPaid = true;
        notifyListeners();
      }
      // The update will come back through SignalR
    } catch (e) {
      _setError('Failed to confirm payment: $e');
    }
  }
  
  // void _handleOrderStatusUpdate(OrderStatusUpdate update) {
  //   if (_orders.containsKey(update.orderId)) {
  //     _orders[update.orderId]!.status = update.status;
  //     notifyListeners();
  //   }
  // }

  // void _handlePaymentConfirmation(int orderId) {
  //   if (_orders.containsKey(orderId)) {
  //     _orders[orderId]!.isPaid = true;
  //     notifyListeners();
  //   }
  // }

  // void _handleNewOrder(Order order) {
  //   _orders[order.id] = order;
  //   notifyListeners();
  // }
  //
  // void _setLoading(bool value) {
  //   _isLoading = value;
  //   notifyListeners();
  // }
  //
  // void _setError(String? error) {
  //   _error = error;
  //   _isLoading = false;
  //   notifyListeners();
  // }
  //
  // Future<void> _maintainConnection() async {
  //   while (true) {
  //     await Future.delayed(const Duration(seconds: 30));
  //     await _signalRService.ensureConnected();
  //   }
  // }
    void _handleOrderStatusUpdate(OrderStatusUpdate update) {
    if (_orders.containsKey(update.orderId)) {
      final updatedOrder = _orders[update.orderId]!;
      final newOrder = Order(
        id: updatedOrder.id,
        createdAt: updatedOrder.createdAt,
        status: update.status,
        paymentMethod: updatedOrder.paymentMethod,
        isPaid: updatedOrder.isPaid,
        userId: updatedOrder.userId,
        user: updatedOrder.user,
        orderItems: updatedOrder.orderItems,
        totalAmount: updatedOrder.totalAmount,
        tableId: updatedOrder.tableId,
        table: updatedOrder.table,
      );
      
      _orders[update.orderId] = newOrder;
      notifyListeners();
    } else {
      // If we don't have this order yet, load it
      refreshOrder(update.orderId);
    }
  }
    void _handlePaymentConfirmation(int orderId) {
    if (_orders.containsKey(orderId)) {
      final updatedOrder = _orders[orderId]!;
      final newOrder = Order(
        id: updatedOrder.id,
        createdAt: updatedOrder.createdAt,
        status: updatedOrder.status,
        paymentMethod: updatedOrder.paymentMethod,
        isPaid: true,
        userId: updatedOrder.userId,
        user: updatedOrder.user,
        orderItems: updatedOrder.orderItems,
        totalAmount: updatedOrder.totalAmount,
        tableId: updatedOrder.tableId,
        table: updatedOrder.table,
      );
      
      _orders[orderId] = newOrder;
      notifyListeners();
    }
  }
  void _handleNewOrder(Order order) {
    print('[SignalR] NewOrder received: ${order.toJson()}');
    
    try {
      // If we already have this order, update it
      if (_orders.containsKey(order.id)) {
        _orders[order.id] = order;
        notifyListeners();
        return;
      }
      
      // For a new order, add it to our list
      _orders[order.id] = order;
      
      // If the order object is incomplete (missing related data),
      // fetch complete details from the API
      if (order.orderItems == null || order.orderItems!.isEmpty) {
        print('[SignalR] Order ${order.id} has no items, fetching complete details');
        refreshOrder(order.id);
      } else {
        notifyListeners();
      }
    } catch (e) {
      print('[SignalR] Error in _handleNewOrder: $e');
      _setError('Error handling new order: $e');
    }
  }
  
  void _setLoading(bool isLoading) {
    _isLoading = isLoading;
    _error = null;
    notifyListeners();
  }
    void _setError(String error) {
    _isLoading = false;
    _error = error;
    notifyListeners();
  }
  
  // Maintain connection and reconnect if needed
  Future<void> _maintainConnection() async {
    // Check connection every 30 seconds and reconnect if needed
    Timer.periodic(const Duration(seconds: 30), (timer) async {
      await _signalRService.ensureConnected();
    });
  }
}
