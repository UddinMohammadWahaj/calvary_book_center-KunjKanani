import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/auth/models/user_model.dart';
import 'package:bookcenter/screens/user_info/repositories/user_info_repository.dart';
import 'package:bookcenter/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserInfoController extends GetxController {
  late Rx<UserModel> currentUser = UserModel().obs;

  TextEditingController nameController = TextEditingController(),
      emailController = TextEditingController(),
      mobileController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    Get.find<UserService>().user.listenAndPump((event) {
      currentUser.value = event;
      nameController.text = currentUser.value.name ?? "";
      emailController.text = currentUser.value.email ?? "";
      mobileController.text = currentUser.value.mobile ?? "";
    });
  }

  void updateUserInfo() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      ApiResponse response = await UserInfoRepository.instance.updateUserInfo(
        {
          "name": nameController.text,
          "email": emailController.text,
        },
      );

      if (response.message == ApiMessage.success) {
        Get.back();
      } else {
        Get.snackbar(
          'Error',
          response.data ?? 'Something went wrong',
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      }
      isLoading.value = false;
    }
  }
}
