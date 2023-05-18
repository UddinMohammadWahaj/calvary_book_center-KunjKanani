import 'dart:async';
import 'dart:math';
import 'dart:developer' as dev;

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/route/screen_export.dart';
import 'package:bookcenter/screens/auth/repositories/auth_repository.dart';
import 'package:bookcenter/util/helper_methods.dart';
import 'package:bookcenter/util/sms_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpAuthController extends GetxController {
  final mobileConrtoller = TextEditingController(),
      passwordController = TextEditingController(),
      nameController = TextEditingController(),
      emailController = TextEditingController();

  var isResendOtpEnabled = false.obs,
      termsAndConditionChecked = false.obs,
      hasTermsAndConditionError = false.obs;

  final formKeyForSignUp = GlobalKey<FormState>();
  Timer? otpExpireTimer;
  var isSignUpInProgress = false.obs, isOtpInProgress = false.obs;

  var otp = '';
  final TextEditingController otpController = TextEditingController();

  var isPasswordVisible = false.obs;

  @override
  void onClose() {
    mobileConrtoller.dispose();
    passwordController.dispose();
    nameController.dispose();
    emailController.dispose();
    otpExpireTimer?.cancel();
    super.onClose();
  }

  void validateAndProceed() async {
    if (isOtpInProgress.value) {
      return;
    }

    if (formKeyForSignUp.currentState!.validate()) {
      if (!termsAndConditionChecked.value) {
        hasTermsAndConditionError.value = true;
        return;
      }
      hasTermsAndConditionError.value = false;
      isOtpInProgress.value = true;
      bool isOtpSuccess = await sendOTPAndStartTimer();
      if (isOtpSuccess) {
        Get.toNamed(signUpVerificationScreenRoute);
      }
      isOtpInProgress.value = false;
    }
  }

  Future<bool> sendOTPAndStartTimer() async {
    ApiResponse userExists = await AuthRepository.instance.checkUserExist(
      email: emailController.text,
      mobile: mobileConrtoller.text,
    );

    if (userExists.message == ApiMessage.success) {
      Get.snackbar(
        'Error',
        'User already exists',
        colorText: Colors.white,
        backgroundColor: primaryColor,
      );
      return false;
    }

    // Generate a random 4 digit number
    otp = (Random().nextInt(9000) + 1000).toString();
    // dev. log('OTP: $otp');
    ApiResponse otpResponse = await sendOTP(
      mobileNo: mobileConrtoller.text,
      otp: otp,
    );

    isResendOtpEnabled.value = false;
    if (otpResponse.message == ApiMessage.success) {
      otpExpireTimer = Timer(
        const Duration(seconds: 120),
        () {
          isResendOtpEnabled.value = true;
        },
      );
      return true;
    } else {
      Get.snackbar(
        'Error',
        otpResponse.data ?? 'Something went wrong',
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      return false;
    }
  }

  void verifyOtp() {
    if (otpController.text == otp) {
      _signUp();
    } else {
      Get.snackbar(
        "Error",
        "Invalid OTP",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future _signUp() async {
    if (isSignUpInProgress.value) {
      return;
    }

    isSignUpInProgress.value = true;
    var deviceId = await getId();
    ApiResponse signUpResponse = await AuthRepository.instance.register(
      name: nameController.text,
      email: emailController.text,
      mobile: mobileConrtoller.text,
      password: passwordController.text,
      deviceId: deviceId,
    );

    if (signUpResponse.message == ApiMessage.success) {
      isSignUpInProgress.value = false;
      _openSuccessBottomSheet();
    } else {
      Get.back();

      otpController.clear();
      Get.snackbar(
        "Error",
        signUpResponse.data.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      isSignUpInProgress.value = false;
    }
  }

  void _openSuccessBottomSheet() {
    Get.bottomSheet(
      SizedBox(
        height: Get.height * 0.75,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                Image.asset(
                  Get.theme.brightness == Brightness.light
                      ? "assets/Illustration/success.png"
                      : "assets/Illustration/success_dark.png",
                  height: Get.size.height * 0.3,
                ),
                const Spacer(),
                Text(
                  "Whoohooo!",
                  style: Get.textTheme.titleLarge,
                ),
                const SizedBox(
                  height: defaultPadding / 2,
                ),
                const Text(
                  "Your account has been created successfully.",
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Get.offAllNamed(
                      entryPointScreenRoute,
                    );
                  },
                  child: const Text(
                    "Explore Calvary Book Center",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(defaultBorderRadious * 2),
          topRight: Radius.circular(defaultBorderRadious * 2),
        ),
      ),
      isDismissible: false,
    );
  }
}
