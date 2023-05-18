import 'dart:developer';

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/auth/models/user_model.dart';
import 'package:bookcenter/screens/profile/repositories/profile_repository.dart';
import 'package:bookcenter/service/user_service.dart';
import 'package:bookcenter/util/helper_methods.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  late Rx<UserModel> currentUser = UserModel().obs;

  var isLogoutLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    Get.find<UserService>().user.listenAndPump((event) {
      currentUser.value = event;
    });
  }

  void logout() async {
    if (isLogoutLoading.value) {
      return;
    }

    isLogoutLoading.value = true;
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

    // ApiResponse apiResponse = ApiResponse(message: ApiMessage.success);
    ApiResponse apiResponse = await ProfileRepo.instance.logout(
      deviceId: deviceId,
    );

    // log('logout response: ${apiResponse.message.toString()}', name: 'logout');

    if (apiResponse.message == ApiMessage.success) {
      await Get.find<UserService>().logout();
    } else {
      Get.snackbar(
        'Error',
        apiResponse.data ?? 'Something went wrong',
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }

    isLogoutLoading.value = false;
  }
}
