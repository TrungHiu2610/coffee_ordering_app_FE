import '../models/models.dart';

extension CartItemExt on CartItem {
  double get totalPrice {
    final basePrice = product?.price ?? 0;
    final sizeExtra = productSize?.additionalPrice ?? 0;
    final toppingTotal = toppings.fold(0.0, (sum, t) => sum + t.price);
    return (basePrice + sizeExtra + toppingTotal) * quantity;
  }
}
