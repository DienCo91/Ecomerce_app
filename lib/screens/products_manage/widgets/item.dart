import 'package:flutter/material.dart';
import 'package:flutter_app/common/constants.dart';
import 'package:flutter_app/controllers/product_manager_controller.dart';
import 'package:flutter_app/models/products.dart';
import 'package:flutter_app/screens/product_manage_detail/index.dart';
import 'package:flutter_app/services/product_service.dart';
import 'package:flutter_app/utils/api_constants.dart';
import 'package:flutter_app/utils/assets_image.dart';
import 'package:flutter_app/utils/showSnackBar.dart';
import 'package:get/get.dart';

class Item extends StatelessWidget {
  const Item({super.key, this.product});
  final Products? product;

  void handleEditProduct() async {
    await Future.delayed(Duration(milliseconds: 200));
    Get.to(ProductManageDetail(), arguments: {'type': DetailType.update, 'product': product});
  }

  void showDeleteConfirmationDialog(VoidCallback onConfirm) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
            SizedBox(width: 8),
            Text("Confirm Delete", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text("Are you sure you want to delete this product?", style: TextStyle(fontSize: 16)),
        actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.grey[700]),
            onPressed: () => Get.back(),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Get.back();
              onConfirm();
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }

  void handleDelete() {
    showDeleteConfirmationDialog(() async {
      ProductManagerController productManagerController = Get.find();
      try {
        await ProductService().deleteProductById(product!.id);
        productManagerController.deleteProduct(product!.id);
        // showSnackBar(message: "Deleted");
      } catch (e) {
        print(e);
        Get.snackbar("Error", "Failed to delete the product.", backgroundColor: Colors.red, colorText: Colors.white);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.white,
      shadowColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: 350,
        height: 100,
        child: Stack(
          children: [
            Row(
              children: [
                Image.network(
                  '${ApiConstants.baseUrl}${product?.imageUrl}',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image(image: AssetsImages.defaultImage, width: 100, height: 100, fit: BoxFit.cover);
                  },
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 20, top: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product?.name ?? "###",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),
                        Text(
                          product?.description ?? "######",
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 24),
              ],
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: handleEditProduct,
                  splashColor: const Color.fromARGB(19, 0, 0, 0),
                  highlightColor: const Color.fromARGB(19, 0, 0, 0),
                ),
              ),
            ),
            Positioned(
              right: 10,
              child: Container(
                margin: const EdgeInsets.only(top: 22),
                child: IconButton(
                  onPressed: handleDelete,
                  icon: Icon(Icons.delete, size: 24, color: (Colors.red)),
                  splashColor: const Color.fromARGB(19, 0, 0, 0),
                  highlightColor: const Color.fromARGB(19, 0, 0, 0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
