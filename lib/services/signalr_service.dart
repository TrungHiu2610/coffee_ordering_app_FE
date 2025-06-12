import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/io_client.dart';
import 'package:signalr_netcore/signalr_client.dart';
import '../models/api_models.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:logging/logging.dart';

// Simple function-based logger for SignalR
void signalRLogger(String message) {
  if (kDebugMode) {
    print('[SignalR] $message');
  }
}

class SignalRService {
  static final SignalRService _instance = SignalRService._internal();
  factory SignalRService() => _instance;
  SignalRService._internal();

  HubConnection? _hubConnection;
  bool _isConnected = false;
  
  final StreamController<OrderStatusUpdate> _orderStatusController = 
      StreamController<OrderStatusUpdate>.broadcast();
  
  final StreamController<int> _paymentConfirmedController = 
      StreamController<int>.broadcast();
  
  final StreamController<Order> _newOrderController = 
      StreamController<Order>.broadcast();

  Stream<OrderStatusUpdate> get orderStatusUpdates => _orderStatusController.stream;
  Stream<int> get paymentConfirmations => _paymentConfirmedController.stream;
  Stream<Order> get newOrders => _newOrderController.stream;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  Future<void> initialize(String baseUrl) async {
    try {
      final token = await _secureStorage.read(key: 'auth_token');
      final options = HttpConnectionOptions(
        accessTokenFactory: () async => token ?? '',
        transport: HttpTransportType.WebSockets,
        skipNegotiation: true,
      );

      _hubConnection = HubConnectionBuilder()
          .withUrl('$baseUrl/orderHub', options: options)
          .withAutomaticReconnect()
          .build();

      // Set up event handlers
      _hubConnection!.on('OrderStatusChanged', _handleOrderStatusChanged);
      _hubConnection!.on('PaymentConfirmed', _handlePaymentConfirmed);
      _hubConnection!.on('NewOrder', _handleNewOrder);

      // Try to connect
      await connect();
      
      if (kDebugMode) {
        print('SignalR service initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing SignalR: $e');
      }
    }
  }
    Future<void> connect() async {
    if (_hubConnection == null) return;

    // Kiểm tra trạng thái thực tế của connection
    if (_hubConnection!.state == HubConnectionState.Connected ||
        _hubConnection!.state == HubConnectionState.Connecting ||
        _hubConnection!.state == HubConnectionState.Reconnecting) {
      return;
    }

    try {
      await _hubConnection!.start();
      _isConnected = true;
      if (kDebugMode) {
        print('SignalR Connected');
      }
    } catch (e) {
      _isConnected = false;
      if (kDebugMode) {
        print('Error connecting to SignalR: $e');
      }
      // Try to reconnect after delay
      await Future.delayed(const Duration(seconds: 5));
      await connect();
    }
  }
    // Ensure the SignalR connection is established
  Future<void> ensureConnected() async {
    if (_hubConnection == null) return;
    
    try {
      if (!_isConnected || _hubConnection!.state != HubConnectionState.Connected) {
        if (kDebugMode) {
          print('SignalR reconnecting... Current state: ${_hubConnection!.state}');
        }
        
        // Only start connection if it's in Disconnected state
        if (_hubConnection!.state == HubConnectionState.Disconnected) {
          _isConnected = false;
          await connect();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in ensureConnected: $e');
      }
    }
  }
  void _handleOrderStatusChanged(List<Object?>? args) {
    if (args == null || args.length < 2) return;
    
    try {
      final newOrderId = args[0] as int;
      final newStatus = args[1] as String;
      
      _orderStatusController.add(OrderStatusUpdate(
        orderId: newOrderId,
        status: newStatus,
      ));
      
      if (kDebugMode) {
        print('Order $newOrderId status changed to $newStatus');
      }
      final orderId = args[0] as int;
      final status = args[1] as String;
      
      _orderStatusController.add(
        OrderStatusUpdate(orderId: orderId, status: status),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error handling order status update: $e');
      }
    }
  }

  void _handlePaymentConfirmed(List<Object?>? args) {
    if (args == null || args.isEmpty) return;
    
    try {
      final orderId = args[0] as int;
      _paymentConfirmedController.add(orderId);
    } catch (e) {
      if (kDebugMode) {
        print('Error handling payment confirmation: $e');
      }
    }
  }  void _handleNewOrder(List<Object?>? args) {
    print('[SignalR] _handleNewOrder called with args: $args');
    if (args == null || args.isEmpty) return;
    
    try {
      final orderMap = args[0] as Map<String, dynamic>;
      print('[SignalR] OrderMap: $orderMap');
      
      // Extract minimum required fields with safe conversion
      final orderId = orderMap['id'] as int;
      final status = orderMap['status'] as String;
      final createdAt = DateTime.parse(orderMap['createdAt'] as String);
      final paymentMethod = orderMap['paymentMethod'] as String;
      final isPaid = orderMap['isPaid'] as bool;
      final userId = orderMap['userId'] as int;
      
      // Handle totalAmount safely - could be int or double
      double? totalAmount;
      if (orderMap['totalAmount'] != null) {
        if (orderMap['totalAmount'] is int) {
          totalAmount = (orderMap['totalAmount'] as int).toDouble();
          print('[SignalR] Converting totalAmount from int: ${orderMap['totalAmount']} to double: $totalAmount');
        } else if (orderMap['totalAmount'] is double) {
          totalAmount = orderMap['totalAmount'] as double;
          print('[SignalR] totalAmount is already double: $totalAmount');
        } else {
          // Try parsing as string if it's neither int nor double
          try {
            totalAmount = double.parse(orderMap['totalAmount'].toString());
            print('[SignalR] Parsed totalAmount from string: ${orderMap['totalAmount']} to double: $totalAmount');
          } catch (e) {
            print('[SignalR] Could not parse totalAmount: ${orderMap['totalAmount']}, Error: $e');
            totalAmount = 0.0;
          }
        }
      }
        print('[SignalR] Creating Order with totalAmount: $totalAmount (${totalAmount.runtimeType})');
      
      // Create a minimum viable Order object using our minimal constructor
      final order = Order.minimal(
        id: orderId,
        createdAt: createdAt,
        status: status,
        paymentMethod: paymentMethod,
        isPaid: isPaid,
        userId: userId,
        totalAmount: totalAmount,
      );
      
      // Add the order to the stream
      _newOrderController.add(order);
    } catch (e) {
      if (kDebugMode) {
        print('Error handling new order: $e');
      }
    }
  }

  Future<void> joinOrderGroup(int orderId) async {
    if (!_isConnected || _hubConnection == null) await connect();
    
    try {
      await _hubConnection!.invoke('JoinOrderGroup', args: [orderId.toString()]);
      if (kDebugMode) {
        print('Joined order group for order $orderId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error joining order group: $e');
      }
    }
  }
  Future<void> joinStaffGroup() async {
    if (!_isConnected || _hubConnection == null) {
      if (kDebugMode) {
        print('Not connected - trying to connect before joining staff group');
      }
      await ensureConnected();
    }
    
    try {
      if (kDebugMode) {
        print('Joining staff group...');
      }
      await _hubConnection!.invoke('JoinStaffGroup');
      if (kDebugMode) {
        print('Successfully joined staff group');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error joining staff group: $e');
      }
      // Try to reconnect and join again
      await Future.delayed(const Duration(seconds: 2));
      await ensureConnected();
      await _hubConnection!.invoke('JoinStaffGroup');
    }
  }

  Future<void> disconnect() async {
    if (_hubConnection != null) {
      await _hubConnection!.stop();
      _isConnected = false;
    }
  }

  void dispose() {
    disconnect();
    _orderStatusController.close();
    _paymentConfirmedController.close();
    _newOrderController.close();
  }
}

class OrderStatusUpdate {
  final int orderId;
  final String status;

  OrderStatusUpdate({required this.orderId, required this.status});
}
