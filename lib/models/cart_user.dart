import 'package:flutter_app/models/Brands.dart';
import 'package:flutter_app/models/products.dart';

class CartUser {
  final String userId;
  final List<Products> cart;

  CartUser({required this.userId, required this.cart});

  Map<String, dynamic> toJson() => {'userId': userId, 'cart': cart.map((p) => _productToJson(p)).toList()};

  factory CartUser.fromJson(Map<String, dynamic> json) {
    return CartUser(
      userId: json['userId'],
      cart: (json['cart'] as List).map((item) => _productFromJson(item)).toList(),
    );
  }

  static Map<String, dynamic> _productToJson(Products p) => {
    '_id': p.id,
    'taxable': p.taxable,
    'isActive': p.isActive,
    'brand': {'id': p.brand.id, 'name': p.brand.name, 'isActive': p.brand.isActive},
    'sku': p.sku,
    'name': p.name,
    'description': p.description,
    'quantity': p.quantity,
    'price': p.price,
    'imageUrl': p.imageUrl,
    'imageKey': p.imageKey,
    'created': p.created.toIso8601String(),
    'slug': p.slug,
    '__v': p.v,
    'totalRatings': p.totalRatings,
    'totalReviews': p.totalReviews,
    'averageRating': p.averageRating,
  };

  static Products _productFromJson(Map<String, dynamic> json) => Products(
    id: json['_id'] as String? ?? '',
    taxable: json['taxable'] as bool? ?? false,
    isActive: json['isActive'] as bool? ?? false,
    brand: json['brand'] != null ? Brand.fromJson(json['brand']) : Brand(id: '', name: '', isActive: false),
    sku: json['sku'] as String? ?? '',
    name: json['name'] as String? ?? '',
    description: json['description'] as String? ?? '',
    quantity: json['quantity'] as int? ?? 0,
    price: json['price'] as num? ?? 0,
    imageUrl: json['imageUrl'] as String? ?? '',
    imageKey: json['imageKey'] as String? ?? '',
    created: DateTime.parse(json['created'] as String? ?? DateTime.now().toString()),
    slug: json['slug'] as String? ?? '',
    v: json['__v'] as int? ?? 0,
    totalRatings: json['totalRatings'] as int? ?? 0,
    totalReviews: json['totalReviews'] as int? ?? 0,
    averageRating: json['averageRating'] as num? ?? 0,
  );
}
