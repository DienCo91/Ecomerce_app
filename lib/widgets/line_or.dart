import 'package:flutter/material.dart';

class LineOr extends StatelessWidget {
  const LineOr({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: const Color.fromARGB(75, 0, 0, 0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Text("OR"),
          ),
          Expanded(
            child: Container(
              height: 1,
              color: const Color.fromARGB(75, 0, 0, 0),
            ),
          ),
        ],
      ),
    );
  }
}
