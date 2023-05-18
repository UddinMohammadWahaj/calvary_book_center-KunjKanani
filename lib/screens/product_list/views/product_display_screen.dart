import 'package:bookcenter/components/piil_button.dart';
import 'package:bookcenter/components/product/grid_product_card.dart';
import 'package:bookcenter/components/skleton/product/product_card_skelton.dart';
import 'package:bookcenter/models/product_model.dart';
import 'package:bookcenter/route/screen_export.dart';
import 'package:bookcenter/screens/checkout/views/empty_screen.dart';
import 'package:bookcenter/screens/home/views/components/categories.dart';
import 'package:bookcenter/screens/product_list/controllers/product_display_controller.dart';
import 'package:flutter/material.dart';
import 'package:bookcenter/components/shopping_bag.dart';
import 'package:bookcenter/constants.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ProductDisplayScreen extends StatelessWidget {
  final ProductDisplayController productDisplayController =
      Get.put(ProductDisplayController());
  ProductDisplayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              title: Text(
                productDisplayController.title.value,
              ),
              actions: const [
                // ShoppingBag(
                //   numOfItem: 3,
                // ),
              ],
            ),
            SliverAppBar(
              floating: true,
              snap: true,
              titleSpacing: 0,
              automaticallyImplyLeading: false,
              title: GetX<ProductDisplayController>(
                builder: (controller) {
                  return SingleChildScrollView(
                    controller: controller.scrollControllerForCategories,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ...List.generate(
                          controller.subCategories.length,
                          (index) => Padding(
                            key: controller.keysForCategories[index],
                            padding: EdgeInsets.only(
                              left: index == 0
                                  ? defaultPadding
                                  : defaultPadding / 2,
                              right:
                                  index == controller.subCategories.length - 1
                                      ? defaultPadding
                                      : 0,
                            ),
                            child: PillButton(
                              isActive: index == controller.selectedIndex.value,
                              press: () {
                                controller.selectedIndex.value = index;
                                controller.initProductFetch();
                              },
                              text: controller.subCategories[index].name ?? ' ',
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Sliver grid for popular products
            productDisplayController.obx(
              (state) {
                return SliverToBoxAdapter(
                  child: SizedBox(
                    height: Get.height * 0.75,
                    child: GridView.builder(
                      padding: const EdgeInsets.all(defaultPadding / 2),
                      controller: productDisplayController.scrollController,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: defaultPadding,
                        mainAxisSpacing: defaultPadding,
                      ),
                      itemCount: productDisplayController.products.length +
                          (productDisplayController.isFetchingProduct
                              ? productDisplayController.products.length % 2 ==
                                      0
                                  ? 2
                                  : 1
                              : 0),
                      itemBuilder: (context, index) {
                        if (productDisplayController.isFetchingProduct &&
                            index >= productDisplayController.products.length) {
                          return const ProductCardSkelton();
                        }

                        return GridProductCard(
                          image: productDisplayController
                              .products[index].productImages![0].productImg,
                          title: productDisplayController
                              .products[index].productTitle!,
                          price: double.parse(
                            productDisplayController.products[index].price!,
                          ),
                          // brandName: 'Calvary',
                          // dicountpercent: 10,
                          dicountpercent: productDisplayController
                                      .products[index].discountInPercentage ==
                                  null
                              ? null
                              : int.parse(
                                  productDisplayController
                                      .products[index].discountInPercentage!
                                      .split('.')
                                      .first,
                                ),
                          // priceAfetDiscount: 100,
                          priceAfetDiscount: double.parse(
                            productDisplayController
                                    .products[index].salePrice ??
                                productDisplayController.products[index].price!,
                          ),
                          press: () {
                            Get.toNamed(
                              productDetailsScreenRoute,
                              arguments: {
                                'productId':
                                    productDisplayController.products[index].id,
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              },
              onEmpty: const SliverToBoxAdapter(
                child: EmptyScreen(
                  title: "No Product Found",
                ),
              ),
              onLoading: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return const ProductCardSkelton();
                  },
                  childCount: 6,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.83,
                  crossAxisSpacing: defaultPadding,
                  mainAxisSpacing: defaultPadding,
                ),
              ),
            ),

            // SliverToBoxAdapter(
            //   child: SizedBox(
            //     height: 200,
            //   ),
            // ),

            // const SliverPadding(
            //   padding: EdgeInsets.only(top: defaultPadding),
            //   sliver: SliverToBoxAdapter(
            //     child: FlashSale(),
            //   ),
            // ),
            // SliverPadding(
            //   padding: const EdgeInsets.only(top: defaultPadding),
            //   sliver: SliverToBoxAdapter(
            //     child: Column(
            //       children: [
            //         BannerSStyle1(
            //           image: "https://i.imgur.com/JLTfORi.png",
            //           title: "New \narrival",
            //           subtitle: "SPECIAL OFFER",
            //           discountParcent: 50,
            //           press: () {},
            //         ),
            //         const SizedBox(height: defaultPadding / 4),
            //         BannerSStyle4(
            //           title: "SUMMER \nSALE",
            //           subtitle: "SPECIAL OFFER",
            //           bottomText: "UP TO 80% OFF",
            //           press: () {},
            //         ),
            //         const SizedBox(height: defaultPadding / 4),
            //         BannerSStyle4(
            //           image: "https://i.imgur.com/g2cQFBs.png",
            //           title: "Black \nfriday",
            //           subtitle: "50% off",
            //           bottomText: "Collection".toUpperCase(),
            //           press: () {},
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // const SliverToBoxAdapter(
            //   child: PopularProducts(),
            // ),
            // const SliverToBoxAdapter(
            //   child: MostPopular(),
            // ),
            // SliverPadding(
            //   padding: const EdgeInsets.only(top: defaultPadding),
            //   sliver: SliverToBoxAdapter(
            //     child: BannerLStyle1(
            //       image: "https://i.imgur.com/u01Opt8.png",
            //       title: "SUMMER \nSALE",
            //       subtitle: "SPECIAL OFFER",
            //       discountPercent: 50,
            //       press: () {},
            //     ),
            //   ),
            // ),
            // const SliverToBoxAdapter(
            //   child: BestSellers(),
            // ),
          ],
        ),
      ),
    );
  }
}
