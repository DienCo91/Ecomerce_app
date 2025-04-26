import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utils/assets_image.dart';

const List<AssetImage> imgList = [
  AssetsImages.imageBanner1,
  AssetsImages.imageBanner2,
  AssetsImages.imageBanner3,
  AssetsImages.imageBanner4,
  AssetsImages.imageBanner5,
];

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  CarouselSliderController buttonCarouselController =
      CarouselSliderController();

  int _currentIndex = 0;

  void onPageChanged(int index, CarouselPageChangedReason reason) {
    setState(() {
      print(index);
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: CarouselSlider(
            carouselController: buttonCarouselController,
            options: CarouselOptions(
              height: 260,
              aspectRatio: 16 / 9,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              initialPage: 0,
              viewportFraction: 0.9,
              onPageChanged: onPageChanged,
            ),
            items:
                imgList.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image(image: i, fit: BoxFit.cover),
                        ),
                      );
                    },
                  );
                }).toList(),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...imgList.asMap().entries.map((i) {
              return GestureDetector(
                onTap: () => buttonCarouselController.animateToPage(i.key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  alignment: Alignment.centerLeft,
                  width: _currentIndex == i.key ? 24 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    color:
                        _currentIndex == i.key
                            ? Colors.blue
                            : const Color.fromARGB(47, 33, 149, 243),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ],
    );
  }
}
