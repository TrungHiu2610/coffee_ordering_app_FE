// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentRequest _$PaymentRequestFromJson(Map<String, dynamic> json) =>
    PaymentRequest(
      orderId: (json['orderId'] as num).toInt(),
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String,
      currency: json['currency'] as String? ?? 'VND',
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$PaymentRequestToJson(PaymentRequest instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'amount': instance.amount,
      'paymentMethod': instance.paymentMethod,
      'currency': instance.currency,
      'metadata': instance.metadata,
    };

PaymentResponse _$PaymentResponseFromJson(Map<String, dynamic> json) =>
    PaymentResponse(
      success: json['success'] as bool,
      transactionId: json['transactionId'] as String,
      paymentId: (json['paymentId'] as num).toInt(),
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$PaymentResponseToJson(PaymentResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'transactionId': instance.transactionId,
      'paymentId': instance.paymentId,
      'amount': instance.amount,
      'paymentMethod': instance.paymentMethod,
      'createdAt': instance.createdAt.toIso8601String(),
      'errorMessage': instance.errorMessage,
    };

PaymentStatus _$PaymentStatusFromJson(Map<String, dynamic> json) =>
    PaymentStatus(
      paymentId: (json['paymentId'] as num).toInt(),
      status: json['status'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      gatewayReference: json['gatewayReference'] as String?,
    );

Map<String, dynamic> _$PaymentStatusToJson(PaymentStatus instance) =>
    <String, dynamic>{
      'paymentId': instance.paymentId,
      'status': instance.status,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'gatewayReference': instance.gatewayReference,
    };

PaymentQrRequest _$PaymentQrRequestFromJson(Map<String, dynamic> json) =>
    PaymentQrRequest(
      orderId: (json['orderId'] as num).toInt(),
      amount: (json['amount'] as num).toDouble(),
      provider: json['provider'] as String,
    );

Map<String, dynamic> _$PaymentQrRequestToJson(PaymentQrRequest instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'amount': instance.amount,
      'provider': instance.provider,
    };

RefundRequest _$RefundRequestFromJson(Map<String, dynamic> json) =>
    RefundRequest(
      paymentId: (json['paymentId'] as num).toInt(),
      amount: (json['amount'] as num).toDouble(),
      reason: json['reason'] as String,
    );

Map<String, dynamic> _$RefundRequestToJson(RefundRequest instance) =>
    <String, dynamic>{
      'paymentId': instance.paymentId,
      'amount': instance.amount,
      'reason': instance.reason,
    };

RefundResponse _$RefundResponseFromJson(Map<String, dynamic> json) =>
    RefundResponse(
      success: json['success'] as bool,
      refundId: json['refundId'] as String,
      paymentId: (json['paymentId'] as num).toInt(),
      amount: (json['amount'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$RefundResponseToJson(RefundResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'refundId': instance.refundId,
      'paymentId': instance.paymentId,
      'amount': instance.amount,
      'createdAt': instance.createdAt.toIso8601String(),
      'errorMessage': instance.errorMessage,
    };
