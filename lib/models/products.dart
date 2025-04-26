import 'package:flutter_app/models/Brands.dart';

class Products {
  final String id;
  final bool taxable;
  final bool isActive;
  final Brand brand;
  final String sku;
  final String name;
  final String description;
  final int quantity;
  final num price;
  final String imageUrl;
  final String imageKey;
  final DateTime created;
  final String slug;
  final int v;
  final int totalRatings;
  final int totalReviews;
  final num averageRating;

  Products({
    required this.id,
    required this.taxable,
    required this.isActive,
    required this.brand,
    required this.sku,
    required this.name,
    required this.description,
    required this.quantity,
    required this.price,
    required this.imageUrl,
    required this.imageKey,
    required this.created,
    required this.slug,
    required this.v,
    required this.totalRatings,
    required this.totalReviews,
    required this.averageRating,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json['_id'] as String,
      taxable: json['taxable'] as bool,
      isActive: json['isActive'] as bool,
      brand: Brand.fromJson(json['brand']),
      sku: json['sku'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      quantity: json['quantity'] as int,
      price: json['price'] as num,
      imageUrl: json['imageUrl'] as String,
      imageKey: json['imageKey'] as String,
      created: DateTime.parse(json['created'] as String),
      slug: json['slug'] as String,
      v: json['__v'] as int,
      totalRatings: json['totalRatings'] as int,
      totalReviews: json['totalReviews'] as int,
      averageRating: json['averageRating'] as num,
    );
  }
}
