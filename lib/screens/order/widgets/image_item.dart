import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/utils/assets_image.dart';

class ImageItem extends StatelessWidget {
  const ImageItem({super.key, required this.listImage});

  final List<String> listImage;

  @override
  Widget build(BuildContext context) {
    final imagesToShow = listImage.take(4).toList();
    final count = imagesToShow.length;
    return SizedBox(
      width: 80,
      height: 80,
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: count <= 1 ? 1 : min(count, 4),
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
        ),
        itemCount: count,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              imagesToShow[index],
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Image(image: AssetsImages.defaultImage, fit: BoxFit.contain),
            ),
          );
        },
      ),
    );
  }
}
