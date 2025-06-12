import 'package:flutter/foundation.dart';
import 'package:flutter_coffee_shop_app/models/api_models.dart';
import 'package:flutter_coffee_shop_app/services/dio_client.dart';
import 'package:dio/dio.dart';

class ReviewableProductsService {
  final DioClient _dioClient = DioClient();

  /// Fetches all products that the current user has purchased and can review
  Future<List<Product>> getReviewableProducts() async {
    try {
      final response = await _dioClient.dio.get('/reviews/reviewable-products');
      final List<dynamic> productsJson = response.data;
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Error fetching reviewable products: ${e.message}');
        print('Response data: ${e.response?.data}');
      }

      if (e.response?.statusCode == 401) {
        throw 'Vui lòng đăng nhập để xem sản phẩm có thể đánh giá';
      }

      // Return empty list for other errors to avoid crashing the UI
      return [];
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching reviewable products: $e');
      }
      return [];
    }
  }

  /// Checks if a user can review a specific product (has completed an order with this product)
  Future<bool> canReviewProduct(int productId) async {
    try {
      final response = await _dioClient.dio.get(
        '/reviews/can-review/$productId',
      );
      return response.data['canReview'] ?? false;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Error checking if user can review product: ${e.message}');
        print('Response data: ${e.response?.data}');
      }

      if (e.response?.statusCode == 401) {
        // User is not logged in
        return false;
      } else if (e.response?.statusCode == 404) {
        // Product not found
        return false;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking if user can review product: $e');
      }
      return false;
    }
  }
}
