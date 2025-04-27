import 'dart:convert';

import 'package:flutter_app/models/products.dart';
import 'package:flutter_app/utils/api_constants.dart';
import 'package:http/http.dart' as http;

class SuggestSearchService {
  Future<List<Products>> getSuggestions(String name) async {
    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/api/product/list/search/$name"),
    );

    if (response.statusCode == 200) {
      final List<dynamic> dataResponse = jsonDecode(response.body)["products"];
      print(dataResponse);
      return dataResponse.map((e) => Products.fromJson(e)).toList();
    } else {
      throw Exception("Error fetching suggestions");
    }
  }
}
