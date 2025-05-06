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
      purchasePrice: (json['purchasePrice'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      priceWithTax: (json['priceWithTax'] as num).toDouble(),
      totalTax: (json['totalTax'] as num).toDouble(),
      status: json['status'],
      id: json['_id'],
      quantity: json['quantity'],
      product: Products.fromJson(json['product']),
    );
  }
}
