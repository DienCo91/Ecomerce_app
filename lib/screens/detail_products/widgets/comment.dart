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
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            padding: const EdgeInsets.all(16),
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
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          hintText: 'Enter Review Title',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        onChanged: (value) => controller.title.value = value,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Comment',
                          hintText: 'Write Review',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                        ),
                        maxLines: 4,
                        onChanged: (value) => controller.comment.value = value,
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
                                color: controller.rating.value > index
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
                        onPressed: controller.isLoading.value ? null : () => Get.back(),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: controller.isLoading.value ? Colors.grey : Colors.blue),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Obx(
                      () => ElevatedButton(
                        onPressed: controller.comment.trim().isNotEmpty &&
                                controller.title.trim().isNotEmpty &&
                                !controller.isLoading.value
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
              const Text("Comment :", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              TextButton.icon(
                onPressed: showCustomReviewDialog,
                label: const Text("Add Review", style: TextStyle(color: Colors.blue, fontSize: 14)),
                icon: const Icon(Icons.comment, color: Colors.blue),
              ),
            ],
          ),
          if (review.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              width: double.infinity,
              child: const Text(
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
                      color: const Color.fromARGB(33, 0, 0, 0),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "${e.user.firstName}",
                            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        RatingBar.builder(
                          initialRating: double.parse(e.rating.toStringAsFixed(2)),
                          minRating: 0,
                          direction: Axis.horizontal,
                          itemCount: 5,
                          unratedColor: const Color.fromARGB(255, 226, 226, 226),
                          itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                          itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                          onRatingUpdate: (_) {},
                          ignoreGestures: true,
                          allowHalfRating: true,
                          glow: false,
                          itemSize: 24,
                        ),
                      ],
                    ),
                    Text(formatDate(e.created), style: const TextStyle(color: Color.fromARGB(82, 0, 0, 0), fontSize: 12)),
                    Container(margin: const EdgeInsets.only(top: 8), child: Text(e.title)),
                    const SizedBox(height: 8),
                    Text(e.review, style: const TextStyle(fontStyle: FontStyle.italic)),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
