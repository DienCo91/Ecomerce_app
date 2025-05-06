import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackBar({
  required String message,
  Color backgroundColor = const Color.fromARGB(255, 96, 222, 100),
  Color textColor = Colors.white,
  SnackPosition position = SnackPosition.TOP,
  int duration = 3,
}) {
  Get.snackbar(
    "",
    "",
    backgroundColor: backgroundColor,
    colorText: textColor,
    snackPosition: position,
    margin: const EdgeInsets.only(top: 4, left: 20, right: 20),
    duration: Duration(seconds: duration),
    forwardAnimationCurve: Curves.easeIn,
    reverseAnimationCurve: Curves.easeIn,
    titleText: const SizedBox.shrink(),
    messageText: Text(message, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14)),
  );
}
