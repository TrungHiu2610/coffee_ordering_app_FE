import 'package:json_annotation/json_annotation.dart';

part 'payment_model.g.dart';

@JsonSerializable()
class PaymentRequest {
  final int orderId;
  final double amount;
  final String paymentMethod;
  final String currency;
  final Map<String, dynamic>? metadata;
  
  PaymentRequest({
    required this.orderId,
    required this.amount,
    required this.paymentMethod,
    this.currency = 'VND',
    this.metadata,
  });
  
  factory PaymentRequest.fromJson(Map<String, dynamic> json) => 
      _$PaymentRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentRequestToJson(this);
}

@JsonSerializable()
class PaymentResponse {
  final bool success;
  final String transactionId;
  final int paymentId;
  final double amount;
  final String paymentMethod;
  final DateTime createdAt;
  final String? errorMessage;
  
  PaymentResponse({
    required this.success,
    required this.transactionId,
    required this.paymentId,
    required this.amount,
    required this.paymentMethod,
    required this.createdAt,
    this.errorMessage,
  });
  
  factory PaymentResponse.fromJson(Map<String, dynamic> json) => 
      _$PaymentResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentResponseToJson(this);
}

@JsonSerializable()
class PaymentStatus {
  final int paymentId;
  final String status;
  final DateTime updatedAt;
  final String? gatewayReference;
  
  PaymentStatus({
    required this.paymentId,
    required this.status,
    required this.updatedAt,
    this.gatewayReference,
  });
  
  factory PaymentStatus.fromJson(Map<String, dynamic> json) => 
      _$PaymentStatusFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentStatusToJson(this);
}

@JsonSerializable()
class PaymentQrRequest {
  final int orderId;
  final double amount;
  final String provider; // 'momo', 'zalopay', 'vnpay', etc.
  
  PaymentQrRequest({
    required this.orderId,
    required this.amount,
    required this.provider,
  });
  
  factory PaymentQrRequest.fromJson(Map<String, dynamic> json) => 
      _$PaymentQrRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentQrRequestToJson(this);
}

@JsonSerializable()
class RefundRequest {
  final int paymentId;
  final double amount;
  final String reason;
  
  RefundRequest({
    required this.paymentId,
    required this.amount,
    required this.reason,
  });
  
  factory RefundRequest.fromJson(Map<String, dynamic> json) => 
      _$RefundRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RefundRequestToJson(this);
}

@JsonSerializable()
class RefundResponse {
  final bool success;
  final String refundId;
  final int paymentId;
  final double amount;
  final DateTime createdAt;
  final String? errorMessage;
  
  RefundResponse({
    required this.success,
    required this.refundId,
    required this.paymentId,
    required this.amount,
    required this.createdAt,
    this.errorMessage,
  });
  
  factory RefundResponse.fromJson(Map<String, dynamic> json) => 
      _$RefundResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RefundResponseToJson(this);
}
