import 'dart:convert';

import 'package:flutter_app/controllers/auth_controller.dart';
import 'package:flutter_app/models/wishlist.dart';
import 'package:flutter_app/utils/api_constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class WishlistServices {
  Future<String> toggleFavorite(bool isLiked, String productId) async {
    AuthController authController = Get.find();
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/api/wishlist'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '${authController.user.value?.token}',
      },
      body: jsonEncode({'isLiked': isLiked, 'product': productId}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['message'];
    } else {
      throw Exception("Like Fail");
    }
  }

  Future<List<Wishlists>> getWishlist() async {
    AuthController authController = Get.find();
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/api/wishlist'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '${authController.user.value?.token}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> dataResponse = jsonDecode(response.body)['wishlist'];
      return dataResponse.where((e) => e != null).map((e) => Wishlists.fromJson(e!)).toList();
    } else {
      throw Exception("Error get Wishlist");
    }
  }
}
