import 'dart:developer';
import 'dart:math' as math;

import 'package:bookcenter/screens/checkout/controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../constants.dart';

class CouponCode extends StatefulWidget {
  const CouponCode({
    Key? key,
  }) : super(key: key);

  @override
  State<CouponCode> createState() => _CouponCodeState();
}

class _CouponCodeState extends State<CouponCode> {
  @override
  Widget build(BuildContext context) {
    return GetX<CartController>(
      builder: (controller) {
        return controller.currentCoupon.value.code != null
            ? Row(
                children: [
                  Transform.rotate(
                    angle: -math.pi / 4,
                    child: SvgPicture.asset(
                      "assets/icons/Coupon.svg",
                      color: Theme.of(context)
                          .inputDecorationTheme
                          .hintStyle!
                          .color!,
                    ),
                  ),
                  const SizedBox(width: defaultPadding),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: "${controller.currentCoupon.value.code}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                        children: const [
                          TextSpan(
                            text: " applied",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: blackColor40,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      controller.removeCoupon();
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Coupon code",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: defaultPadding),
                  OutlinedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        constraints: BoxConstraints(
                          minHeight: Get.height * 0.8,
                          maxHeight: Get.height * 0.8,
                        ),
                        isScrollControlled: true,
                        isDismissible: false,
                        enableDrag: false,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(defaultBorderRadious),
                            topRight: Radius.circular(defaultBorderRadious),
                          ),
                        ),
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(defaultPadding * 1.5),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    icon: const Icon(Icons.close),
                                  ),
                                ),
                                const SizedBox(height: defaultPadding),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/Coupon.svg",
                                      color: Theme.of(context)
                                          .inputDecorationTheme
                                          .hintStyle!
                                          .color!,
                                    ),
                                    const SizedBox(width: defaultPadding),
                                    const Text("Apply a coupon code"),
                                  ],
                                ),
                                const SizedBox(height: defaultPadding * 2),
                                // TextFormField(
                                //   // autofocus: true,
                                //   onSaved: (code) {
                                //     // log(code!);
                                //   },
                                //   textAlign: TextAlign.center,
                                //   onChanged: (value) {},
                                //   decoration: InputDecoration(
                                //     hintText: "Enter your coupon code here",
                                //     suffixIcon: Padding(
                                //       padding:
                                //           const EdgeInsets.only(right: 8.0),
                                //       child: TextButton(
                                //         child: const Text(
                                //           "Apply",
                                //           style: TextStyle(color: primaryColor),
                                //         ),
                                //         onPressed: () {},
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                // const SizedBox(height: defaultPadding * 2),
                                Expanded(
                                  child: ListView.builder(
                                    controller:
                                        controller.couponScrollController,
                                    itemCount:
                                        controller.isFetchingCoupons.value
                                            ? controller.coupons.length + 1
                                            : controller.coupons.length,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      if (index == controller.coupons.length) {
                                        return const Center(
                                          child: SpinKitThreeBounce(
                                            color: primaryColor,
                                            size: 18.0,
                                          ),
                                        );
                                      }
                                      return Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Transform.rotate(
                                                angle: 40,
                                                child: SvgPicture.asset(
                                                  "assets/icons/Coupon.svg",
                                                  color: primaryColor,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    controller
                                                        .coupons[index].code!,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall,
                                                  ),
                                                  const SizedBox(
                                                    height: defaultPadding,
                                                  ),
                                                  SizedBox(
                                                    width: Get.width * 0.6,
                                                    child: Text(
                                                      controller.coupons[index]
                                                          .campaignName!,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Spacer(),
                                              controller.isApplyingCoupon.value
                                                  ? const SpinKitThreeBounce(
                                                      color: primaryColor,
                                                      size: 18.0,
                                                    )
                                                  : TextButton(
                                                      onPressed: () {
                                                        controller.applyCoupon(
                                                          controller
                                                              .coupons[index],
                                                        );
                                                      },
                                                      child: const Text(
                                                        'Apply',
                                                        style: TextStyle(
                                                          color: primaryColor,
                                                        ),
                                                      ),
                                                    ),
                                            ],
                                          ),
                                          const SizedBox(height: 25),
                                          Divider(
                                            color: Theme.of(context)
                                                .inputDecorationTheme
                                                .hintStyle!
                                                .color!,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/Coupon.svg",
                          color: Theme.of(context)
                              .inputDecorationTheme
                              .hintStyle!
                              .color!,
                        ),
                        const SizedBox(width: defaultPadding / 2),
                        Text(
                          "Apply coupon code",
                          style: TextStyle(
                            color: Theme.of(context)
                                .inputDecorationTheme
                                .hintStyle!
                                .color!,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // TextFormField(
                  //   onSaved: (code) {},
                  //   onChanged: (value) {},
                  //   enabled: false,
                  //   decoration: InputDecoration(
                  //     hintText: "Apply coupon code",
                  //     prefixIcon: Padding(
                  //       padding:
                  //           const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
                  //       child: SvgPicture.asset(
                  //         "assets/icons/Coupon.svg",
                  //         color: Theme.of(context).inputDecorationTheme.hintStyle!.color!,
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  // Visibility(
                  //   visible: _isShoeApplyBtn,
                  //   child: OutlinedButton(
                  //     onPressed: () {},
                  //     child: Text(
                  //       "Apply coupon code",
                  //       style: TextStyle(
                  //           color: Theme.of(context).textTheme.bodyText1!.color!),
                  //     ),
                  //   ),
                  // ),
                ],
              );
      },
    );
  }
}
