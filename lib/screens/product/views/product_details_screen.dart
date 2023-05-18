import 'package:bookcenter/screens/checkout/views/empty_screen.dart';
import 'package:bookcenter/screens/product/controllers/product_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bookcenter/components/cart_button.dart';
import 'package:bookcenter/components/custom_modal_bottom_sheet.dart';
import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/product/views/product_info_screen.dart';
import 'package:bookcenter/route/screen_export.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'components/notify_me_card.dart';
import 'components/product_images.dart';
import 'components/product_info.dart';
import 'components/product_list_tile.dart';
import '../../../components/review_card.dart';
import 'product_buy_now_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>
    with SingleTickerProviderStateMixin {
  // final bool isProductAvailable;

  late final AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
    );

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetX<ProductDetailController>(
        init: ProductDetailController(),
        builder: (controller) {
          return Scaffold(
            bottomNavigationBar: !controller.isFetchingProductDetail.value &&
                    controller.productDetails != null
                ? controller.productDetails!.stock! > 0
                    ? CartButton(
                        quantity: controller.quantity.value,
                        price: controller.productPrice,
                        press: () {
                          customModalBottomSheet(
                            context,
                            height: MediaQuery.of(context).size.height * 0.92,
                            child: const ProductBuyNowScreen(),
                          );
                        },
                      )
                    : NotifyMeCard(
                        isNotify: false,
                        onChanged: (value) {},
                      )
                : const SizedBox(),
            body: SafeArea(
              child: controller.isFetchingProductDetail.value
                  ? const SpinKitThreeBounce(
                      color: primaryColor,
                      size: 20,
                    )
                  : controller.productDetails == null
                      ? const EmptyScreen(
                          title: 'Product Not available',
                        )
                      : CustomScrollView(
                          slivers: [
                            SliverAppBar(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              floating: true,
                              actions: [
                                IconButton(
                                  onPressed: () {
                                    if (controller.isBookmarked.value) {
                                      controller.removeBookmark();
                                    } else {
                                      controller.addBookmark();
                                      _animationController.forward(from: 0.0);
                                    }
                                  },
                                  icon: Lottie.asset(
                                    'assets/lottie/bookmark.json',
                                    animate: false,
                                    controller: controller.isBookmarked.value
                                        ? _animationController
                                        : null,
                                    onLoaded: (composition) {
                                      // Configure the AnimationController with the duration of the
                                      // Lottie file and start the animation.
                                      _animationController
                                        ..duration = composition.duration
                                        ..forward();
                                    },
                                  ),
                                ),
                              ],
                            ),
                            ProductImages(
                              images: controller.productDetails!.productImages!
                                  .map((e) => e.productImg)
                                  .toList(),
                            ),
                            ProductInfo(
                              brand: "CALVARY",
                              title:
                                  controller.productDetails!.productTitle ?? "",
                              // TODO: Add IsAvailable here
                              isAvailable:
                                  (controller.productDetails!.stock ?? 0) > 0,
                              rating: controller
                                  .productDetails!.reviewMatrix!.avg!
                                  .toPrecision(2),
                              numOfReviews: controller.totalReview,
                            ),
                            ProductListTile(
                              svgSrc: "assets/icons/Product.svg",
                              title: "Product Details",
                              press: () {
                                customModalBottomSheet(
                                  context,
                                  height:
                                      MediaQuery.of(context).size.height * 0.92,
                                  child: ProductInfoScreen(
                                    // htmlDescription: controller
                                    //         .productDetails!.productDescription ??
                                    //     "",
                                    text: controller.productDetails!
                                            .productDescription ??
                                        "",
                                  ),
                                );
                              },
                            ),
                            // ProductListTile(
                            //   svgSrc: "assets/icons/Delivery.svg",
                            //   title: "Shipping Information",
                            //   press: () {
                            //     customModalBottomSheet(
                            //       context,
                            //       height: MediaQuery.of(context).size.height * 0.92,
                            //       child: const ShippingMethodsScreen(),
                            //     );
                            //   },
                            // ),
                            // ProductListTile(
                            //   svgSrc: "assets/icons/Return.svg",
                            //   title: "Returns",
                            //   isShowBottomBorder: true,
                            //   press: () {
                            //     customModalBottomSheet(
                            //       context,
                            //       height: MediaQuery.of(context).size.height * 0.92,
                            //       child: const ProductReturnsScreen(),
                            //     );
                            //   },
                            // ),
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.all(defaultPadding),
                                child: ReviewCard(
                                  rating: controller
                                      .productDetails!.reviewMatrix!.avg!
                                      .toPrecision(2),
                                  numOfReviews: controller.totalReview,
                                  numOfFiveStar: controller
                                      .productDetails!.reviewMatrix!.fiveStars!,
                                  numOfFourStar: controller
                                      .productDetails!.reviewMatrix!.fourStars!,
                                  numOfThreeStar: controller.productDetails!
                                      .reviewMatrix!.threeStars!,
                                  numOfTwoStar: controller
                                      .productDetails!.reviewMatrix!.twostars!,
                                  numOfOneStar: controller
                                      .productDetails!.reviewMatrix!.onestar!,
                                ),
                              ),
                            ),
                            ProductListTile(
                              svgSrc: "assets/icons/Chat.svg",
                              title: "Reviews",
                              isShowBottomBorder: true,
                              press: () {
                                Get.toNamed(
                                  productReviewsScreenRoute,
                                  arguments: {
                                    "productId": controller.productDetails!.id,
                                    "productReviewMatrix":
                                        controller.productDetails!.reviewMatrix,
                                    "product": controller.productDetails,
                                  },
                                );
                              },
                            ),
                            const SliverToBoxAdapter(
                              child: SizedBox(height: defaultPadding),
                            )
                          ],
                        ),
            ),
          );
        });
  }
}
