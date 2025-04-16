import 'package:flutter/material.dart';
import 'package:flutter_app/utils/assets_image.dart';

class OutlineButtonCustom extends StatelessWidget {
  const OutlineButtonCustom({super.key});

  @override
  Widget build(BuildContext context) {
    void onPressed() {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }

    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        side: WidgetStatePropertyAll<BorderSide>(
          BorderSide(color: Color.fromARGB(255, 160, 36, 255), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(right: 16),
            padding: EdgeInsets.only(top: 8, bottom: 8),
            child: Image(image: AssetsImages.iconGoogle, width: 24, height: 24),
          ),
          Text(
            "OutlinedButton",
            style: TextStyle(color: const Color.fromARGB(255, 160, 36, 255)),
          ),
        ],
      ),
    );
  }
}
