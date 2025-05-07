import 'package:flutter_app/services/review_service.dart';
import 'package:flutter_app/utils/showSnackBar.dart';
import 'package:get/get.dart';

class ReviewController extends GetxController {
  var title = ''.obs;
  var comment = ''.obs;
  var rating = 0.obs;
  var isLoading = false.obs;

  void reset() {
    title.value = '';
    comment.value = '';
    rating.value = 0;
    isLoading.value = false;
  }

  void publishReview(String id) async {
    isLoading.value = true;
    try {
      final message = await ReviewService().addReview(
        product: id,
        rating: rating.value.toString(),
        review: comment.value,
        title: title.value,
      );
      Get.back();
      showSnackBar(message: message, duration: 4);
      reset();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
