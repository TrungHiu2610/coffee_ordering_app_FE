import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dio_client.dart';

class FileService {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  FileService() : _dio = DioClient().dio;

  Future<String?> uploadImage(File imageFile) async {
    try {
      // Get the token
      final token = await _secureStorage.read(key: 'auth_token');
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      // Create form data
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      // Set the headers with authentication token
      final options = Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        },
      );

      // Upload the image
      final response = await _dio.post(
        '/Images/upload',
        data: formData,
        options: options,
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data['imageUrl'];
      } else {
        throw Exception('Failed to upload image: ${response.statusMessage}');
      }
    } catch (e) {
      print('Upload image error: $e');
      return null;
    }
  }

  Future<bool> deleteImage(String fileName) async {
    try {
      // Get the token
      final token = await _secureStorage.read(key: 'auth_token');
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      // Set the headers with authentication token
      final options = Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      // Delete the image
      final response = await _dio.delete(
        '/Images/$fileName',
        options: options,
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Delete image error: $e');
      return false;
    }
  }
}
