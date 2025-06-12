import 'dart:io';
import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? statusMessage;

  ApiException({
    required this.message,
    this.statusCode,
    this.statusMessage,
  });

  @override
  String toString() {
    return 'ApiException: $message (Status: $statusCode $statusMessage)';
  }

  static ApiException from(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is SocketException) {
      return ApiException(
        message: 'No internet connection',
        statusCode: null,
        statusMessage: 'SocketException',
      );
    } else if (error is FormatException) {
      return ApiException(
        message: 'Invalid response format',
        statusCode: null,
        statusMessage: 'FormatException',
      );
    } else {
      return ApiException(
        message: 'Unexpected error occurred: ${error.toString()}',
        statusCode: null,
        statusMessage: null,
      );
    }
  }

  static ApiException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException(
          message: 'Connection timeout',
          statusCode: error.response?.statusCode,
          statusMessage: 'ConnectionTimeout',
        );
      case DioExceptionType.sendTimeout:
        return ApiException(
          message: 'Send timeout',
          statusCode: error.response?.statusCode,
          statusMessage: 'SendTimeout',
        );
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Receive timeout',
          statusCode: error.response?.statusCode,
          statusMessage: 'ReceiveTimeout',
        );
      case DioExceptionType.badCertificate:
        return ApiException(
          message: 'Bad certificate',
          statusCode: error.response?.statusCode,
          statusMessage: 'BadCertificate',
        );
      case DioExceptionType.badResponse:
        return _handleBadResponse(error);
      case DioExceptionType.cancel:
        return ApiException(
          message: 'Request cancelled',
          statusCode: error.response?.statusCode,
          statusMessage: 'RequestCancelled',
        );
      case DioExceptionType.connectionError:
        return ApiException(
          message: 'Connection error',
          statusCode: error.response?.statusCode,
          statusMessage: 'ConnectionError',
        );
      case DioExceptionType.unknown:
      default:
        return ApiException(
          message: error.message ?? 'Unknown error occurred',
          statusCode: error.response?.statusCode,
          statusMessage: error.message,
        );
    }
  }

  static ApiException _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    String message;

    switch (statusCode) {
      case 400:
        message = 'Bad request';
        if (error.response?.data is Map) {
          final data = error.response?.data as Map;
          if (data.containsKey('message')) {
            message = data['message'];
          } else if (data.containsKey('error')) {
            message = data['error'];
          }
        }
        break;
      case 401:
        message = 'Unauthorized';
        break;
      case 403:
        message = 'Forbidden';
        break;
      case 404:
        message = 'Not found';
        break;
      case 409:
        message = 'Conflict';
        break;
      case 500:
        message = 'Server error';
        break;
      default:
        message = 'Something went wrong';
    }

    return ApiException(
      message: message,
      statusCode: statusCode,
      statusMessage: error.response?.statusMessage,
    );
  }
}
