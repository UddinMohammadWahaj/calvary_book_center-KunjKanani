import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/bookmark/repositories/bookmark_repository.dart';
import 'package:bookcenter/screens/product/repositories/wishlist_repository.dart';
import 'package:bookcenter/screens/product_list/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookmarkController extends GetxController {
  RxList<ProductModel> bookmarks = <ProductModel>[].obs;
  var isFetchingBookmarks = false.obs, isLastPage = false.obs;
  int currentPage = 1;
  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    initFetchBookmarks();
    super.onInit();
  }

  void initFetchBookmarks() {
    fetchBookmarks(page: currentPage);

    scrollController.addListener(() {
      var nextPageTrigger = scrollController.position.maxScrollExtent * 0.8;
      if (scrollController.position.pixels >= nextPageTrigger &&
          !isFetchingBookmarks.value &&
          !isLastPage.value) {
        fetchBookmarks(page: currentPage);
      }
    });
  }

  void fetchBookmarks({required int page}) async {
    isFetchingBookmarks.value = true;

    final response =
        await BookmarkRepository.instance.fetchBookmarks(page: page);

    if (page == 1) {
      bookmarks.value = response.data;
    } else {
      bookmarks.addAll(response.data);
    }

    if (bookmarks.length < response.dataCount!) {
      currentPage++;
    } else {
      isLastPage.value = true;
    }

    isFetchingBookmarks.value = false;
  }

  void removeBookmark(int id) async {
    ApiResponse apiResponse =
        await WishlistRepository.instance.removeFromWishlist(
      id,
    );

    if (apiResponse.message == ApiMessage.success) {
      bookmarks.removeWhere((element) => element.id == id);
      bookmarks.refresh();
    }
  }
}
