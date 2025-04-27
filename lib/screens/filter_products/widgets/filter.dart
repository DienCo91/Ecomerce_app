import 'package:flutter/material.dart';
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

  void onPressed() {
    Get.bottomSheet(
      StatefulBuilder(
        builder:
            (BuildContext context, StateSetter setSheetState) => Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Filter",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Sort by:"),
                      DropdownButton<String>(
                        value: selectedValue,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                        icon: Icon(Icons.arrow_drop_down, color: Colors.blue),
                        underline: Container(
                          height: 2,
                          color: Colors.blue, // Màu gạch chân
                        ),
                        items:
                            listDropDown.map<DropdownMenuItem<String>>((e) {
                              return DropdownMenuItem<String>(
                                value: e['label'] as String,
                                child: Text(e['label'] as String),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value;
                          });
                          setSheetState(() {
                            selectedValue = value;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(onPressed: onPressed, icon: Icon(Icons.filter_list)),
    );
  }
}
