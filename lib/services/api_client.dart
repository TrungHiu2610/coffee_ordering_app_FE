import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/api_models.dart';
import '../models/auth_response_dto.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: "")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;
  
  // Categories
  @GET("/Categories")
  Future<List<Category>> getCategories();
  
  @GET("/Categories/{id}")
  Future<Category> getCategory(@Path() int id);

  // Products
  @GET("/Products")
  Future<List<Product>> getProducts();
  
  @GET("/Products/{id}")
  Future<Product> getProduct(@Path() int id);
  
  @GET("/Products/Category/{categoryId}")
  Future<List<Product>> getProductsByCategory(@Path() int categoryId);
  
  // Users
  @POST("/Users/register")
  Future<AuthResponseDto> register(@Body() RegisterDto registerDto);
  
  @POST("/Users/login")
  Future<AuthResponseDto> login(@Body() LoginDto loginDto);
  
  @GET("/Users/{id}")
  Future<User> getUser(@Path() int id);

  @PUT("/Users/UpdatePoint/{id}")
  Future<void> updateUserPoint(@Path() int id, double points);
  
  // Orders
  @GET("/Orders")
  Future<List<Order>> getOrders();
  
  @GET("/Orders/{id}")
  Future<Order> getOrder(@Path() int id);
  
  @GET("/Orders/User/{userId}")
  Future<List<Order>> getOrdersByUser(@Path() int userId);
  @POST("/Orders")
  Future<Order> createOrder(@Body() OrderCreateDto orderDto);
  
  @POST("/Orders/{id}/confirm-payment")
  Future<void> confirmPayment(@Path() int id);
  
  @PUT("/Orders/{id}/status")
  Future<void> updateOrderStatus(@Path() int id, @Body() Map<String, String> statusDto);
  
  // Reviews
  @GET("/Reviews")
  Future<List<Review>> getReviews();
  
  @GET("/Reviews/{id}")
  Future<Review> getReview(@Path() int id);
  
  @GET("/Reviews/Product/{productId}")
  Future<List<Review>> getReviewsByProduct(@Path() int productId);

  
  @POST("/Reviews")
  Future<Review> createReview(@Body() Review review);

  //Tables
  @GET("/Tables")
  Future<List<Table>> getTables();

  @GET("/Tables/{tableNumber}")
  Future<Table> getTableByNumber(@Path() int tableNumber);

  @POST("/Tables/occupyTable/{tableNumber}")
  Future<Table> occupyTable(@Path() int tableNumber);

  @POST("/Tables/releaseTable/{tableNumber}")
  Future<Table> releaseTable(@Path() int tableNumber);
}
