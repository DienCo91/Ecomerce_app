import 'package:flutter/material.dart';

class Shop extends StatefulWidget {
  const Shop({super.key, required String title}) : _title = title;

  final String _title;

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              widget._title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
        ),
      ],
    );
  }
}
