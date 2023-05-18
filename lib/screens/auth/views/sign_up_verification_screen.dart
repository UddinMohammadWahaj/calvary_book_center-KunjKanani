import 'dart:developer';

import 'package:bookcenter/screens/auth/controllers/signup_auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:bookcenter/components/custom_modal_bottom_sheet.dart';
import 'package:bookcenter/constants.dart';
import 'package:bookcenter/route/screen_export.dart';
import 'package:bookcenter/screens/auth/views/components/sign_up_verification_otp_form.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class SignUpVerificationScreen extends StatefulWidget {
  const SignUpVerificationScreen({Key? key}) : super(key: key);

  @override
  State<SignUpVerificationScreen> createState() =>
      _SignUpVerificationScreenState();
}

class _SignUpVerificationScreenState extends State<SignUpVerificationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Duration> _otpAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        minutes: 2,
      ),
    );
    _otpAnimation = Tween<Duration>(
      begin: const Duration(seconds: 120),
      end: Duration.zero,
    ).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SignUpAuthController signUpAuthController = Get.put(SignUpAuthController());
    return WillPopScope(
      onWillPop: () {
        Get.find<SignUpAuthController>().otpController.clear();
        return Future.value(true);
      },
      child: Scaffold(
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
                      "+91 ${signUpAuthController.mobileConrtoller.text}",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text("Change your number?"),
                    )
                  ],
                ),
                const SignUpVerificationOtpForm(),
                const SizedBox(height: defaultPadding),
                AnimatedBuilder(
                  animation: _otpAnimation,
                  builder: (context, child) {
                    return Center(
                      child: Text.rich(
                        TextSpan(
                          text: "Resend code after ",
                          children: [
                            TextSpan(
                              text:
                                  "${_otpAnimation.value.inMinutes}: ${_otpAnimation.value.inSeconds.remainder(60) < 10 ? 0 : ''}${_otpAnimation.value.inSeconds.remainder(60)}",
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
                    Expanded(
                      child: GetX<SignUpAuthController>(
                        builder: (controller) {
                          return OutlinedButton(
                            onPressed: !controller.isResendOtpEnabled.value
                                ? null
                                : _otpAnimation.value.inSeconds > 0
                                    ? null
                                    : () {
                                        SignUpAuthController
                                            signUpAuthController = Get.find();
                                        signUpAuthController
                                            .sendOTPAndStartTimer();
                                        _controller.forward(from: 0);
                                      },
                            child: const Text("Resend"),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: defaultPadding),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          SignUpAuthController signUpAuthController =
                              Get.find();
                          if (signUpAuthController.isSignUpInProgress.value) {
                            return;
                          }

                          signUpAuthController.verifyOtp();
                        },
                        child: GetX<SignUpAuthController>(
                          builder: (controller) {
                            return controller.isSignUpInProgress.value
                                ? const SpinKitThreeBounce(
                                    color: Colors.white,
                                    size: 18,
                                  )
                                : const Text("Confirm");
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
