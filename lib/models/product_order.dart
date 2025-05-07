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
      purchasePrice: (json['purchasePrice'] as num?)?.toDouble() ?? 0.0, // Default to 0.0 if null
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0, // Default to 0.0 if null
      priceWithTax: (json['priceWithTax'] as num?)?.toDouble() ?? 0.0, // Default to 0.0 if null
      totalTax: (json['totalTax'] as num?)?.toDouble() ?? 0.0, // Default to 0.0 if null
      status: json['status'] ?? 'Unknown', // Default to 'Unknown' if null
      id: json['_id'] ?? '', // Default to empty string if null
      quantity: json['quantity'] ?? 0, // Default to 0 if null
      product: Products.fromJson(json['product'] ?? {}), // Default to empty map if null
    );
  }
}
