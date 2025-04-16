import 'package:flutter/material.dart';

class RichTextCustom extends StatelessWidget {
  const RichTextCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: "RichText ",
            style: TextStyle(
              color: const Color.fromARGB(255, 255, 31, 31),
              decoration: TextDecoration.underline,
              fontStyle: FontStyle.italic,
            ),
          ),
          TextSpan(text: "Flutter", style: TextStyle(color: Colors.amber)),
          TextSpan(text: " App", style: TextStyle(color: Colors.blue[600])),
        ],
      ),
    );
  }
}
