import 'package:flutter_app/models/product_order.dart';

class Orders {
  final String id;
  final double total;
  final DateTime created;
  final List<ProductOrder> products;
  final double totalTax;
  final double totalWithTax;
  final String cartId;

  Orders({
    required this.id,
    required this.total,
    required this.created,
    required this.products,
    required this.totalTax,
    required this.totalWithTax,
    required this.cartId,
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
      cartId: (json['cartId'] as String? ?? ""),
    );
  }

  Orders copyWith({
    String? id,
    double? total,
    DateTime? created,
    List<ProductOrder>? products,
    double? totalTax,
    double? totalWithTax,
    String? cartId,
  }) {
    return Orders(
      id: id ?? this.id,
      total: total ?? this.total,
      created: created ?? this.created,
      products: products ?? this.products,
      totalTax: totalTax ?? this.totalTax,
      totalWithTax: totalWithTax ?? this.totalWithTax,
      cartId: cartId ?? this.cartId,
    );
  }
}
