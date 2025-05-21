import 'package:flutter/material.dart';

Color getStatusColor(String? status) {
  switch (status) {
    case 'Not processed':
      return const Color(0xFF9E9E9E);
    case 'Processing':
      return const Color(0xFF42A5F5);
    case 'Shipped':
      return const Color(0xFF3F51B5);
    case 'Delivered':
      return const Color(0xFF66BB6A);
    case 'Cancelled':
      return const Color(0xFFEF5350);
    default:
      return const Color(0xFFBDBDBD);
  }
}
