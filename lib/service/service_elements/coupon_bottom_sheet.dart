import 'dart:developer';

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/checkout/models/coupon_model.dart';
import 'package:bookcenter/screens/checkout/views/empty_screen.dart';
import 'package:bookcenter/service/digital_product_payment_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CouponBottomSheet extends StatefulWidget {
  const CouponBottomSheet({
    super.key,
    required this.onApplyCoupon,
    // required this.couponScrollController,
    // required this.isApplyingCoupon,
    // required this.isFetchingCoupons,
    // required this.coupons,
    required this.type,
  });

  final ValueChanged<CouponModel> onApplyCoupon;
  // final ScrollController couponScrollController;
  // final bool isApplyingCoupon, isFetchingCoupons;
  // final List<CouponModel> coupons;

  final String type;

  @override
  State<CouponBottomSheet> createState() => _CouponBottomSheetState();
}

class _CouponBottomSheetState extends State<CouponBottomSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.put(DigitalProductPaymentService()).initCouponFetch(
        type: widget.type,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding * 1.5,
        vertical: defaultPadding * 1.5,
      ),
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
                color: Theme.of(context).inputDecorationTheme.hintStyle!.color!,
              ),
              const SizedBox(width: defaultPadding),
              const Text("Apply a coupon code"),
            ],
          ),
          const SizedBox(height: defaultPadding * 2),
          GetX<DigitalProductPaymentService>(
            builder: (controller) {
              return controller.isFetchingCoupon.value
                  ? const Center(
                      child: SpinKitThreeBounce(
                        color: primaryColor,
                        size: 18.0,
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        controller: controller.couponScrollController,
                        itemCount: controller.isFetchingCoupon.value
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.coupons[index].code!,
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
                                          controller
                                              .coupons[index].campaignName!,
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
                                            widget.onApplyCoupon(
                                              controller.coupons[index],
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
                    );
            },
          ),
        ],
      ),
    );
  }
}
