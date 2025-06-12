import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_coffee_shop_app/models/api_models.dart';
import 'package:flutter_coffee_shop_app/services/dio_client.dart';

import '../models/payment_model.dart';

class PaymentService {
  final DioClient _dioClient = DioClient();
  
  // Process an online payment
  Future<PaymentResponse> processOnlinePayment(PaymentRequest request) async {
    try {
      final response = await _dioClient.dio.post(
        '/api/payments/process',
        data: jsonEncode(request.toJson()),
      );
      return PaymentResponse.fromJson(response.data);
    } catch (e) {
      if (kDebugMode) {
        print('Error processing payment: $e');
      }
      rethrow;
    }
  }
  
  // Verify payment status
  Future<PaymentStatus> checkPaymentStatus(int paymentId) async {
    try {
      final response = await _dioClient.dio.get('/api/payments/$paymentId/status');
      return PaymentStatus.fromJson(response.data);
    } catch (e) {
      if (kDebugMode) {
        print('Error checking payment status: $e');
      }
      rethrow;
    }
  }
  
  // Generate a payment QR code for mobile payment apps
  Future<String> generatePaymentQrCode(PaymentQrRequest request) async {
    try {
      final response = await _dioClient.dio.post(
        '/api/payments/qr-code',
        data: jsonEncode(request.toJson()),
      );
      return response.data['qrCodeUrl'];
    } catch (e) {
      if (kDebugMode) {
        print('Error generating QR code: $e');
      }
      rethrow;
    }
  }
  
  // Request a refund
  Future<RefundResponse> requestRefund(RefundRequest request) async {
    try {
      final response = await _dioClient.dio.post(
        '/api/payments/refund',
        data: jsonEncode(request.toJson()),
      );
      return RefundResponse.fromJson(response.data);
    } catch (e) {
      if (kDebugMode) {
        print('Error requesting refund: $e');
      }
      rethrow;
    }
  }
  
  // For demo purposes - simulate payment processing
  Future<PaymentResponse> simulatePayment(PaymentRequest request) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Simulate success with 90% probability
      final random = DateTime.now().millisecondsSinceEpoch % 10;
      final isSuccess = random < 9;
      
      if (isSuccess) {
        return PaymentResponse(
          success: true,
          transactionId: 'sim_${DateTime.now().millisecondsSinceEpoch}',
          paymentId: DateTime.now().millisecondsSinceEpoch,
          amount: request.amount,
          paymentMethod: request.paymentMethod,
          createdAt: DateTime.now(),
        );
      } else {
        throw Exception('Payment declined by issuer');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error simulating payment: $e');
      }
      rethrow;
    }
  }
}
