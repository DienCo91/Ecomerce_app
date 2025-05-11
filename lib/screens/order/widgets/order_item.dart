import 'package:flutter/material.dart';
import 'package:flutter_app/models/orders.dart';
import 'package:flutter_app/screens/order/widgets/image_item.dart';
import 'package:flutter_app/screens/order_detail/index.dart';
import 'package:flutter_app/utils/api_constants.dart';
import 'package:flutter_app/utils/color.dart';
import 'package:flutter_app/utils/string.dart';
import 'package:get/get.dart';

class OrderItem extends StatelessWidget {
  const OrderItem({super.key, this.order, this.status, this.isEdit = false});

  final Orders? order;

  final String? status;
  final bool? isEdit;

  @override
  Widget build(BuildContext context) {
    Color color = getStatusColor(status);
    void onOrderTap() async {
      await Future.delayed(Durations.medium1);
      Get.to(
        OrderDetail(),
        transition: Transition.rightToLeftWithFade,
        duration: const Duration(milliseconds: 300),
        arguments: {'order': order, 'status': status, 'isAllOrder': isEdit},
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: const Color.fromARGB(33, 0, 0, 0), blurRadius: 1, offset: Offset(1, 1))],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => onOrderTap(),
          child: Ink(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ImageItem(
                  listImage:
                      order != null
                          ? order!.products
                              .map(
                                (e) => e.product.imageUrl.isEmpty ? '' : '${ApiConstants.baseUrl}${e.product.imageUrl}',
                              )
                              .toList()
                          : [''],
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("Status: ", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                          Text(" $status", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: color)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text("Order #${order?.id ?? ""}", style: const TextStyle(fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(
                        "Ordered on ${order != null ? formatDate(order!.created) : ""}",
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      if (order != null)
                        Text(
                          "Order Total: \$${(order!.total + order!.totalTax).toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
