import 'dart:convert';

import 'package:flutter_app/controllers/auth_controller.dart';
import 'package:flutter_app/models/products.dart';
import 'package:flutter_app/utils/api_constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CartServices {
  Future<String> addCartToOrder(List<Products> prod) async {
    final AuthController user = Get.find<AuthController>();
    final token = user.user.value?.token;
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/api/cart/add'),
      headers: {'Authorization': token.toString(), 'Content-Type': 'application/json'},
      body: jsonEncode({'products': prod.map((p) => p.toJson()).toList()}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['cartId'];
    } else {
      throw Exception('Failed to add to cart: ${response.body}');
    }
  }
}
