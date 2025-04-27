import 'dart:convert';

import 'package:flutter_app/models/product_response.dart';
import 'package:flutter_app/utils/api_constants.dart';
import 'package:http/http.dart' as http;

class ProductService {
  Future<ProductResponse> fetchProducts(Map<String, dynamic> data) async {
    // final AuthController user = Get.find<AuthController>();
    // final token = user.user.value?.token;
    Uri uri = Uri.parse('${ApiConstants.baseUrl}/api/product/list').replace(
      queryParameters: data.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> dataResponse = jsonDecode(response.body);
      return ProductResponse.fromJson(dataResponse);
    } else {
      throw Exception("Error fetching products");
    }
  }
}
