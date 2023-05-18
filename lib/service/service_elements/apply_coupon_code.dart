import 'package:bookcenter/constants.dart';
import 'package:bookcenter/service/digital_product_payment_service.dart';
import 'package:bookcenter/service/service_elements/coupon_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class ApplyCouponCode extends StatelessWidget {
  const ApplyCouponCode({
    super.key,
    required this.price,
    required this.type,
  });

  final String? price;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: defaultPadding / 2),
        GetX<DigitalProductPaymentService>(
          builder: (controller) {
            return controller.isCouponApplied.value
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
                            text: "${controller.selectedCoupon.code}",
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
                : OutlinedButton(
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
                        builder: (context) => CouponBottomSheet(
                          type: type,
                          onApplyCoupon: (coupon) {
                            Get.back();
                            controller.applyCoupon(
                              coupon: coupon,
                              productPrice: price,
                            );
                          },
                        ),
                      );
                    },
                    child: const Text('Apply Coupon'),
                  );
          },
        ),
      ],
    );
  }
}
