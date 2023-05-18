import 'dart:developer';

import 'package:bookcenter/components/skleton/skelton.dart';
import 'package:bookcenter/constants.dart';
import 'package:bookcenter/models/book_model.dart';
import 'package:bookcenter/route/route_constants.dart';
import 'package:bookcenter/screens/daily_promises/controllers/daily_promises_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class DailyPromisesScreen extends StatelessWidget {
  const DailyPromisesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Promises"),
        actions: const [
          // IconButton(
          //   onPressed: () {
          //     // final val = Get.find<DailyPromissesController>()
          //     //     .isFetchingDailyPromises
          //     //     .value;
          //     // Get.find<DailyPromissesController>()
          //     //     .isFetchingDailyPromises
          //     //     .value = !val;
          //   },
          //   icon: SvgPicture.asset(
          //     "assets/icons/DotsV.svg",
          //     color: Theme.of(context).iconTheme.color,
          //   ),
          // )
        ],
      ),
      body: SafeArea(
        child: GetX<DailyPromissesController>(
            init: DailyPromissesController(),
            builder: (controller) {
              return PageView.builder(
                itemCount: controller.isFetchingDailyPromises.value
                    ? 3
                    : controller.dailyPromises.length,
                itemBuilder: (context, index) {
                  return controller.isFetchingDailyPromises.value
                      ? Container(
                          margin: const EdgeInsets.all(defaultPadding),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .iconTheme
                                .color!
                                .withOpacity(0.04),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: const [
                              SizedBox(height: defaultPadding * 3),
                              Skeleton(
                                height: 70,
                                width: 260,
                              ),
                              Skeleton(
                                height: 20,
                                width: 300,
                              ),
                              SizedBox(height: defaultPadding * 2),
                              Skeleton(
                                height: 260,
                                width: 340,
                              ),
                            ],
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: defaultPadding,
                            vertical: defaultPadding,
                          ),
                          decoration: BoxDecoration(
                            // Random Color
                            color: Colors
                                .primaries[index % Colors.primaries.length],
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(0, 17),
                                blurRadius: 23,
                                spreadRadius: -13,
                                color: Colors.black12,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const SizedBox(height: defaultPadding * 5),
                              DefaultTextStyle(
                                style: const TextStyle(
                                  fontFamily: grandisExtendedFont,
                                  fontSize: 48,
                                  height: 1.2,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(
                                      children: <Widget>[
                                        // Stroked text as border.
                                        Text(
                                          'Promise ${index + 1}',
                                          style: TextStyle(
                                            foreground: Paint()
                                              ..style = PaintingStyle.stroke
                                              ..strokeWidth = 1.4
                                              ..color = Colors.white38,
                                          ),
                                        ),
                                        // Solid text as fill for daily promises small slogan
                                        Positioned(
                                          top: -4,
                                          right: -4,
                                          child: Text('Promise ${index + 1}'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: defaultPadding / 2,
                                  vertical: defaultPadding / 8,
                                ),
                                color: Colors.white70,
                                child: Text(
                                  controller
                                          .dailyPromises[index].everydayTitle ??
                                      '',
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: defaultPadding * 2),
                              CachedNetworkImage(
                                imageUrl: controller
                                        .dailyPromises[index].dailyVidImg ??
                                    '',
                                fit: BoxFit.scaleDown,
                              ),
                              // const SizedBox(height: defaultPadding),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    if (controller.dailyPromises[index]
                                            .dailyVideoUrl !=
                                        null)
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () {
                                            Get.toNamed(
                                              youtubePlayerScreenRoute,
                                              arguments: {
                                                'initialVideoId':
                                                    YoutubePlayerController
                                                        .convertUrlToId(
                                                  controller
                                                          .dailyPromises[index]
                                                          .dailyVideoUrl ??
                                                      '',
                                                ),
                                              },
                                            );
                                          },
                                          child: const Text(
                                            "Watch Now",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (controller.dailyPromises[index]
                                            .dailyVideoUrl !=
                                        null)
                                      const SizedBox(width: defaultPadding),
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () {
                                          Get.toNamed(
                                            calvaryPdfViewerScreenRoute,
                                            arguments: {
                                              'book': BookModel(
                                                id: -1,
                                                bookTitle: 'Daily Promise',
                                                book: controller
                                                    .dailyPromises[index]
                                                    .dailyPdf,
                                                paymentStatus: 'P',
                                                isDownloaded: false,
                                              )
                                            },
                                          );
                                        },
                                        child: const Text(
                                          "Read Now",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                },
              );
            }),
      ),
    );
  }
}
