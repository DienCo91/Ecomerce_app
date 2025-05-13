import 'package:flutter/material.dart';
import 'package:flutter_app/models/review.dart';
import 'package:flutter_app/screens/detail_products/widgets/comment.dart';
import 'package:flutter_app/services/review_service.dart';
import 'package:flutter_app/utils/number.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReviewProduct extends StatefulWidget {
  const ReviewProduct({super.key, required this.name, required this.id});

  final String name;
  final String id;

  @override
  State<ReviewProduct> createState() => _ReviewProductState();
}

class _ReviewProductState extends State<ReviewProduct> {
  List<Review> review = [];
  double starAvg = 0;
  Map<String, double> starDetail = {"5": 0, "4": 0, "3": 0, "2": 0, "1": 0};
  bool _isLoading = true;

  void handleStar() {
    int sumRating = 0;

    for (var reviewItem in review) {
      sumRating += reviewItem.rating;
      if (reviewItem.rating == 5) starDetail["5"] = (starDetail["5"] ?? 0) + 1;
      if (reviewItem.rating == 4) starDetail["4"] = (starDetail["4"] ?? 0) + 1;
      if (reviewItem.rating == 3) starDetail["3"] = (starDetail["3"] ?? 0) + 1;
      if (reviewItem.rating == 2) starDetail["2"] = (starDetail["2"] ?? 0) + 1;
      if (reviewItem.rating == 1) starDetail["1"] = (starDetail["1"] ?? 0) + 1;
    }

    double newStarAvg = sumRating / review.length;
    print(newStarAvg);
    setState(() {
      starAvg = newStarAvg;
    });
  }

  void handleGetReview() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await ReviewService().getReview(widget.name);
      setState(() {
        review = response;
      });
      handleStar();
    } catch (e) {
      print("e $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    handleGetReview();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Review by ${review.length} users :", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Skeletonizer(
            enabled: _isLoading,
            child: Container(
              margin: const EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RatingBar.builder(
                    initialRating: starAvg > 0 ? formatRating(starAvg) : 0,
                    minRating: 0,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    unratedColor: const Color.fromARGB(255, 226, 226, 226),
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                    onRatingUpdate: (_) {},
                    ignoreGestures: true,
                    allowHalfRating: true,
                    glow: false,
                  ),
                ],
              ),
            ),
          ),
          Skeletonizer(
            enabled: _isLoading,
            child: Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(33, 0, 0, 0), 
                    blurRadius: 4, 
                    offset: Offset(0, 1),
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                children: [
                  ...starDetail.entries.toList().map((e) {
                    double percentage = (review.isNotEmpty) ? (e.value / review.length) : 0;
                    return Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: Row(
                        children: [
                          Text('${e.key} Star'),
                          const SizedBox(width: 20),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: percentage,
                              minHeight: 12,
                              backgroundColor: const Color.fromARGB(255, 226, 226, 226),
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                            ),
                          ),
                          const SizedBox(width: 20),
                          SizedBox(
                            width: 46,
                            child: Text('${(percentage * 100).toStringAsFixed(0)} %', textAlign: TextAlign.end),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          _isLoading ? SizedBox() : Comment(review: review, id: widget.id),
        ],
      ),
    );
  }
}
