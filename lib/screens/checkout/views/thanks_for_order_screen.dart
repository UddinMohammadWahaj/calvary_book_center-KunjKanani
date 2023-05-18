import 'dart:developer';

import 'package:bookcenter/screens/checkout/controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bookcenter/constants.dart';
import 'package:get/get.dart';
import 'components/order_summery.dart';

class ThanksForOrderScreen extends StatelessWidget {
  const ThanksForOrderScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // log('${Get.arguments['order']}');
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              "assets/icons/Share.svg",
              color: Theme.of(context).iconTheme.color,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Center(
                child: Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? "assets/Illustration/Success_darkTheme.png"
                      : "assets/Illustration/Success_lightTheme.png",
                  width: MediaQuery.of(context).size.width * 0.5,
                ),
              ),
              const SizedBox(height: defaultPadding * 2),
              Text(
                "Thanks for your order",
                style: Theme.of(context).textTheme.headline6,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                child: Text.rich(
                  TextSpan(
                    text: "You’ll receive an email at  ",
                    children: [
                      TextSpan(
                        text: Get.arguments['order'].rpayData.prefill.email,
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                            fontWeight: FontWeight.w500),
                      ),
                      const TextSpan(text: "  once your order is confirmed.")
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                child: OrderSummary(
                  orderId: (Get.arguments['order'].rpayData.orderId)
                      .toString()
                      .replaceFirst('order_', ''),
                  amount: Get.arguments['order'].rpayData.amount,
                ),
              ),
              const Spacer(),
              if (Get.arguments['isTrackOrder'])
                ElevatedButton.icon(
                  onPressed: () {
                    Get.find<CartController>().navigateToOrderDetail(
                      orderId: Get.arguments['order'].orderId,
                    );
                  },
                  icon: GetX<CartController>(
                    builder: (controller) {
                      return controller.isFetchingOrder.value
                          ? const SpinKitThreeBounce(
                              color: Colors.white,
                              size: 16,
                            )
                          : SvgPicture.asset(
                              "assets/icons/Trackorder.svg",
                              color: Colors.white,
                            );
                    },
                  ),
                  label: const Text("Track order"),
                )
            ],
          ),
        ),
      ),
    );
  }
}
