import 'package:flutter/material.dart';
import 'package:flutter_app/screens/home/index.dart';
import 'package:get/get.dart';

class IconCardNumber extends StatelessWidget {
  const IconCardNumber({super.key, required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    void onPressed() {
      Get.to(() => const Home(), arguments: {'tabIndex': 2});
    }

    return Positioned(
      top: 30,
      left: 10,
      child: Stack(
        children: [
          IconButton(onPressed: onPressed, icon: Icon(Icons.shopping_cart_outlined, size: 28, color: Colors.blue)),
          if (number > 0)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                child: Text('$number', style: TextStyle(fontSize: 12, color: Colors.white)),
              ),
            ),
        ],
      ),
    );
  }
}
