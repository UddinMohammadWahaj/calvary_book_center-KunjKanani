import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;
import 'package:bookcenter/constants.dart';
import 'package:bookcenter/route/route_constants.dart';
import 'package:bookcenter/screens/auth/models/user_model.dart';
import 'package:bookcenter/screens/auth/repositories/auth_repository.dart';
import 'package:bookcenter/util/sms_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordRecoveryController extends GetxController {
  final formKeyForPasswordRecovery = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs, isResendOTPEnabled = false.obs;
  String sendedOTP = '';
  Timer? timerForOTP;
  final currentTimer = 0.obs;
  late UserModel currentOTPUser;
  String otp = '';

  final TextEditingController passwordRecoveryOtpController =
      TextEditingController();

  var newPassFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void sendOTPIfRegister() async {
    if (formKeyForPasswordRecovery.currentState!.validate()) {
      isLoading.value = true;
      ApiResponse userExists = await AuthRepository.instance.checkUserExist(
        email: emailController.text,
      );

      // log(userExists.data.toString());

      if (userExists.message != ApiMessage.success) {
        Get.snackbar(
          'Error',
          'You are not registered',
          colorText: Colors.white,
          backgroundColor: primaryColor,
        );
        isLoading.value = false;
        return;
      }
      // // log(userExists.data['results'][0].toString());
      currentOTPUser = userExists.data as UserModel;
      // Generate a random 4 digit number
      sendedOTP = (math.Random().nextInt(9000) + 1000).toString();

      ApiResponse smsResponse = await sendOTP(
        mobileNo: currentOTPUser.mobile.toString(),
        otp: sendedOTP,
      );

      if (smsResponse.message != ApiMessage.success) {
        Get.snackbar('Error', 'Something went wrong');
        isLoading.value = false;
        return;
      }

      isResendOTPEnabled.value = false;
      currentTimer.value = 0;
      if (timerForOTP != null) timerForOTP!.cancel();
      // Start a timer for 120 seconds
      timerForOTP = Timer.periodic(
        const Duration(seconds: 1),
        (timer) {
          if (timer.tick == 120) {
            sendedOTP = '';
            isResendOTPEnabled.value = true;
            timer.cancel();
          }
          currentTimer.value = timer.tick;
        },
      );

      Future.delayed(const Duration(seconds: 1), () {
        Get.toNamed(otpScreenRoute);
        isLoading.value = false;
      });
    }
  }

  void verifyOTP() {
    // log(currentOTPUser.toString());
    if (passwordRecoveryOtpController.text == sendedOTP) {
      Get.offNamed(newPasswordScreenRoute);
    } else {
      Get.snackbar(
        'Error',
        'OTP is not correct',
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }
  }

  void changePassword() async {
    if (newPassFormKey.currentState!.validate()) {
      isLoading.value = true;
      ApiResponse changePasswordResponse =
          await AuthRepository.instance.changePassword(
        currentOTPUser.userId,
        currentOTPUser.mobile,
        passwordController.text,
      );

      if (changePasswordResponse.message != ApiMessage.success) {
        Get.snackbar('Error', 'Something went wrong');
        isLoading.value = false;
        return;
      }

      Get.offAllNamed(logInScreenRoute);
      Get.snackbar(
        'Success',
        'Password changed successfully',
        colorText: Colors.white,
        backgroundColor: Colors.green,
      );
      isLoading.value = false;
    }
  }
}
