import 'package:bookcenter/route/route_constants.dart';
import 'package:bookcenter/screens/checkout/views/empty_screen.dart';
import 'package:bookcenter/screens/product/views/components/product_list_tile.dart';
import 'package:bookcenter/screens/reviews/controllers/review_controller.dart';
import 'package:flutter/material.dart';
import 'package:bookcenter/components/review_card.dart';
import 'package:bookcenter/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import 'components/user_review_card.dart';

class ProductReviewsScreen extends StatefulWidget {
  const ProductReviewsScreen({Key? key}) : super(key: key);

  @override
  State<ProductReviewsScreen> createState() => _ProductReviewsScreenState();
}

class _ProductReviewsScreenState extends State<ProductReviewsScreen> {
  @override
  void initState() {
    Get.put(ProductReviewController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: const Text("Reviews"),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            sliver: SliverToBoxAdapter(
              child: GetX<ProductReviewController>(builder: (controller) {
                return ReviewCard(
                  rating: controller.reviewMatrix.value.avg!.toPrecision(2),
                  numOfReviews:
                      Get.find<ProductReviewController>().totalReview.value,
                  numOfFiveStar: Get.find<ProductReviewController>()
                      .reviewMatrix
                      .value
                      .fiveStars!,
                  numOfFourStar: Get.find<ProductReviewController>()
                      .reviewMatrix
                      .value
                      .fourStars!,
                  numOfThreeStar: Get.find<ProductReviewController>()
                      .reviewMatrix
                      .value
                      .threeStars!,
                  numOfTwoStar: Get.find<ProductReviewController>()
                      .reviewMatrix
                      .value
                      .twostars!,
                  numOfOneStar: Get.find<ProductReviewController>()
                      .reviewMatrix
                      .value
                      .onestar!,
                );
              }),
            ),
          ),

          if (Get.find<ProductReviewController>().product.paymentStatus == 'P')
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              sliver: ProductListTile(
                title: "Add Review",
                svgSrc: "assets/icons/Chat-add.svg",
                isShowBottomBorder: true,
                press: () {
                  Get.toNamed(
                    addReviewsScreenRoute,
                    arguments: Get.find<ProductReviewController>().product,
                  );
                },
              ),
            ),
          // SliverPadding(
          //   padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          //   sliver: SliverPersistentHeader(
          //     delegate: SortUserReview(),
          //     pinned: true,
          //   ),
          // ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding,
              vertical: defaultPadding / 2,
            ),
            sliver: SliverToBoxAdapter(
              child: Text(
                "User reviews",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            sliver: SliverToBoxAdapter(
              child: GetX<ProductReviewController>(
                builder: (controller) {
                  return controller.reviews.isEmpty &&
                          !controller.isFetchingProductReviews.value
                      ? const EmptyScreen(
                          title: 'No Reviews yet',
                        )
                      : SizedBox(
                          height: Get.height * 0.66,
                          child: ListView.builder(
                            controller: controller.scrollController,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: controller.reviews.length +
                                (controller.isFetchingProductReviews.value
                                    ? 1
                                    : 0),
                            itemBuilder: (context, index) {
                              if (controller.isFetchingProductReviews.value &&
                                  index >= controller.reviews.length) {
                                return const Center(
                                  child: SpinKitThreeBounce(
                                    color: primaryColor,
                                    size: 18.0,
                                  ),
                                );
                              }

                              return Padding(
                                padding:
                                    const EdgeInsets.only(top: defaultPadding),
                                child: UserReviewCard(
                                  title: controller.reviews[index].title ?? '',
                                  rating: double.parse(
                                    controller.reviews[index].ratings ?? '0.0',
                                  ),
                                  name: controller.reviews[index].user ?? '',
                                  review:
                                      controller.reviews[index].description ??
                                          '',
                                ),
                              );
                            },
                          ),
                        );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: defaultPadding * 1.5),
          ),
        ],
      ),
    );
  }
}
