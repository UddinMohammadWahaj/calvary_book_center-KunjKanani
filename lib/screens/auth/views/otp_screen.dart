import 'package:bookcenter/screens/auth/controllers/password_recovery_controller.dart';
import 'package:flutter/material.dart';
import 'package:bookcenter/constants.dart';
import 'package:get/get.dart';

import 'components/otp_form.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Verification code",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: defaultPadding / 2),
              const Text("We have sent the code verification to "),
              Row(
                children: [
                  Text(
                    "+91 ******${Get.find<PasswordRecoveryController>().currentOTPUser.mobile!.substring(6)}",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text("Change account?"),
                  )
                ],
              ),
              const OtpForm(),
              const SizedBox(height: defaultPadding),
              GetX<PasswordRecoveryController>(
                builder: (controller) {
                  int remainingSeconds = 120 - controller.currentTimer.value;
                  int remainingMinutes = remainingSeconds ~/ 60;
                  int finalSecond = remainingSeconds % 60;
                  return Center(
                    child: Text.rich(
                      TextSpan(
                        text: "Resend code after ",
                        children: [
                          TextSpan(
                            text:
                                '$remainingMinutes:${finalSecond < 10 ? '0' : ''}$finalSecond',
                            style: const TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const Spacer(),
              Row(
                children: [
                  GetX<PasswordRecoveryController>(
                    builder: (controller) {
                      return Expanded(
                        child: OutlinedButton(
                          onPressed: controller.isResendOTPEnabled.value
                              ? () {
                                  controller.sendOTPIfRegister();
                                }
                              : null,
                          child: const Text("Resend"),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: defaultPadding),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        PasswordRecoveryController passwordRecoveryController =
                            Get.find();
                        passwordRecoveryController.verifyOTP();
                        // Navigator.pushNamed(context, newPasswordScreenRoute);
                      },
                      child: const Text("Confirm"),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
