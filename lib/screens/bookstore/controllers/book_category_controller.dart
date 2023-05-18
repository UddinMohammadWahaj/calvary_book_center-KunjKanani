import 'dart:developer';

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/bookstore/models/book_category_model.dart';
import 'package:bookcenter/screens/bookstore/repositories/book_store_reposotory.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookCategoryController extends GetxController {
  ScrollController scrollController = ScrollController();

  int currentPage = 1;
  bool isLastPage = false;
  var isFetchingBookCategories = false.obs;

  // List<BookCategoryModel> bookCategories = [];
  List<BookCategoryModel> bookCategories = [
    BookCategoryModel(
      id: 0,
      categoryTitle: 'All',
      categoryImg: 'assets/images/bookstore/all.png',
      categoryIcon: 'assets/icons/bookstore/all.svg',
      bookCount: 0,
    ),
  ];

  @override
  void onInit() {
    initFetchBookCategory();
    super.onInit();
  }

  initFetchBookCategory() async {
    fetchBookCategoies();

    scrollController.addListener(() {
      if (isFetchingBookCategories.value || isLastPage) {
        return;
      }

      var nextTriggeredPage = scrollController.position.maxScrollExtent * 0.8;

      if (scrollController.position.pixels >= nextTriggeredPage) {
        fetchBookCategoies(page: currentPage);
      }
    });
  }

  void fetchBookCategoies({int page = 1}) async {
    isFetchingBookCategories.value = true;

    final ApiResponse response =
        await BookStoreRepository.instance.getBookCategories(page);

    if (response.message == ApiMessage.success) {
      bookCategories.addAll(response.data);

      if (bookCategories.length < response.dataCount!) {
        currentPage++;
      } else {
        isLastPage = true;
      }
    }

    isFetchingBookCategories.value = false;
  }
}
