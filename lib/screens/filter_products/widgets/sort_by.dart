import 'package:flutter/material.dart';

const listDropDown = [
  {"label": "Newest First", "value": "id", "number": " -1"},
  {"label": "Price High to Low", "value": "price", "number": '-1'},
  {"label": "Price Low to High", "value": "price", "number": '1'},
];

class SortBy extends StatelessWidget {
  const SortBy({super.key, required this.onChanged, required this.selectedValue});

  final String? selectedValue;
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Sort by:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        DropdownButton<String>(
          value: selectedValue,
          style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
          icon: Icon(Icons.arrow_drop_down, color: Colors.blue),
          underline: Container(height: 2, color: Colors.blue),
          items:
              listDropDown.map<DropdownMenuItem<String>>((e) {
                return DropdownMenuItem<String>(value: e['label'] as String, child: Text(e['label'] as String));
              }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
