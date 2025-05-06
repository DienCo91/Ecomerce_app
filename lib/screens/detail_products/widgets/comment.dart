import 'package:flutter/material.dart';
import 'package:flutter_app/models/review.dart';
import 'package:flutter_app/utils/string.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Comment extends StatelessWidget {
  const Comment({super.key, required this.review});
  final List<Review> review;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Comment :", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          if (review.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              width: double.infinity,
              child: Text(
                "Comment Empty !",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color.fromARGB(130, 0, 0, 0)),
              ),
            )
          else
            ...review.map((e) {
              return Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(33, 0, 0, 0), // Màu sắc bóng
                      blurRadius: 2, // Độ mờ của bóng
                      offset: Offset(0, 1), // Vị trí bóng (Offset(x, y))
                    ),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            // ignore: unnecessary_string_interpolations
                            "${e.user.firstName}",
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8),
                        RatingBar.builder(
                          initialRating: e.rating.toDouble(),
                          minRating: 0,
                          direction: Axis.horizontal,
                          itemCount: 5,
                          unratedColor: const Color.fromARGB(255, 226, 226, 226),
                          itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                          itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                          onRatingUpdate: (_) {},
                          ignoreGestures: true,
                          allowHalfRating: true,
                          glow: false,
                          itemSize: 24,
                        ),
                      ],
                    ),
                    Text(formatDate(e.created), style: TextStyle(color: Color.fromARGB(82, 0, 0, 0), fontSize: 12)),
                    Container(margin: const EdgeInsets.only(top: 8), child: Text(e.title)),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
