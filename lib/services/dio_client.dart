import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'api_exception.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  factory DioClient() => _instance;

  // URL gốc dựa trên nền tảng
  String get baseUrl => Platform.isAndroid
      ? 'https://10.0.2.2:7273'
      : 'https://192.168.2.3:7273';

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: Platform.isAndroid
            ? 'https://10.0.2.2:7273/api'
            : 'https://192.168.2.3:7273/api',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Log request/response nếu đang debug
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }

    // Interceptor tự động gắn token và bắt lỗi
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Đọc token từ secure storage
          final token = await _secureStorage.read(key: 'auth_token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) {
          // Chuẩn hóa lỗi
          final apiException = ApiException.from(error);

          // Nếu lỗi 401 có thể xử lý logout/refresh token tại đây
          if (error.response?.statusCode == 401) {
            print('Authentication error: ${apiException.message}');
            // TODO: Thực hiện logout hoặc refresh token nếu cần
          }

          return handler.next(error);
        },
      ),
    );
  }
}
