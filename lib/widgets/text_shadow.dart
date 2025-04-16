import 'package:flutter/material.dart';

class TextShadowCustom extends StatelessWidget {
  const TextShadowCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Two households, both alike in dignity, '
      'In fair Verona, where we lay our scene,'
      'From ancient grudge break to new mutiny,'
      'Where civil blood makes civil hands unclean.'
      'From forth the fatal loins of these two foes',
      style: TextStyle(
        locale: Locale("vi", "VN"),
        fontSize: 24,
        shadows: [
          Shadow(
            offset: Offset(1, 1),
            blurRadius: 4,
            color: const Color.fromARGB(255, 178, 71, 255),
          ),
        ],
      ),
      textAlign: TextAlign.justify,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }
}
