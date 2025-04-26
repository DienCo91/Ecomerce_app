import 'package:flutter/material.dart';
import 'package:flutter_app/screens/shop/index.dart';

class Search extends StatelessWidget {
  const Search({super.key, required this.widget, required this.title});

  final Shop widget;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        SizedBox(width: 32),
        Expanded(
          child: TextField(
            style: TextStyle(fontSize: 14),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.only(
                top: 0,
                bottom: 0,
                left: 20,
                right: 20,
              ),
              hintText: "Search",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                onPressed: () {},
                icon: Icon(Icons.search, color: Colors.blue, size: 24),
              ),
              fillColor: const Color.fromARGB(48, 158, 158, 158),
              filled: true,
            ),
          ),
        ),
      ],
    );
  }
}
