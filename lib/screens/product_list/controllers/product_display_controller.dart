import 'dart:developer';

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/product_list/models/product_model.dart';
import 'package:bookcenter/screens/product_list/repositories/product_list_repository.dart';
import 'package:bookcenter/screens/shop/models/category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDisplayController extends GetxController with StateMixin {
  var title = ''.obs;
  var selectedIndex = 0.obs;
  List<SubCategory> subCategories = [];
  List<GlobalKey> keysForCategories = [];
  List<ProductModel> products = [];
  var isFetchingProduct = false, isLastPage = false.obs;
  ScrollController scrollController = ScrollController();
  int currentPage = 1;

  var scrollControllerForCategories = ScrollController();

  @override
  void onInit() {
    var arguments = Get.arguments as Map;
    selectedIndex.value = arguments['selectedIndex'];
    title.value = arguments['title'];
    subCategories = arguments['subCategories'];
    for (var i = 0; i < subCategories.length; i++) {
      keysForCategories.add(GlobalKey());
    }
    initProductFetch();

    super.onInit();
  }

  @override
  void onReady() {
    focusSelectedSubCategory();
  }

  focusSelectedSubCategory() {
    final context = keysForCategories[selectedIndex.value].currentContext;

    Scrollable.ensureVisible(
      context!,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  initProductFetch() {
    change(null, status: RxStatus.loading());
    currentPage = 1;
    products = [];

    fetchProductByCategory(page: currentPage);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusSelectedSubCategory();
    });

    scrollController.addListener(() {
      var nextPageTrigger = scrollController.position.maxScrollExtent * 0.8;

      // log(nextPageTrigger.toString());

      if (scrollController.position.pixels >= nextPageTrigger &&
          !isFetchingProduct &&
          !isLastPage.value) {
        fetchProductByCategory(page: currentPage, showCardSkeleton: true);
      }
    });
  }

  void fetchProductByCategory({
    required int page,
    bool showCardSkeleton = false,
  }) async {
    isFetchingProduct = true;
    if (showCardSkeleton) {
      change(null, status: RxStatus.success());
    }
    ApiResponse apiResponse =
        await ProductListRepository.instance.fetchProductsBySubCategory(
      subCategory: subCategories[selectedIndex.value].id,
      page: currentPage,
    );

    if (apiResponse.message == ApiMessage.success) {
      if (page == 1) {
        products = apiResponse.data;
      } else {
        products.addAll(apiResponse.data);
      }

      if (products.length < apiResponse.dataCount!) {
        currentPage++;
      } else {
        isLastPage.value = true;
      }

      if (currentPage == 1 && products.isEmpty) {
        change(null, status: RxStatus.empty());
      } else {
        change(null, status: RxStatus.success());
      }
    } else {
      // change(null, status: RxStatus.error(apiResponse.data.toString()));
      Get.snackbar('Error', apiResponse.data ?? 'Something went wrong');
    }
    isFetchingProduct = false;
  }
}
