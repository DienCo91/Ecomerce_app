import 'package:flutter/material.dart';
import 'package:flutter_app/models/orders.dart';
import 'package:flutter_app/screens/order_detail/widgets/summary_row.dart';

class OrderSummarySection extends StatelessWidget {
  final Orders order;

  const OrderSummarySection({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    double subtotal = order.total;
    double tax = order.totalTax;
    double shipping = 0.0;
    double total = subtotal + tax + shipping;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: const Color.fromARGB(17, 158, 158, 158), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          SummaryRow(label: "Subtotal", value: subtotal),
          SummaryRow(label: "Est. Sales Tax", value: tax),
          SummaryRow(label: "Shipping & Handling", value: shipping),
          const Divider(),
          SummaryRow(label: "Total", value: total, isBold: true),
        ],
      ),
    );
  }
}
