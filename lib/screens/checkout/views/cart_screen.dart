import 'dart:developer';

import 'package:bookcenter/screens/checkout/controllers/cart_controller.dart';
import 'package:bookcenter/screens/checkout/views/components/cart_product_tile.dart';
import 'package:bookcenter/screens/checkout/views/empty_screen.dart';
import 'package:flutter/material.dart';
import 'package:bookcenter/route/screen_export.dart';
import 'package:bookcenter/screens/order/views/components/order_summary_card.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import 'components/coupon_code.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: GetX<CartController>(
        init: CartController(),
        builder: (controller) {
          return Visibility(
            visible: controller.cartItems.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: defaultPadding / 2,
                horizontal: defaultPadding,
              ),
              child: ElevatedButton(
                onPressed: () {
                  controller.initAddresses();
                  Get.toNamed(
                    selectAddressScreenRoute,
                  );
                },
                child: const Text("Continue"),
              ),
            ),
          );
        },
      ),
      body: Stack(
        children: [
          GetX<CartController>(
            builder: (controller) {
              return controller.cartItems.isEmpty
                  ? const EmptyScreen(
                      title: "Your cart is empty",
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding),
                      child: CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Text(
                              "Review your order",
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ),
                          // While loading use 👇
                          // const ReviewYourItemsSkelton(),
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding,
                            ),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: defaultPadding),
                                  child: CartProductTile(
                                    image: controller.cartItems[index]
                                        .productImages!.first.productImg,
                                    // brandName: controller.cartItems[index].brandName,
                                    title: controller
                                            .cartItems[index].productTitle ??
                                        '',
                                    price: double.parse(
                                        controller.cartItems[index].price ??
                                            '0'),
                                    priceAfetDiscount: double.parse(
                                      controller.cartItems[index].salePrice ??
                                          '0',
                                    ),
                                    product: controller.cartItems[index],
                                  ),
                                ),
                                childCount: controller.cartItems.length,
                              ),
                            ),
                          ),
                          const SliverToBoxAdapter(
                            child: CouponCode(),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding,
                            ),
                            sliver: SliverToBoxAdapter(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // GetX<CartController>(
                                  //   builder: (controller) {
                                  //     return Row(
                                  //       crossAxisAlignment:
                                  //           CrossAxisAlignment.center,
                                  //       mainAxisAlignment: MainAxisAlignment.start,
                                  //       children: [
                                  //         _buildTipChip(
                                  //           index: 1,
                                  //           amount: 10,
                                  //           selectedIndex:
                                  //               controller.selectedTipIndex.value,
                                  //           isFavorite: true,
                                  //         ),
                                  //         const SizedBox(
                                  //           width: defaultPadding / 2,
                                  //         ),
                                  //         _buildTipChip(
                                  //           index: 2,
                                  //           amount: 25,
                                  //           selectedIndex:
                                  //               controller.selectedTipIndex.value,
                                  //         ),
                                  //         const SizedBox(
                                  //           width: defaultPadding / 2,
                                  //         ),
                                  //         _buildTipChip(
                                  //           index: 3,
                                  //           amount: 50,
                                  //           selectedIndex:
                                  //               controller.selectedTipIndex.value,
                                  //         ),
                                  //       ],
                                  //     );
                                  //   },
                                  // ),
                                  GetX<CartController>(
                                    builder: (controller) {
                                      return CheckboxListTile(
                                        value: controller.isDonation.value,
                                        onChanged: (val) {
                                          if (!(val ?? false)) {
                                            controller.donationAmount.text = '';
                                          }

                                          controller.isDonation.value = val!;

                                          controller.countTotalPrice();
                                        },
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(
                                          'I would like to donate.',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                      );
                                      // return Row(
                                      //   children: [
                                      //     Checkbox(
                                      //       value: controller.isDonation.value,
                                      //       onChanged: (val) {

                                      //       },
                                      //     ),

                                      //   ],
                                      // );
                                    },
                                  ),
                                  GetX<CartController>(
                                    builder: (controller) {
                                      return Visibility(
                                        visible: controller.isDonation.value,
                                        child: TextFormField(
                                          controller: controller.donationAmount,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          textInputAction: TextInputAction.done,
                                          decoration: const InputDecoration(
                                            hintText: 'Enter amount',
                                            border: OutlineInputBorder(),
                                          ),
                                          onChanged: (val) {
                                            controller.countTotalPrice();
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: OrderSummaryCard(
                              subTotal:
                                  controller.subTotalPriceWithoutDiscount.value,
                              discount: controller.saleDiscount.value,
                              totalWithTaxes: controller.totalPrice.value,
                              shippingFee: 0,
                              couponDiscount: controller.couponDiscount.value,
                              tip: double.tryParse(
                                controller.donationAmount.text,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
            },
          ),
          // Keyboard dismiss button if keyboard is open

          KeyboardVisibilityBuilder(
            builder: (context, isKeyboardVisible) {
              return !isKeyboardVisible
                  ? Container()
                  : Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                            },
                            child: const Text(
                              "Done",
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
            },
          )
        ],
      ),
    );
  }

  Widget _buildTipChip({
    required int index,
    required int selectedIndex,
    required int amount,
    bool isFavorite = false,
  }) {
    return Expanded(
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (selectedIndex == index) {
                Get.find<CartController>().selectedTipIndex.value = 0;
                Get.find<CartController>().countTotalPrice();
              } else {
                Get.find<CartController>().selectedTipIndex.value = index;
                Get.find<CartController>().countTotalPrice();
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: selectedIndex == index ? primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(
                  10,
                ),
                border: Border.all(
                  color: selectedIndex == index ? Colors.white : Colors.black12,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: defaultPadding,
              ),
              margin: const EdgeInsets.symmetric(
                vertical: defaultPadding,
              ),
              child: Center(
                child: Text(
                  '₹ $amount',
                  style: TextStyle(
                    color: selectedIndex == index ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          if (isFavorite)
            Positioned(
              top: 3,
              left: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2D2F94),
                  borderRadius: BorderRadius.circular(
                    defaultBorderRadious / 2,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding / 2,
                  vertical: defaultPadding / 6,
                ),
                child: const Text(
                  'Jesus\'s\nDay',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
