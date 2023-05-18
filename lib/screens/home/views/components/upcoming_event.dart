import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:bookcenter/components/skleton/others/offers_skelton.dart';
import 'package:bookcenter/route/route_constants.dart';
import 'package:bookcenter/screens/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:bookcenter/components/Banner/M/banner_m_style_1.dart';
import 'package:bookcenter/components/Banner/M/banner_m_style_2.dart';
import 'package:bookcenter/components/Banner/M/banner_m_style_3.dart';
import 'package:bookcenter/components/Banner/M/banner_m_style_4.dart';
import 'package:bookcenter/components/dot_indicators.dart';
import 'package:get/get.dart';

import '../../../../constants.dart';

class UpcomingEventCarousel extends StatefulWidget {
  const UpcomingEventCarousel({
    Key? key,
  }) : super(key: key);

  @override
  State<UpcomingEventCarousel> createState() => _UpcomingEventCarouselState();
}

class _UpcomingEventCarouselState extends State<UpcomingEventCarousel> {
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
  void initState() {
    Get.put(HomeController(), permanent: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
      builder: (controller) {
        return controller.isFetchingUpcomingEvents.value
            ?
            // While loading use 👇
            const OffersSkelton()
            : AspectRatio(
                aspectRatio: 1.87,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    PageView.builder(
                      controller: controller.upcomingEventPageController,
                      itemCount: controller.upcomingEvents.length,
                      onPageChanged: (int index) {
                        controller.currentUpcomingEvent.value = index;
                      },
                      // itemBuilder: (context, index) => offers[index],
                      itemBuilder: (context, index) => getRandomBanner(
                        controller.upcomingEvents[index].promoTitle,
                        controller.upcomingEvents[index].promoDescription,
                        null,
                        () {
                          controller.handleUpcomingEventClick(
                            upcomingEvent: controller.upcomingEvents[index],
                            index: index,
                            context: context,
                          );
                        },
                        controller.upcomingEvents[index].promoImg,
                      ),
                    ),
                    FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: SizedBox(
                          height: 16,
                          child: Row(
                            children: List.generate(
                              controller.upcomingEvents.length,
                              (index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: defaultPadding / 4),
                                  child: DotIndicator(
                                    isActive: index ==
                                        controller.currentUpcomingEvent.value,
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
    return BannerMStyle1(
      text: title,
      press: press,
      image: image,
      subTitle: subTitle,
    );
    // var random = math.Random().nextInt(4);
    // switch (random) {
    //   case 0:

    //   case 1:
    //     return BannerMStyle2(
    //       title: title,
    //       subtitle: subTitle,
    //       discountParcent: discountParcent,
    //       press: press,
    //       image: image,
    //     );
    //   case 2:
    //     return BannerMStyle3(
    //       title: title,
    //       discountParcent: discountParcent,
    //       press: press,
    //       image: image,
    //     );
    //   case 3:
    //     return BannerMStyle4(
    //       title: title,
    //       subtitle: subTitle,
    //       discountParcent: discountParcent,
    //       press: press,
    //       image: image,
    //     );
    // }
    // return random;
  }
}
