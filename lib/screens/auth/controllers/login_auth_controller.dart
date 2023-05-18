import 'package:bookcenter/constants.dart';
import 'package:bookcenter/route/route_constants.dart';
import 'package:bookcenter/route/screen_export.dart';
import 'package:bookcenter/screens/auth/repositories/auth_repository.dart';
import 'package:bookcenter/util/helper_methods.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginAuthController extends GetxController {
  final isLoading = false.obs;

  final mobileConrtoller = TextEditingController(),
      passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  var isPasswordVisible = false.obs;

  @override
  void onClose() {
    mobileConrtoller.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void login() async {
    if (isLoading.value) {
      return;
    }
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      var deviceId = await getId();
      if (deviceId.isEmpty) {
        Get.snackbar(
          'Error',
          'Something went wrong',
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
        return;
      }

      ApiResponse apiResponse = await AuthRepository.instance.login(
        mobileConrtoller.text,
        passwordController.text,
        deviceId: deviceId,
      );
      isLoading.value = false;

      if (apiResponse.message == ApiMessage.success) {
        Get.offAllNamed(entryPointScreenRoute);
        mobileConrtoller.clear();
        passwordController.clear();
      } else {
        Get.snackbar(
          'Error',
          apiResponse.data ?? 'Something went wrong',
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      }
    }
  }

  void forgotPassword() {
    // Get.toNamed('/forgot-password');
  }
}
