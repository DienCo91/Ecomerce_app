import 'package:flutter/material.dart';

// co shadow button
class ElevatedButtonCustom extends StatelessWidget {
  final bool isPress;

  const ElevatedButtonCustom({super.key, required this.isPress});

  void onPressed() {
    print("ElevatedButton");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isPress ? onPressed : null,
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(
                  isPress
                      ? const Color.fromARGB(136, 141, 100, 255)
                      : const Color.fromARGB(39, 141, 100, 255),
                ),
                shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              child: Text(
                "ElevatedButton",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isPress ? onPressed : null,
              icon: Icon(Icons.add, color: Colors.white),
              label: Text(
                "ElevatedButton",
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(
                  isPress
                      ? const Color.fromARGB(136, 141, 100, 255)
                      : const Color.fromARGB(39, 141, 100, 255),
                ),
                shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
