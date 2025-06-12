import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/api_models.dart';
import 'api_client.dart';
import 'dio_client.dart';

class AuthService {
  final ApiClient _apiClient;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  AuthService() : _apiClient = ApiClient(DioClient().dio);

  Future<User?> login(String email, String password) async {
    try {
      final loginDto = LoginDto(email: email, password: password);
      final response = await _apiClient.login(loginDto);
      
      // Save token in secure storage
      await _secureStorage.write(key: 'auth_token', value: response.token);
      
      // Save user info in shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', response.user.id);
      await prefs.setString('userName', response.user.name);
      await prefs.setString('userEmail', response.user.email);
      await prefs.setString('userRole', response.user.role);
      
      return response.user;
    }
    catch (e) {
      print('Login error: $e');
      throw Exception('Email hoặc mật khẩu không đúng');
    }
  }

  Future<User?> register(String name, String email, String password) async {
    try {
      final registerDto = RegisterDto(name: name, email: email, password: password);
      final response = await _apiClient.register(registerDto);
      
      // Save token in secure storage
      await _secureStorage.write(key: 'auth_token', value: response.token);
      
      // Save user info in shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', response.user.id);
      await prefs.setString('userName', response.user.name);
      await prefs.setString('userEmail', response.user.email);
      await prefs.setString('userRole', response.user.role);
      
      return response.user;
    } catch (e) {
      print('Registration error: $e');
      return null;
    }
  }

  Future<void> logout() async {
    // Clear token
    await _secureStorage.delete(key: 'auth_token');
    
    // Clear user info
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userName');
    await prefs.remove('userEmail');
    await prefs.remove('userRole');
  }

  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    
    if (userId == null) {
      return null;
    }
    
    try {
      return await _apiClient.getUser(userId);
    } catch (e) {
      print('Get current user error: $e');
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _secureStorage.read(key: 'auth_token');
    return token != null;
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }
  
  Future<bool> updateUserPoints(int userId, double points) async {
    try {
      // Update the user locally
      final user = await getCurrentUser();
      if (user != null) {
        user.totalPoints = points;
        await _apiClient.updateUserPoint(user.id, points);
        return true;
      }
      return false;
    } catch (e) {
      print('Update user points error: $e');
      return false;
    }
  }
}
