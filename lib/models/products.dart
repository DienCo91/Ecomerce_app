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
  bool? isLiked;

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
    this.isLiked = false,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
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
      isLiked: json['isLiked'] ?? false,
    );
  }
}

extension ProductCopy on Products {
  Products copyWith({int? quantity, num? price}) {
    return Products(
      id: id,
      taxable: taxable,
      isActive: isActive,
      brand: brand,
      sku: sku,
      name: name,
      description: description,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      imageUrl: imageUrl,
      imageKey: imageKey,
      created: created,
      slug: slug,
      v: v,
      totalRatings: totalRatings,
      totalReviews: totalReviews,
      averageRating: averageRating,
      isLiked: isLiked,
    );
  }
}
