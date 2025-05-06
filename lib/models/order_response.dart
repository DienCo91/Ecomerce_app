import 'package:flutter_app/models/orders.dart';

class OrderResponse {
  final List<Orders> orders;
  final int totalPages;
  final int currentPage;
  final int count;

  OrderResponse({required this.orders, required this.totalPages, required this.currentPage, required this.count});

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      orders: (json['orders'] as List<dynamic>).map((e) => Orders.fromJson(e)).toList(),
      totalPages: json['totalPages'],
      currentPage: json['currentPage'],
      count: json['count'],
    );
  }
}
