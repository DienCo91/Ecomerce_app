import 'package:flutter/material.dart';
import 'product_model.dart';
import 'product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _service = ProductService();

  List<Product> _products = [];
  List<Product> get products => _products;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    _products = await _service.fetchProducts();

    _isLoading = false;
    notifyListeners();
  }
}
