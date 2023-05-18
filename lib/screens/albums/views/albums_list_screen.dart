import 'package:bookcenter/components/piil_button.dart';
import 'package:bookcenter/components/skleton/skelton.dart';
import 'package:bookcenter/constants.dart';
import 'package:bookcenter/route/screen_export.dart';
import 'package:bookcenter/screens/albums/controllers/albums_controller.dart';
import 'package:bookcenter/screens/albums/views/components/album_tile.dart';
import 'package:bookcenter/screens/checkout/views/empty_screen.dart';
import 'package:bookcenter/service/service_elements/album_payment_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AlbumsListScreen extends StatelessWidget {
  const AlbumsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Albums'),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(searchScreenRoute);
            },
            icon: SvgPicture.asset(
              "assets/icons/Search.svg",
              height: 24,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),
        ],
      ),
      body: GetX<AlbumController>(
        init: AlbumController(),
        builder: (controller) {
          return Column(
            children: [
              SizedBox(
                height: 40,
                child: ListView.builder(
                  controller: controller.languageScrollController,
                  itemCount: controller.isFetchingLanguages.value
                      ? controller.languages.length + 1
                      : controller.languages.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if (index >= controller.languages.length &&
                        controller.isFetchingAlbum.value) {
                      return const Skeleton(
                        width: 120,
                      );
                    }

                    return PillButton(
                      text: controller.languages[index].languageTitle ?? '',
                      isActive: controller.selectedLanguageIndex.value == index,
                      press: () {
                        if (controller.selectedLanguageIndex.value == index) {
                          return;
                        }

                        controller.selectedLanguageIndex.value = index;
                        controller.initFetchAlbums();
                      },
                      margin: const EdgeInsets.symmetric(
                        horizontal: defaultPadding / 4,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: defaultPadding),
              _buildFilter(controller),
              !controller.isFetchingAlbum.value && controller.albums.isEmpty
                  ? const EmptyScreen(
                      title: 'No albums found',
                    )
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          controller: controller.scrollController,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                            crossAxisSpacing: defaultPadding / 2,
                            mainAxisSpacing: defaultPadding / 2,
                          ),
                          itemCount: controller.isFetchingAlbum.value
                              ? controller.albums.length + 4
                              : controller.albums.length,
                          itemBuilder: (context, index) {
                            if (index >= controller.albums.length &&
                                controller.isFetchingAlbum.value) {
                              return const Skeleton();
                            }
                            return AlbumTile(
                              isPurchased:
                                  controller.albums[index].paymentStatus ==
                                          'P' &&
                                      controller.albums[index].paymentType ==
                                          'PAID',
                              onPressed: () {
                                if (controller.albums[index].paymentType ==
                                        'FREE' ||
                                    (controller.albums[index].paymentType ==
                                            'PAID' &&
                                        controller
                                                .albums[index].paymentStatus ==
                                            'P')) {
                                  Get.toNamed(
                                    albumViewScreenRoute,
                                    arguments: controller.albums[index],
                                  );
                                } else {
                                  // // log('Payment Bottom Sheet');
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return AlbumPaymentBottomSheet(
                                        album: controller.albums[index],
                                      );
                                    },
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    constraints: BoxConstraints(
                                      maxHeight: Get.width * 1.9,
                                      minHeight: Get.width * 1.9,
                                    ),
                                    isDismissible: false,
                                    enableDrag: false,
                                  );
                                }
                              },
                              albumLogo:
                                  controller.albums[index].albumLogo ?? '',
                              index: controller.albums[index].id!,
                            );
                          },
                        ),
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }

  Container _buildFilter(AlbumController controller) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(defaultBorderRadious),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left:
                controller.isFree.value ? defaultPadding / 2 : Get.width * 0.31,
            right:
                controller.isFree.value ? Get.width * 0.31 : defaultPadding / 2,
            child: Container(
              height: 35,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(
                  defaultBorderRadious,
                ),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  controller.isFree.value = true;
                  controller.initFetchAlbums();
                },
                child: SizedBox(
                  width: Get.width * 0.3,
                  child: Text(
                    "Free",
                    style: TextStyle(
                      color:
                          controller.isFree.value ? Colors.white : Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  controller.isFree.value = false;
                  controller.initFetchAlbums();
                },
                child: SizedBox(
                  width: Get.width * 0.3,
                  child: Text(
                    "Paid",
                    style: TextStyle(
                      color:
                          controller.isFree.value ? Colors.black : Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
