import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Rating extends StatelessWidget {
  const Rating({super.key, required this.onRatingUpdate, required this.initialRating});

  final void Function(double) onRatingUpdate;
  final double initialRating;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 16),
      child: Row(
        spacing: 12,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Rating :", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          RatingBar.builder(
            initialRating: initialRating,
            minRating: 0,
            direction: Axis.horizontal,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
            onRatingUpdate: onRatingUpdate,
          ),
        ],
      ),
    );
  }
}
