import 'package:bookcenter/service/entry_point_service.dart';
import 'package:flutter/material.dart';
import 'package:bookcenter/constants.dart';
import 'package:bookcenter/route/screen_export.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class AddedToCartMessageScreen extends StatelessWidget {
  const AddedToCartMessageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            children: [
              const Spacer(),
              // Image.asset(
              //   Theme.of(context).brightness == Brightness.light
              //       ? "assets/Illustration/success.png"
              //       : "assets/Illustration/success_dark.png",
              //   height: MediaQuery.of(context).size.height * 0.3,
              // ),
              LottieBuilder.asset(
                'assets/lottie/add-to-cart.json',
                width: MediaQuery.of(context).size.width * 0.6,
              ),
              const Spacer(flex: 2),
              Text(
                "Added to cart",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: defaultPadding / 2),
              const Text(
                "Click the checkout button to complete the purchase process.",
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 2),
              OutlinedButton(
                onPressed: () {
                  // Get.find<EntryPointService>().currentPage.value = 1;
                  Get.offNamedUntil(
                    entryPointScreenRoute,
                    (route) => false,
                    arguments: {
                      'checkStatus': false,
                      'index': 1,
                    },
                  );
                },
                child: const Text("Continue shopping"),
              ),
              const SizedBox(height: defaultPadding),
              ElevatedButton(
                onPressed: () {
                  // Get.find<EntryPointService>().currentPage.value = 3;
                  Get.offNamedUntil(
                    entryPointScreenRoute,
                    (route) => false,
                    arguments: {
                      'checkStatus': false,
                      'index': 3,
                    },
                  );
                },
                child: const Text("Checkout"),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
