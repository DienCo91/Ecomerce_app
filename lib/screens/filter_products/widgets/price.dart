import 'package:flutter/material.dart';

class Price extends StatelessWidget {
  const Price({super.key, required this.onChanged, required this.currentRangeValues});
  final RangeValues currentRangeValues;
  final void Function(RangeValues)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Price :", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          RangeSlider(
            values: currentRangeValues,
            max: 5000,
            min: 1,
            activeColor: Colors.blue,
            divisions: 5000,
            labels: RangeLabels("\$${currentRangeValues.start.round()}", "\$${currentRangeValues.end.round()}"),
            onChanged: onChanged,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: const Color.fromARGB(25, 0, 0, 0), blurRadius: 8, offset: Offset(0, 4))],
            ),
            child: Text(
              "\$${currentRangeValues.start.round()} - \$${currentRangeValues.end.round()}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.blue.shade800),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
