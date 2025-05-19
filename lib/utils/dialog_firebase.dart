import 'package:flutter/material.dart';
import 'package:flutter_app/screens/order/index.dart';
import 'package:flutter_app/screens/order_detail/index.dart';
import 'package:get/get.dart';

void showOrderUpdateDialog({String? title, String? body, String? id}) {
  Get.defaultDialog(
    title: '',
    backgroundColor: Colors.white,
    titlePadding: EdgeInsets.zero,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue.withOpacity(0.2)),
          child: Icon(Icons.shopping_bag_rounded, size: 40, color: Colors.blue),
        ),
        const SizedBox(height: 16),

        Text(
          title ?? 'Cập nhật đơn hàng',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]),
        ),
        const SizedBox(height: 8),

        Text(
          body ?? 'Trạng thái đơn hàng đã được thay đổi.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () {
          Get.back();
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.grey,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text("Cancel"),
      ),
      ElevatedButton(
        onPressed: () {
          Get.back();
          if (!body!.toLowerCase().contains('cancel')) {
            Navigator.push(
              Get.context!,
              MaterialPageRoute(
                builder: (context) => OrderDetail(),
                settings: RouteSettings(arguments: {'orderId': id, 'isAllOrder': false}),
              ),
            );
          } else {
            Navigator.push(Get.context!, MaterialPageRoute(builder: (context) => Order()));
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text("Go to my order"),
      ),
    ],
    radius: 16,
    barrierDismissible: false,
  );
}
