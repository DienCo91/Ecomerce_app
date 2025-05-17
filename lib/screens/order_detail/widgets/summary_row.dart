import 'package:flutter/material.dart';
import 'package:flutter_app/common/utils.dart';

class SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isBold;
  final bool isHighlight;

  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.isBold = false,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
      fontSize: isBold ? 16 : 14,
      color: isHighlight ? Colors.blueAccent : Colors.black87,
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration:
          isHighlight ? BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)) : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: style), Text(formatCurrency(value), style: style)],
      ),
    );
  }
}
