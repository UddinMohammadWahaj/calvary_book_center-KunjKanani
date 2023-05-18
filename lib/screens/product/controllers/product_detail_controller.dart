import 'dart:developer';

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/bookmark/controllers/bookmark_controller.dart';
import 'package:bookcenter/screens/product/repositories/product_detail_repository.dart';
import 'package:bookcenter/screens/product/repositories/wishlist_repository.dart';
import 'package:bookcenter/screens/product_list/models/product_model.dart';
import 'package:bookcenter/service/cart_service.dart';
import 'package:get/get.dart';

class ProductDetailController extends GetxController {
  var isFetchingProductDetail = false.obs;
  ProductModel? productDetails;
  late double productPrice, discountPrice;
  var quantity = 1.obs, isAddingToCart = false.obs;
  var isBookmarked = false.obs;

  int totalReview = 0;
  late int currentProductId;
  late bool isFromBookmarkScreen;

  @override
  void onInit() {
    super.onInit();
    initProductDetailFetch();
  }

  void initProductDetailFetch() async {
    isFetchingProductDetail.value = true;

    currentProductId = Get.arguments['productId'];

    log(currentProductId.toString());
    isFromBookmarkScreen = Get.arguments['isFromBookmarkScreen'] ?? false;

    ApiResponse response =
        await ProductDetailRepository.instance.getProductDetail(
      currentProductId.toString(),
    );

    if (response.message == ApiMessage.success) {
      productDetails = response.data as ProductModel;

      totalReview = productDetails!.reviewMatrix!.onestar! +
          productDetails!.reviewMatrix!.twostars! +
          productDetails!.reviewMatrix!.threeStars! +
          productDetails!.reviewMatrix!.fourStars! +
          productDetails!.reviewMatrix!.fiveStars!;

      productPrice = double.parse(productDetails!.price ?? '0.0');
      discountPrice = double.parse(productDetails!.salePrice ?? '0.0');

      productPrice =
          productPrice <= discountPrice ? productPrice : discountPrice;

      isBookmarked.value = productDetails!.isBookmarked ?? false;

      // log(productDetails.toString());
    } else {
      // log(response.message.toString());
    }

    isFetchingProductDetail.value = false;
  }

  Future addToCart() async {
    isAddingToCart.value = true;

    await Get.find<CartService>().addToCart(
      productDetails!,
      quantity: quantity.value,
    );
    isAddingToCart.value = false;
  }

  void addBookmark() async {
    isBookmarked.value = true;
    ApiResponse apiResponse = await WishlistRepository.instance.addToWishlist(
      productDetails!.id!,
    );

    if (apiResponse.message != ApiMessage.success) {
      isBookmarked.value = false;
    }

    updateWishlist();
  }

  void removeBookmark() async {
    isBookmarked.value = false;
    ApiResponse apiResponse =
        await WishlistRepository.instance.removeFromWishlist(
      productDetails!.id!,
    );

    if (apiResponse.message != ApiMessage.success) {
      isBookmarked.value = true;
    }

    updateWishlist();
  }

  void updateWishlist() {
    if (isFromBookmarkScreen) {
      Get.find<BookmarkController>().initFetchBookmarks();
    }
  }
}
