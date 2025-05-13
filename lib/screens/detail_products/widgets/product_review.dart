import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductReviewPage extends StatelessWidget {
  final List<ProductReview> reviews;

  const ProductReviewPage({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: reviews.length,
      padding: const EdgeInsets.all(16),
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(review.avatarUrl),
              radius: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.username,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  RatingBarIndicator(
                    rating: review.rating,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 20.0,
                    direction: Axis.horizontal,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    review.comment,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    review.date,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class ProductReview {
  final String username;
  final String avatarUrl;
  final double rating;
  final String comment;
  final String date;

  ProductReview({
    required this.username,
    required this.avatarUrl,
    required this.rating,
    required this.comment,
    required this.date,
  });
}
