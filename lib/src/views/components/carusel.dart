import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../utils/cachedNetworkImage.dart';

class Carousel extends StatelessWidget {

  final List? images;

  const Carousel({Key? key,
      required this.images,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 300,

        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        autoPlay: false,
      ),
      items: images?.map((e) => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children:<Widget> [
            cachedNetworkImage(e)
          ],
        ),
      )).toList(),
    );
  }
}
