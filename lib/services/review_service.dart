import 'dart:convert';

import 'package:flutter_app/controllers/auth_controller.dart';
import 'package:flutter_app/models/review.dart';
import 'package:flutter_app/models/review_response.dart';
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

  Future<ReviewResponse> getAllReview({required int page, required int limit}) async {
    final authController = Get.find<AuthController>();

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/api/review?page=$page&limit=$limit"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '${authController.user.value?.token}',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> dataRes = jsonDecode(response.body);
      return ReviewResponse.fromJson(dataRes);
    } else {
      throw Exception("Error adding review: ${response.body}");
    }
  }

  Future deleteReviewById({required String id}) async {
    final authController = Get.find<AuthController>();

    final response = await http.delete(
      Uri.parse("${ApiConstants.baseUrl}/api/review/delete/$id"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '${authController.user.value?.token}',
      },
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception("Error adding review: ${response.body}");
    }
  }

  Future approvedReviewById({required String id}) async {
    final authController = Get.find<AuthController>();

    final response = await http.put(
      Uri.parse("${ApiConstants.baseUrl}/api/review/approve/$id"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '${authController.user.value?.token}',
      },
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception("Error adding review: ${response.body}");
    }
  }
}
