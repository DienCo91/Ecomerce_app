import 'package:flutter_app/models/products.dart';

class ProductResponse {
  final int count;
  final int currentPage;
  final List<Products> products;
  final int totalPages;

  ProductResponse({
    required this.count,
    required this.currentPage,
    required this.products,
    required this.totalPages,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    var productList = json['products'] as List;
    List<Products> productItems =
        productList.map((item) => Products.fromJson(item)).toList();

    return ProductResponse(
      count: json['count'],
      currentPage: json['currentPage'],
      products: productItems,
      totalPages: json['totalPages'],
    );
  }
}
