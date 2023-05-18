import 'package:bookcenter/components/product/grid_product_card.dart';
import 'package:bookcenter/components/skleton/product/product_card_skelton.dart';
import 'package:bookcenter/screens/bookmark/controllers/bookmark_controller.dart';
import 'package:flutter/material.dart';
import 'package:bookcenter/route/route_constants.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../constants.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<BookmarkController>(
      init: BookmarkController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Wishlist"),
          ),
          body: controller.bookmarks.isEmpty &&
                  !controller.isFetchingBookmarks.value
              ? Column(
                  children: [
                    // Image.asset(
                    //   "assets/Illustration/EmptyState_lightTheme.png",
                    // ),
                    LottieBuilder.asset(
                      'assets/lottie/no-found-candles.json',
                    ),
                    const SizedBox(height: defaultPadding),
                    Text(
                      "No Bookmarks Found",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                )
              : GridView.builder(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.all(defaultPadding / 2),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.83,
                    crossAxisSpacing: defaultPadding,
                    mainAxisSpacing: defaultPadding,
                  ),
                  itemCount: controller.bookmarks.length +
                      (controller.isFetchingBookmarks.value
                          ? controller.bookmarks.isEmpty
                              ? 6
                              : controller.bookmarks.length % 2 == 0
                                  ? 2
                                  : 1
                          : 0),
                  itemBuilder: (context, index) {
                    if (controller.isFetchingBookmarks.value &&
                        index >= controller.bookmarks.length) {
                      return const ProductCardSkelton();
                    }

                    return Stack(
                      children: [
                        GridProductCard(
                          image: controller
                              .bookmarks[index].productImages![0].productImg,
                          title: controller.bookmarks[index].productTitle ??
                              'No Title',
                          price: double.parse(
                            controller.bookmarks[index].price ?? '0.0',
                          ),
                          dicountpercent: controller
                                      .bookmarks[index].discountInPercentage ==
                                  null
                              ? null
                              : int.parse(
                                  controller
                                      .bookmarks[index].discountInPercentage!
                                      .split('.')
                                      .first,
                                ),
                          priceAfetDiscount: double.parse(
                            controller.bookmarks[index].salePrice ??
                                controller.bookmarks[index].price!,
                          ),
                          press: () {
                            Get.toNamed(
                              productDetailsScreenRoute,
                              arguments: {
                                'productId': controller.bookmarks[index].id,
                                'isFromBookmarkScreen': true
                              },
                            );
                          },
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: PopupMenuButton(
                            icon: const Icon(
                              Icons.more_vert,
                              color: primaryColor,
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: TextButton(
                                  onPressed: () {
                                    controller.removeBookmark(
                                      controller.bookmarks[index].id!,
                                    );

                                    Get.back();
                                  },
                                  child: const Text("Remove from Wishlist"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
        );
      },
    );
  }
}
