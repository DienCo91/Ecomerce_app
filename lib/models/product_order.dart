import 'package:flutter_app/models/products.dart';

class ProductOrder {
  final double purchasePrice;
  final double totalPrice;
  final double priceWithTax;
  final double totalTax;
  final String status;
  final String id;
  final int quantity;
  final Products product;

  ProductOrder({
    required this.purchasePrice,
    required this.totalPrice,
    required this.priceWithTax,
    required this.totalTax,
    required this.status,
    required this.id,
    required this.quantity,
    required this.product,
  });

  factory ProductOrder.fromJson(Map<String, dynamic> json) {
    return ProductOrder(
      purchasePrice: (json['purchasePrice'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      priceWithTax: (json['priceWithTax'] as num?)?.toDouble() ?? 0.0,
      totalTax: (json['totalTax'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'Unknown',
      id: json['_id'] ?? '',
      quantity: json['quantity'] ?? 0,
      product: Products.fromJson(json['product'] ?? {}),
    );
  }

  ProductOrder copyWith({
    double? purchasePrice,
    double? totalPrice,
    double? priceWithTax,
    double? totalTax,
    String? status,
    String? id,
    int? quantity,
    Products? product,
  }) {
    return ProductOrder(
      purchasePrice: purchasePrice ?? this.purchasePrice,
      totalPrice: totalPrice ?? this.totalPrice,
      priceWithTax: priceWithTax ?? this.priceWithTax,
      totalTax: totalTax ?? this.totalTax,
      status: status ?? this.status,
      id: id ?? this.id,
      quantity: quantity ?? this.quantity,
      product: product ?? this.product,
    );
  }
}
