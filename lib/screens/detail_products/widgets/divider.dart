import 'package:flutter/material.dart';

class DividerCustom extends StatelessWidget {
  const DividerCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Container(width: 200, height: 1, color: Colors.grey[300], margin: const EdgeInsets.only(top: 16))],
      ),
    );
  }
}
