import 'package:flutter_app/models/products.dart';
import 'package:get/get.dart';

class ProductManagerController extends GetxController {
  final products = <Products>[].obs;

  void setProductsManage(List<Products> p) {
    products.value = p;
  }

  void addProduct(Products product) {
    products.insert(0, product);
  }

  void updateProduct(Products updatedProduct) {
    int index = products.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      products[index] = updatedProduct;
    }
  }

  void deleteProduct(String id) {
    products.removeWhere((p) => p.id == id);
  }
}
