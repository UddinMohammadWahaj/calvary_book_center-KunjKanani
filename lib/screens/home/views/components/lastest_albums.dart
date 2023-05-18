import 'dart:math';
import 'dart:developer' as developer;

import 'package:bookcenter/components/skleton/others/offers_skelton.dart';
import 'package:bookcenter/route/screen_export.dart';
import 'package:bookcenter/screens/albums/controllers/albums_controller.dart';
import 'package:bookcenter/screens/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:bookcenter/components/Banner/M/banner_m_style_1.dart';
import 'package:bookcenter/components/Banner/M/banner_m_style_2.dart';
import 'package:bookcenter/components/Banner/M/banner_m_style_3.dart';
import 'package:bookcenter/components/Banner/M/banner_m_style_4.dart';
import 'package:bookcenter/components/dot_indicators.dart';
import 'package:get/get.dart';

import '../../../../constants.dart';

class LatestAlbumsCarousel extends StatefulWidget {
  const LatestAlbumsCarousel({
    Key? key,
  }) : super(key: key);

  @override
  State<LatestAlbumsCarousel> createState() => _LatestAlbumsCarouselState();
}

class _LatestAlbumsCarouselState extends State<LatestAlbumsCarousel> {
  // Offers List
  // List offers = [
  //   BannerMStyle1(
  //     text: "New items with \nFree shipping",
  //     press: () {},
  //   ),
  //   BannerMStyle2(
  //     title: "Black \nfriday",
  //     subtitle: "Collection",
  //     discountParcent: 50,
  //     press: () {},
  //   ),
  //   BannerMStyle3(
  //     title: "Grab \nyours now",
  //     discountParcent: 50,
  //     press: () {},
  //   ),
  //   BannerMStyle4(
  //     // image: , user your image
  //     title: "SUMMER \nSALE",
  //     subtitle: "SPECIAL OFFER",
  //     discountParcent: 80,
  //     press: () {},
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
      builder: (controller) {
        return controller.isFetchingLastestAlbum.value
            ?
            // While loading use 👇
            const OffersSkelton()
            : AspectRatio(
                aspectRatio: 1.87,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    PageView.builder(
                      controller: controller.lastestAlbumPageController,
                      itemCount: controller.lastestAlbums.length,
                      onPageChanged: (int index) {
                        controller.currentLastestAlbum.value = index;
                      },
                      itemBuilder: (context, index) => BannerMStyle1(
                        press: () {
                          Get.toNamed(
                            albumViewScreenRoute,
                            arguments: controller.lastestAlbums[index],
                          );
                        },
                        text: controller.lastestAlbums[index].albumTitle ?? '',
                        image: controller.lastestAlbums[index].albumSlider,
                      ),
                    ),
                    FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: SizedBox(
                          height: 16,
                          child: Row(
                            children: List.generate(
                              controller.lastestAlbums.length,
                              (index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: defaultPadding / 4),
                                  child: DotIndicator(
                                    isActive: index ==
                                        controller.currentLastestAlbum.value,
                                    activeColor: Colors.white70,
                                    inActiveColor: Colors.white54,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }

  getRandomBanner(title, subTitle, discountParcent, press, image) {
    var random = Random().nextInt(4);
    switch (random) {
      case 0:
        return BannerMStyle1(
          text: title,
          press: press,
          image: image,
        );
      case 1:
        return BannerMStyle2(
          title: title,
          subtitle: subTitle,
          discountParcent: discountParcent,
          press: press,
          image: image,
        );
      case 2:
        return BannerMStyle3(
          title: title,
          discountParcent: discountParcent,
          press: press,
          image: image,
        );
      case 3:
        return BannerMStyle4(
          title: title,
          subtitle: subTitle,
          discountParcent: discountParcent,
          press: press,
          image: image,
        );
    }

    return random;
  }
}
