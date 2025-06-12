import 'package:flutter/foundation.dart';
import 'package:flutter_coffee_shop_app/models/api_models.dart';
import 'package:flutter_coffee_shop_app/services/auth_service.dart';

class LoyaltyProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  bool _isLoading = false;
  String? _error;
  
  bool get isLoading => _isLoading;
  String? get error => _error;

  static const Map<String, int> benefitThresholds = {
    'discount10': 100,     // 10% discount
    'freeDrink': 200,      // Free drink
    'silverMember': 500,   // Silver membership
    'goldMember': 1000,    // Gold membership
  };

  double calculatePointsFromPurchase(double amount) {
    // 1 point for every 1,000 VND spent
    return amount / 1000;
  }
  
  // Check if the user qualifies for a specific benefit
  bool userQualifiesForBenefit(User user, String benefitKey) {
    final threshold = benefitThresholds[benefitKey];
    if (threshold == null) return false;
    
    return user.totalPoints >= threshold;
  }

  List<String> getAvailableBenefits(User user) {
    final benefits = <String>[];
    
    benefitThresholds.forEach((key, threshold) {
      if (user.totalPoints >= threshold) {
        benefits.add(key);
      }
    });
    
    return benefits;
  }

  double applyLoyaltyDiscount(double totalAmount, User user) {
    if (userQualifiesForBenefit(user, 'discount10')) {
      // 10% discount
      return totalAmount * 0.9;
    }
    return totalAmount;
  }

  bool canRedeemFreeDrink(User user) {
    return userQualifiesForBenefit(user, 'freeDrink');
  }

  Future<void> addPointsToUser(double points) async {
    _setLoading(true);
    
    try {
      final user = await _authService.getCurrentUser();
      if (user != null) {
        user.totalPoints += points/100;
        await _authService.updateUserPoints(user.id, user.totalPoints);
      }
      
      _setLoading(false);
    } catch (e) {
      _setError('Failed to add points: $e');
    }
  }
  
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  
  void _setError(String error) {
    _error = error;
    _isLoading = false;
    notifyListeners();
  }
}
