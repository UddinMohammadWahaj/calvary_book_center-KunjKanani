import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/checkout/controllers/payment_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class PaymentProcessingScreen extends StatelessWidget {
  const PaymentProcessingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Processing"),
      ),
      body: WillPopScope(
        onWillPop: () async => false,
        child: GetX<PaymentController>(
          init: PaymentController(),
          builder: (controller) {
            if (controller.isProcessing.value) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  SpinKitThreeBounce(
                    color: primaryColor,
                    size: 22.0,
                  ),
                  SizedBox(height: defaultPadding),
                  Text("Please wait..."),
                  SizedBox(height: defaultPadding / 2),
                  Text(
                    "This may take a few seconds to complete.\n Do not close the app.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }

            return const Center(
              child: Text("Waiting for payment processing..."),
            );
          },
        ),
      ),
    );
  }
}
