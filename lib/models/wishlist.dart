import 'package:flutter_app/models/products.dart';

class Wishlists {
  final String id;
  final Products product;
  final String userId;
  final bool isLiked;
  final DateTime updated;
  final DateTime created;

  Wishlists({
    required this.id,
    required this.product,
    required this.userId,
    required this.isLiked,
    required this.updated,
    required this.created,
  });

  // Factory constructor để tạo Wishlists từ JSON
  factory Wishlists.fromJson(Map<String, dynamic> json) {
    return Wishlists(
      id: json['_id'] as String,
      product: Products.fromJson(json['product']),
      userId: json['user'] as String,
      isLiked: json['isLiked'] as bool,
      updated: DateTime.parse(json['updated']),
      created: DateTime.parse(json['created']),
    );
  }
}
