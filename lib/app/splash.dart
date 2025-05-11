import 'package:flutter/material.dart';
import 'package:flutter_app/utils/assets_image.dart';
import 'package:flutter_app/utils/string.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
      final token = getToken();
      if (token != null) {
        Get.offAllNamed('/home');
      } else {
        Get.offAllNamed('/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4568DC), Color(0xFFB7EFD6)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetsImages.logo, width: 240, height: 240, fit: BoxFit.contain),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
