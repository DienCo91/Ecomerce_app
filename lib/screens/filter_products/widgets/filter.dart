import 'package:flutter/material.dart';
import 'package:flutter_app/screens/filter_products/widgets/price.dart';
import 'package:flutter_app/screens/filter_products/widgets/sort_by.dart';
import 'package:get/get.dart';

const listDropDown = [
  {"label": "Newest First", "value": "id", "number": " -1"},
  {"label": "Price High to Low", "value": "price", "number": '-1'},
  {"label": "Price Low to High", "value": "price", "number": '1'},
];

class Filter extends StatefulWidget {
  const Filter({super.key});

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  String? selectedValue = listDropDown[0]['label'] as String;
  RangeValues _currentRangeValues = const RangeValues(10, 2500);

  void onPressed() {
    Get.bottomSheet(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setSheetState) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Filter", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                SortBy(
                  onChanged: (String? value) {
                    setState(() {
                      selectedValue = value;
                    });
                    setSheetState(() {
                      selectedValue = value;
                    });
                  },
                  selectedValue: selectedValue,
                ),
                Price(
                  onChanged: (RangeValues values) {
                    setState(() {
                      _currentRangeValues = values;
                    });
                    setSheetState(() {
                      _currentRangeValues = values;
                    });
                  },
                  currentRangeValues: _currentRangeValues,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: IconButton(onPressed: onPressed, icon: Icon(Icons.filter_list)));
  }
}
