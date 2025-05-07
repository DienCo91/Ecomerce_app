import 'dart:convert';

import 'package:flutter_app/controllers/auth_controller.dart';
import 'package:flutter_app/models/review.dart';
import 'package:flutter_app/utils/api_constants.dart';
import 'package:flutter_app/utils/string.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ReviewService {
  Future<List<Review>> getReview(String name) async {
    final newName = slugify(name);
    final response = await http.get(Uri.parse("${ApiConstants.baseUrl}/api/review/${newName}"));

    if (response.statusCode == 200) {
      final List<dynamic> listResponse = jsonDecode(response.body)["reviews"];
      return listResponse.map((e) => Review.fromJson(e)).toList();
    } else {
      throw Exception("Error get review");
    }
  }

  Future<String> addReview({
    required String product,
    required String rating,
    required String review,
    required String title,
  }) async {
    final authController = Get.find<AuthController>();

    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/api/review/add"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '${authController.user.value?.token}',
      },
      body: jsonEncode({'product': product, 'rating': rating, 'review': review, 'title': title}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['message'];
    } else {
      throw Exception("Error adding review: ${response.body}");
    }
  }
}
