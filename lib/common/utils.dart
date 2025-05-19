import 'package:intl/intl.dart';

String calculateAmount(String amount) {
  final total = (int.parse(amount)) * 100;
  return total.toString();
}

String formatCurrency(double amount) {
  final formatCurrency = NumberFormat.simpleCurrency(locale: 'en_US');
  return formatCurrency.format(amount);
}
