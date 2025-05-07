import 'package:flutter/material.dart';

Color getStatusColor(String? status) {
  switch (status) {
    case 'Not processed':
      return const Color(0xFF9E9E9E); // Grey 500
    case 'Processing':
      return const Color(0xFF42A5F5); // Blue 400
    case 'Shipped':
      return const Color(0xFF3F51B5); // Indigo 500
    case 'Delivered':
      return const Color(0xFF66BB6A); // Green 400
    case 'Cancelled':
      return const Color(0xFFEF5350); // Red 400
    default:
      return const Color(0xFFBDBDBD); // Grey 400
  }
}
