import 'package:flutter/material.dart';
import 'package:flutter_app/models/products.dart';
import 'package:flutter_app/utils/api_constants.dart';
import 'package:flutter_app/utils/assets_image.dart';
import 'package:flutter_app/utils/showSnackBar.dart';
import 'package:get/get.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.product, required this.onDelete, this.isShowQuantity = true});

  final Products product;
  final void Function(String id) onDelete;
  final bool isShowQuantity;

  @override
  Widget build(BuildContext context) {
    void handleButtonDelete() {
      Get.dialog<bool>(
        AlertDialog(
          title: Text("Delete Confirmation"),
          content: Text("Are you sure you want to delete this product?"),
          actions: [
            TextButton(onPressed: () => Get.back(), child: Text("Cancel")),
            TextButton(
              onPressed: () {
                Get.back();
                onDelete(product.id);
                showSnackBar(message: "Delete Successfully", duration: 2);
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Dismissible(
        key: ValueKey(product.id),
        onDismissed: (_) => onDelete(product.id),
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Icon(Icons.delete, color: Colors.white),
        ),

        direction: DismissDirection.endToStart,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: const Color.fromARGB(31, 124, 124, 124), blurRadius: 8, offset: Offset(0, 2))],
          ),
          child: Row(
            children: [
              Container(
                width: 100,
                height: 100,
                padding: const EdgeInsets.only(left: 8),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                ),
                child: FadeInImage(
                  placeholder: AssetsImages.defaultImage,
                  image: NetworkImage('${ApiConstants.baseUrl}${product.imageUrl}'),
                  fit: BoxFit.contain,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image(image: AssetsImages.defaultImage, fit: BoxFit.contain);
                  },
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Text('Price: \$${product.price}', style: TextStyle(color: Colors.grey[700])),
                          isShowQuantity
                              ? Text('Quantity: ${product.quantity}', style: TextStyle(color: Colors.grey[700]))
                              : SizedBox(),
                        ],
                      ),
                      IconButton(onPressed: handleButtonDelete, icon: Icon(Icons.delete, color: (Colors.redAccent))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
