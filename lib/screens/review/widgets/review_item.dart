import 'package:flutter/material.dart';
import 'package:flutter_app/models/review.dart';
import 'package:flutter_app/services/review_service.dart';
import 'package:flutter_app/utils/showSnackBar.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class ReviewItem extends StatefulWidget {
  const ReviewItem({super.key, this.review});

  final Review? review;

  @override
  State<ReviewItem> createState() => _ReviewItemState();
}

class _ReviewItemState extends State<ReviewItem> {
  bool isApprove = false;
  bool isDeleted = false;
  bool isLoading = false;

  void handleApprove() async {
    setState(() {
      isLoading = true;
    });
    try {
      await ReviewService().approvedReviewById(id: widget.review?.id ?? "");
      setState(() {
        isApprove = true;
      });
      showSnackBar(message: "Approved Success");
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void handleDelete() {
    Get.defaultDialog(
      title: 'Delete Confirmation',
      middleText: 'Are you sure you want to delete this review?',
      textCancel: 'Cancel',
      textConfirm: 'Delete',
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      cancelTextColor: Colors.black,
      onConfirm: () async {
        Get.back();
        setState(() {
          isLoading = true;
        });

        try {
          await ReviewService().deleteReviewById(id: widget.review?.id ?? "");
          setState(() {
            isDeleted = true;
          });
          showSnackBar(message: "Delete Success");
        } catch (e) {
          print(e);
        } finally {
          setState(() {
            isLoading = false;
          });
        }
      },
      onCancel: () {},
    );
  }

  @override
  void initState() {
    super.initState();
    isApprove = widget.review?.status == 'Approved';
  }

  @override
  Widget build(BuildContext context) {
    if (isDeleted) return SizedBox();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  widget.review?.title ?? "##########",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                flex: 2,
                child: Text(
                  widget.review?.user.firstName ?? "##########",
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            widget.review?.review ?? "##########",
            style: const TextStyle(fontSize: 15),
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 8),

          Text(
            "Sản phẩm: ${widget.review?.product.name}",
            style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.black87),
          ),

          const SizedBox(height: 12),

          RatingBarIndicator(
            rating: widget.review?.rating.toDouble() ?? 0,
            itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
            itemCount: 5,
            itemSize: 24,
            unratedColor: const Color(0xFFE2E2E2),
            direction: Axis.horizontal,
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isApprove
                  ? Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.greenAccent, size: 24),
                      SizedBox(width: 8),
                      Text("Approved", style: TextStyle(color: Colors.greenAccent, fontSize: 16)),
                    ],
                  )
                  : ElevatedButton(
                    onPressed: isLoading ? null : handleApprove,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isLoading ? Colors.grey : Colors.greenAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text("APPROVE", style: TextStyle(color: Colors.white)),
                  ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: isLoading ? null : handleDelete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isLoading ? Colors.grey : Colors.redAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text("DELETE", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
