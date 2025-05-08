import 'package:flutter/material.dart';
import 'package:flutter_app/models/review.dart';
import 'package:flutter_app/screens/review/widgets/review_item.dart';
import 'package:flutter_app/services/review_service.dart';
import 'package:flutter_app/widgets/app_scaffold.dart';
import 'package:flutter_app/widgets/header.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final ScrollController listViewScroll = ScrollController();
  final int limit = 10;

  List<Review> reviews = [];
  bool isLoading = false;
  int page = 1;
  bool isLoadMore = true;

  @override
  void initState() {
    super.initState();
    getData();
    listViewScroll.addListener(scrollListener);
  }

  void scrollListener() {
    if (listViewScroll.position.pixels >= listViewScroll.position.maxScrollExtent - 200 && !isLoading && isLoadMore) {
      getData();
    }
  }

  void getData() async {
    setState(() => isLoading = true);
    try {
      final res = await ReviewService().getAllReview(page: page, limit: limit);
      setState(() {
        reviews.addAll(res.reviews);
        page = res.currentPage + 1;
        isLoadMore = res.reviews.length == limit;
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: const Header(icon: Icons.comment, title: "Review", iconColor: Colors.blue),
          ),
          Expanded(
            child: ListView.builder(
              controller: listViewScroll,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              itemCount: reviews.length + (isLoading ? 2 : 0),
              itemBuilder: (context, index) {
                if (isLoading && index >= reviews.length) {
                  return Skeletonizer(enabled: isLoading, child: ReviewItem());
                }
                final review = reviews[index];

                return ReviewItem(review: review);
              },
            ),
          ),
        ],
      ),
    );
  }
}
