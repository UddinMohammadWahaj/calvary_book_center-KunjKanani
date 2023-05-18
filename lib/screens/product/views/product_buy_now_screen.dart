import 'package:bookcenter/screens/product/controllers/product_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:bookcenter/components/cart_button.dart';
import 'package:bookcenter/components/custom_modal_bottom_sheet.dart';
import 'package:bookcenter/components/network_image_with_loader.dart';
import 'package:bookcenter/screens/product/views/added_to_cart_message_screen.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import 'components/product_quantity.dart';
import 'components/unit_price.dart';

class ProductBuyNowScreen extends StatelessWidget {
  const ProductBuyNowScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<ProductDetailController>(
      builder: (productDetailController) {
        return Scaffold(
          bottomNavigationBar: CartButton(
            price: productDetailController.productPrice *
                productDetailController.quantity.value,
            quantity: productDetailController.quantity.value,
            title: "Add to cart",
            subTitle: "Total price",
            press: () async {
              await productDetailController.addToCart();

              customModalBottomSheet(
                Get.context!,
                isDismissible: true,
                child: const AddedToCartMessageScreen(),
              );
            },
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding / 2, vertical: defaultPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const BackButton(),
                    Expanded(
                      child: Text(
                        productDetailController.productDetails!.productTitle!,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: 18,
                              overflow: TextOverflow.ellipsis,
                            ),
                      ),
                    ),
                    // IconButton(
                    //   onPressed: () {
                    //     ProductDetailController controller =
                    //         Get.find<ProductDetailController>();
                    //     if (controller.isBookmarked.value) {
                    //               controller.removeBookmark();
                    //             } else {
                    //               controller.addBookmark();
                    //               _animationController.forward(from: 0.0);
                    //             }
                    //   },
                    //   icon: SvgPicture.asset("assets/icons/Bookmark.svg",
                    //       color: Theme.of(context).textTheme.bodyText1!.color),
                    // ),
                  ],
                ),
              ),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding),
                        child: AspectRatio(
                          aspectRatio: 1.05,
                          child: NetworkImageWithLoader(
                            productDetailController
                                .productDetails!.productImages![0].productImg,
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(defaultPadding),
                      sliver: SliverToBoxAdapter(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: UnitPrice(
                                price: double.parse(productDetailController
                                        .productDetails!.price ??
                                    "0.0"),
                                priceAfterDiscount: double.parse(
                                    productDetailController
                                            .productDetails!.salePrice ??
                                        "0.0"),
                              ),
                            ),
                            ProductQuantity(
                              numOfItem: productDetailController.quantity.value,
                              onIncrement: () {
                                if (productDetailController.quantity.value ==
                                    productDetailController
                                        .productDetails!.stock) {
                                  return;
                                }

                                productDetailController.quantity.value++;
                              },
                              onDecrement: () {
                                if (productDetailController.quantity.value ==
                                    1) {
                                  return;
                                }
                                productDetailController.quantity.value--;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: Divider()),
                    // SliverToBoxAdapter(
                    //   child: SelectedColors(
                    //     colors: const [
                    //       Color(0xFFEA6262),
                    //       Color(0xFFB1CC63),
                    //       Color(0xFFFFBF5F),
                    //       Color(0xFF9FE1DD),
                    //       Color(0xFFC482DB),
                    //     ],
                    //     selectedColorIndex: 2,
                    //     press: (value) {},
                    //   ),
                    // ),
                    // SliverToBoxAdapter(
                    //   child: SelectedSize(
                    //     sizes: const ["S", "M", "L", "XL", "XXL"],
                    //     selectedIndex: 1,
                    //     press: (value) {},
                    //   ),
                    // ),
                    // SliverPadding(
                    //   padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                    //   sliver: ProductListTile(
                    //     title: "Size guide",
                    //     svgSrc: "assets/icons/Sizeguid.svg",
                    //     isShowBottomBorder: true,
                    //     press: () {
                    //       customModalBottomSheet(
                    //         context,
                    //         height: MediaQuery.of(context).size.height * 0.9,
                    //         child: const SizeGuideScreen(),
                    //       );
                    //     },
                    //   ),
                    // ),
                    // SliverPadding(
                    //   padding:
                    //       const EdgeInsets.symmetric(horizontal: defaultPadding),
                    //   sliver: SliverToBoxAdapter(
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         const SizedBox(height: defaultPadding / 2),
                    //         Text(
                    //           "Store pickup availability",
                    //           style: Theme.of(context).textTheme.subtitle2,
                    //         ),
                    //         const SizedBox(height: defaultPadding / 2),
                    //         const Text(
                    //             "Select a size to check store availability and In-Store pickup options.")
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // SliverPadding(
                    //   padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                    //   sliver: ProductListTile(
                    //     title: "Check stores",
                    //     svgSrc: "assets/icons/Stores.svg",
                    //     isShowBottomBorder: true,
                    //     press: () {
                    //       customModalBottomSheet(
                    //         context,
                    //         height: MediaQuery.of(context).size.height * 0.92,
                    //         child: const LocationPermissonStoreAvailabilityScreen(),
                    //       );
                    //     },
                    //   ),
                    // ),
                    // const SliverToBoxAdapter(
                    //     child: SizedBox(height: defaultPadding))
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
