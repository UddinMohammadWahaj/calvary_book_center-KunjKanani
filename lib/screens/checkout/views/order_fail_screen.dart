import 'package:bookcenter/screens/checkout/controllers/payment_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bookcenter/constants.dart';
import 'package:get/get.dart';
import 'components/order_summery.dart';

class PaymentFailScreen extends StatelessWidget {
  const PaymentFailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      ? "assets/Illustration/server_error_dart.png"
                      : "assets/Illustration/server_error.png",
                  width: MediaQuery.of(context).size.width * 0.5,
                ),
              ),
              const SizedBox(height: defaultPadding * 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Payment failed",
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(width: defaultPadding / 2),
                  SvgPicture.asset(
                    "assets/icons/Close-Circle.svg",
                    color: primaryColor,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                child: Text.rich(
                  TextSpan(
                    text: "Please contact us at ",
                    children: [
                      TextSpan(
                        text: "support@calvary.com",
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                            fontWeight: FontWeight.w500),
                      ),
                      const TextSpan(text: "  for more information.")
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                child: OrderSummary(
                  orderId: (Get.arguments.rpayData.orderId)
                      .toString()
                      .replaceFirst('order_', ''),
                  amount: Get.arguments.rpayData.amount,
                  isFail: true,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
