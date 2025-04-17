import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';

class BannerCarousel extends StatelessWidget {
  final List<String> imgList;

  BannerCarousel({required this.imgList});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 180.0,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.9,
        aspectRatio: 16 / 9,
        autoPlayInterval: Duration(seconds: 3),
      ),
      items: imgList.map((item) => ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(item, fit: BoxFit.cover, width: double.infinity),
      )).toList(),
    );
  }
}
