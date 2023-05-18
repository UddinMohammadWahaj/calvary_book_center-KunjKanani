import 'dart:developer';

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/product/controllers/product_detail_controller.dart';
import 'package:bookcenter/screens/product_list/models/product_model.dart';
import 'package:bookcenter/screens/reviews/models/review_model.dart';
import 'package:bookcenter/screens/reviews/repositories/review_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductReviewController extends GetxController {
  late Rx<ReviewMatrix> reviewMatrix = ReviewMatrix().obs;
  late int productId;
  late var totalReview = 0.obs;
  var isFetchingProductReviews = false.obs, isLastPage = false.obs;
  RxList<ReviewModel> reviews = <ReviewModel>[].obs;
  int currentPage = 1;
  ScrollController scrollController = ScrollController();

  late ProductModel product;

  double rating = 0;

  var reviewTextFieldController = TextEditingController(),
      reviewTitleTextFieldController = TextEditingController();

  var isCreatingReview = false.obs;

  @override
  void onInit() {
    super.onInit();

    productId = Get.arguments['productId'] as int;
    product = Get.arguments['product'];

    _calculateReviewRatings(
      Get.arguments['productReviewMatrix'] as ReviewMatrix,
    );

    Get.find<ProductDetailController>().isFetchingProductDetail.listen((p0) {
      if (!p0) {
        _calculateReviewRatings(
          Get.find<ProductDetailController>().productDetails!.reviewMatrix!,
        );
      }
    });

    initReviewFetch();
  }

  void fetchProductReviews({int page = 1}) async {
    isFetchingProductReviews.value = true;

    final response = await ReviewRepository.instance.getProductReviews(
      productId,
      page,
    );

    // if (response.message != ApiMessage.success) {
    //   // log(response.message.toString());
    // }
    if (page == 1) {
      reviews.value = response.data;
    } else {
      reviews.addAll(response.data);
    }

    // // log(reviews.toString());

    if (reviews.length < response.dataCount!) {
      currentPage++;
    } else {
      isLastPage.value = true;
    }
    isFetchingProductReviews.value = false;
  }

  void initReviewFetch() {
    currentPage = 1;
    isLastPage.value = false;
    reviews.clear();

    fetchProductReviews(page: currentPage);

    scrollController.addListener(() {
      var nextPageTrigger = scrollController.position.maxScrollExtent * 0.8;

      if (scrollController.position.pixels >= nextPageTrigger &&
          !isFetchingProductReviews.value &&
          !isLastPage.value) {
        fetchProductReviews(page: currentPage);
      }
    });
  }

  void createReview() async {
    isCreatingReview.value = true;
    var result = await ReviewRepository.instance.createReview(
      productId: product.id!,
      rating: rating,
      title: reviewTitleTextFieldController.text,
      description: reviewTextFieldController.text,
    );

    if (result.message == ApiMessage.success) {
      Get.back();

      Get.snackbar(
        'Suceess',
        'Thank you for review.',
      );

      initReviewFetch();
      Get.find<ProductDetailController>().initProductDetailFetch();
    } else {
      Get.snackbar(
        'Error',
        result.data.toString(),
      );
    }

    isCreatingReview.value = false;
  }

  void _calculateReviewRatings(ReviewMatrix argument) {
    reviewMatrix.value = argument;
    totalReview.value = reviewMatrix.value.onestar! +
        reviewMatrix.value.twostars! +
        reviewMatrix.value.threeStars! +
        reviewMatrix.value.fourStars! +
        reviewMatrix.value.fiveStars!;
  }
}
