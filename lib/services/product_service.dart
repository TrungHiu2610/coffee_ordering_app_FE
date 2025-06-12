import '../models/api_models.dart';
import 'api_client.dart';
import 'dio_client.dart';

class ProductService {
  final ApiClient _apiClient;

  ProductService() : _apiClient = ApiClient(DioClient().dio);

  Future<List<Category>> getCategories() async {
    try {
      return await _apiClient.getCategories();
    } catch (e) {
      print('Get categories error: $e');
      return [];
    }
  }

  Future<List<Product>> getProducts() async {
    try {
      return await _apiClient.getProducts();
    } catch (e) {
      print('Get products error: $e');
      return [];
    }
  }

  Future<Product?> getProduct(int id) async {
    try {
      return await _apiClient.getProduct(id);
    } catch (e) {
      print('Get product error: $e');
      return null;
    }
  }

  Future<List<Product>> getProductsByCategory(int categoryId) async {
    try {
      return await _apiClient.getProductsByCategory(categoryId);
    } catch (e) {
      print('Get products by category error: $e');
      return [];
    }
  }

  Future<List<Review>> getProductReviews(int productId) async {
    try {
      return await _apiClient.getReviewsByProduct(productId);
    } catch (e) {
      print('Get product reviews error: $e');
      return [];
    }
  }

  Future<Review?> addReview(int userId, int productId, int rating, String comment) async {
    try {
      final review = Review(
        id: 0, // Will be set by the server
        userId: userId,
        productId: productId,
        rating: rating,
        comment: comment,
        createdAt: DateTime.now(),
      );
      
      return await _apiClient.createReview(review);
    } catch (e) {
      print('Add review error: $e');
      return null;
    }
  }
}
