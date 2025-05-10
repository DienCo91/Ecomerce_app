import 'package:flutter_app/models/review.dart';

class ReviewResponse {
  final int count;
  final int currentPage;
  final int totalPages;
  final List<Review> reviews;

  ReviewResponse({required this.count, required this.currentPage, required this.totalPages, required this.reviews});

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      count: json['count'],
      reviews: (json['reviews'] as List).map((item) => Review.fromJson(item)).toList(),
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
    );
  }
}
