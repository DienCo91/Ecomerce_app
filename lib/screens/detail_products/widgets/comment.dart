import 'package:flutter/material.dart';
import 'package:flutter_app/controllers/review_controller.dart';
import 'package:flutter_app/models/review.dart';
import 'package:flutter_app/utils/string.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class Comment extends StatelessWidget {
  const Comment({super.key, required this.review, required this.id});
  final List<Review> review;
  final String id;

  void showCustomReviewDialog() {
    final controller = Get.put(ReviewController());

    showDialog(
      context: Get.context!,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Add Review', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: TextField(
                          decoration: const InputDecoration(
                            floatingLabelStyle: TextStyle(color: Colors.blue),
                            labelText: 'Title',
                            hintText: 'Enter Review Title',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          onChanged: (value) => controller.title.value = value,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: TextField(
                          decoration: const InputDecoration(
                            floatingLabelStyle: TextStyle(color: Colors.blue),
                            labelText: 'Comment',
                            hintText: 'Write Review',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                          ),
                          maxLines: 4,
                          onChanged: (value) => controller.comment.value = value,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('Rating', style: TextStyle(fontWeight: FontWeight.w600)),
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return IconButton(
                              icon: Icon(
                                Icons.star,
                                size: 36,
                                color:
                                    controller.rating.value > index
                                        ? Colors.amber
                                        : const Color.fromARGB(88, 158, 158, 158),
                              ),
                              onPressed: () => controller.rating.value = index + 1,
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Obx(
                      () => TextButton(
                        onPressed: controller.isLoading == true ? null : () => Get.back(),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: controller.isLoading == true ? Colors.grey : Colors.blue),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Obx(
                      () => ElevatedButton(
                        onPressed:
                            controller.comment.trim().isNotEmpty &&
                                    controller.title.trim().isNotEmpty &&
                                    controller.isLoading == false
                                ? () => controller.publishReview(id)
                                : null,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        child: const Text('Publish Review', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Comment :", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              TextButton.icon(
                onPressed: showCustomReviewDialog,
                label: Text("Add Review", style: TextStyle(color: Colors.blue, fontSize: 14)),
                icon: Icon(Icons.comment),
                style: ElevatedButton.styleFrom(iconColor: Colors.blue, iconSize: 24),
              ),
            ],
          ),
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
