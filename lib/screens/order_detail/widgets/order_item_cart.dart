import 'package:flutter/material.dart';
import 'package:flutter_app/models/product_order.dart';
import 'package:flutter_app/utils/api_constants.dart';
import 'package:flutter_app/utils/assets_image.dart';
import 'package:intl/intl.dart';

class OrderItemCard extends StatelessWidget {
  final ProductOrder item;

  const OrderItemCard({super.key, required this.item});

  String formatCurrency(double amount) {
    final format = NumberFormat.simpleCurrency(locale: 'en_US');
    return format.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final total = item.product.price * item.quantity;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: const Color.fromARGB(17, 158, 158, 158), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: FadeInImage(
              placeholder: AssetsImages.defaultImage,
              image: NetworkImage('${ApiConstants.baseUrl}${item.product.imageUrl}'),
              fit: BoxFit.contain,
              width: 60,
              height: 60,
              imageErrorBuilder: (context, error, stackTrace) {
                return Image(image: AssetsImages.defaultImage, fit: BoxFit.contain, width: 60, height: 60);
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  formatCurrency(item.product.price.toDouble()),
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("Qty: ${item.quantity}", style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 4),
              Text(
                "Total: ${formatCurrency(total.toDouble())}",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
