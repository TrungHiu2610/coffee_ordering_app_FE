import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/review_model.dart';
import '../models/review_dto.dart';
import 'dio_client.dart';
import 'package:dio/dio.dart';

class ReviewService {
  final DioClient _dioClient = DioClient();

  Future<List<Review>> getProductReviews(int productId) async {
    try {
      final response = await _dioClient.dio.get('/Reviews/Product/$productId');
      final List<dynamic> reviewsJson = response.data;
      return reviewsJson.map((json) => Review.fromJson(json)).toList();
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Error getting product reviews: ${e.message}');
        print('Response data: ${e.response?.data}');
      }

      if (e.response?.statusCode == 404) {
        // Return empty reviews if product not found
        return [];
      }

      throw 'Không thể tải đánh giá. Vui lòng thử lại sau.';
    } catch (e) {
      if (kDebugMode) {
        print('Error getting product reviews: $e');
      }
      throw 'Đã xảy ra lỗi: $e';
    }
  }
  Future<Review> createReview(CreateReviewRequest request) async {
    try {
      // Convert the CreateReviewRequest to ReviewCreateDto
      final reviewDto = ReviewCreateDto(
        productId: request.productId,
        userId: request.userId,
        // Convert float rating to integer
        rating: request.rating.round(),
        // Map comment to review field as expected by API
        review: request.comment,
      );

      final response = await _dioClient.dio.post(
        '/reviews',
        data: jsonEncode(reviewDto.toJson()),
      );
      return Review.fromJson(response.data);
    } on DioException catch (e) {
      if (kDebugMode) {
        // print('Error creating review: ${e.message}');
        // print('Response data: ${e.response?.data}');
      }

      if (e.response?.statusCode == 400) {
        throw 'Thông tin đánh giá không hợp lệ: ${e.response?.data['message'] ?? 'Vui lòng kiểm tra lại'}';
      } else if (e.response?.statusCode == 401) {
        throw 'Vui lòng đăng nhập để gửi đánh giá';
      } else if (e.response?.statusCode == 403) {
        throw 'Bạn chỉ có thể đánh giá sản phẩm mà bạn đã mua';
      }

      throw 'Không thể gửi đánh giá. Vui lòng thử lại sau.';
    }
  }

  Future<List<Review>> getUserReviews(int userId) async {
    try {
      final response = await _dioClient.dio.get('/Reviews/User/$userId');
      final List<dynamic> reviewsJson = response.data;
      return reviewsJson.map((json) => Review.fromJson(json)).toList();
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Error getting user reviews: ${e.message}');
        print('Response data: ${e.response?.data}');
      }

      if (e.response?.statusCode == 401) {
        throw 'Vui lòng đăng nhập để xem đánh giá của bạn';
      }

      throw 'Không thể tải đánh giá. Vui lòng thử lại sau.';
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user reviews: $e');
      }
      throw 'Đã xảy ra lỗi: $e';
    }
  }
  Future<void> updateReview(int reviewId, CreateReviewRequest request) async {
    try {
      // Convert the CreateReviewRequest to ReviewCreateDto
      final reviewDto = ReviewCreateDto(
        productId: request.productId,
        userId: request.userId,
        // Convert float rating to integer
        rating: request.rating.round(),
        // Map comment to review field as expected by API
        review: request.comment,
      );

      await _dioClient.dio.put(
        '/Reviews/$reviewId',
        data: jsonEncode(reviewDto.toJson()),
      );
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Error updating review: ${e.message}');
        print('Response data: ${e.response?.data}');
      }

      if (e.response?.statusCode == 400) {
        throw 'Thông tin đánh giá không hợp lệ: ${e.response?.data['message'] ?? 'Vui lòng kiểm tra lại'}';
      } else if (e.response?.statusCode == 401) {
        throw 'Vui lòng đăng nhập để cập nhật đánh giá';
      } else if (e.response?.statusCode == 404) {
        throw 'Không tìm thấy đánh giá để cập nhật';
      } else if (e.response?.statusCode == 403) {
        throw 'Bạn chỉ có thể cập nhật đánh giá của chính mình';
      }

      throw 'Không thể cập nhật đánh giá. Vui lòng thử lại sau.';
    } catch (e) {
      if (kDebugMode) {
        print('Error updating review: $e');
      }
      throw 'Đã xảy ra lỗi: $e';
    }
  }

  Future<void> deleteReview(int reviewId) async {
    try {
      await _dioClient.dio.delete('/reviews/$reviewId');
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Error deleting review: ${e.message}');
        print('Response data: ${e.response?.data}');
      }

      if (e.response?.statusCode == 401) {
        throw 'Vui lòng đăng nhập để xóa đánh giá';
      } else if (e.response?.statusCode == 404) {
        throw 'Không tìm thấy đánh giá để xóa';
      } else if (e.response?.statusCode == 403) {
        throw 'Bạn chỉ có thể xóa đánh giá của chính mình';
      }

      throw 'Không thể xóa đánh giá. Vui lòng thử lại sau.';
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting review: $e');
      }
      throw 'Đã xảy ra lỗi: $e';
    }
  }
}
