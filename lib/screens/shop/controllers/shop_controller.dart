import 'dart:developer';

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/shop/models/category.dart';
import 'package:bookcenter/screens/shop/repository/shop_repository.dart';
import 'package:get/get.dart';

class ShopController extends GetxController {
  List<CategoryModel> categories = [];
  var isFetchingCategories = false.obs;

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  void fetchCategories() async {
    isFetchingCategories.value = true;

    ApiResponse apiResponse = await ShopRepository.instance.fetchCategories();

    if (apiResponse.message == ApiMessage.success) {
      categories = apiResponse.data;
    } else {
      // log(apiResponse.data ?? 'Something went wrong');
      // Get.snackbar('Error', apiResponse.data ?? 'Something went wrong');
    }

    isFetchingCategories.value = false;
  }
}
