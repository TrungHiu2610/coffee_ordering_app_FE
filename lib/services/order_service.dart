import '../models/api_models.dart';
import 'api_client.dart';
import 'dio_client.dart';
import 'cart_service.dart';

class OrderService {
  final ApiClient _apiClient;
  final CartService _cartService;

  OrderService() 
    : _apiClient = ApiClient(DioClient().dio),
      _cartService = CartService();

  Future<Order?> createOrder(OrderCreateDto orderDto) async {
    try {
      // Create order using the provided DTO
      final order = await _apiClient.createOrder(orderDto);
      
      // Clear cart after successful order
      await _cartService.clearCart();
      
      return order;
    } catch (e) {
      print('Create order error: $e');
      return null;
    }
  }

  Future<List<Order>> getOrders() async {
    try {
      return await _apiClient.getOrders();
    } catch (e) {
      print('Get user orders error: $e');
      return [];
    }
  }

  Future<List<Order>> getUserOrders(int userId) async {
    try {
      return await _apiClient.getOrdersByUser(userId);
    } catch (e) {
      print('Get user orders error: $e');
      return [];
    }
  }

  Future<Order?> getOrderDetails(int orderId) async {
    try {
      return await _apiClient.getOrder(orderId);
    } catch (e) {
      print('Get order details error: $e');
      return null;
    }
  }
  Future<bool> updateOrderStatus(int orderId, String status) async {
    try {
      await _apiClient.updateOrderStatus(orderId, {'status': status});
      return true;
    } catch (e) {
      print('Update order status error: $e');
      return false;
    }
  }
  
  Future<bool> confirmPayment(int orderId) async {
    try {
      await _apiClient.confirmPayment(orderId);
      return true;
    } catch (e) {
      print('Confirm payment error: $e');
      return false;
    }
  }
}
