import 'package:intl/intl.dart';

extension CurrencyFormatter on double {
  String get toCurrency {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return formatter.format(this);
  }
}
