import 'package:flutter_app/models/product_order.dart';

class Orders {
  final String id;
  final double total;
  final DateTime created;
  final List<ProductOrder> products;
  final double totalTax;
  final double totalWithTax;

  Orders({
    required this.id,
    required this.total,
    required this.created,
    required this.products,
    required this.totalTax,
    required this.totalWithTax,
  });

  factory Orders.fromJson(Map<String, dynamic> json) {
    var productsList = json['products'] as List<dynamic>? ?? [];

    return Orders(
      id: json['_id'],
      total: (json['total'] as num? ?? 0).toDouble(),
      created: DateTime.parse(json['created']),
      products: productsList.map((e) => ProductOrder.fromJson(e as Map<String, dynamic>)).toList(),
      totalTax: (json['totalTax'] as num? ?? 0).toDouble(),
      totalWithTax: (json['totalWithTax'] as num? ?? 0).toDouble(),
    );
  }
}
