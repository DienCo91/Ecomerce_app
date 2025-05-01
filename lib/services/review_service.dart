import 'dart:convert';

import 'package:flutter_app/models/review.dart';
import 'package:flutter_app/utils/api_constants.dart';
import 'package:flutter_app/utils/string.dart';
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
}
