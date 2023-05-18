import 'dart:developer';

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/models/book_model.dart';
import 'package:bookcenter/route/route_constants.dart';
import 'package:bookcenter/screens/albums/controllers/albums_controller.dart';
import 'package:bookcenter/screens/albums/models/album_model.dart';
import 'package:bookcenter/screens/bookstore/controllers/book_list_controller.dart';
import 'package:bookcenter/screens/checkout/models/coupon_model.dart';
import 'package:bookcenter/screens/checkout/models/payment_model.dart';
import 'package:bookcenter/screens/checkout/repositories/cart_repository.dart';
import 'package:bookcenter/screens/checkout/repositories/order_repository.dart';
import 'package:bookcenter/screens/home/controllers/home_controller.dart';
import 'package:bookcenter/screens/sermons/controllers/sermons_controller.dart';
import 'package:bookcenter/screens/sermons/models/sermon_model.dart';
import 'package:bookcenter/service/razorpay_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum PaymentMadeFrom { list, home, search, bookViewer }

class DigitalProductPaymentService extends GetxService {
  PaymentModel? order;
  int? productId;
  double? totalAmount;
  String? productName;
  PaymentMadeFrom? paymentMadeFrom;

  BookModel? book;
  AlbumModel? album;
  SermonModel? sermon;

  var isProcessing = false.obs,
      isPurchasingBook = false.obs,
      isPurchasingAlbum = false.obs,
      isPurchasingSermon = false.obs,
      isApplyingCoupon = false.obs,
      isFetchingCoupon = false.obs,
      isCouponApplied = false.obs;

  var isLastCouponPage = false;
  var couponScrollController = ScrollController();
  List<CouponModel> coupons = [];
  int currentCouponPage = 1;

  CouponModel selectedCoupon = CouponModel();

  var discountedPrice = 0.0.obs;

  void createBookPurchaseOrder({
    required BookModel book,
    PaymentMadeFrom paymentMadeFrom = PaymentMadeFrom.list,
  }) {
    if (isPurchasingBook.value) {
      return;
    }

    isPurchasingBook.value = true;
    this.book = book;
    this.paymentMadeFrom = paymentMadeFrom;
    _makePayment(
      productId: book.id,
      productName: 'book',
      totalAmount: isCouponApplied.value
          ? discountedPrice.value
          : double.parse(book.price!),
    );
  }

  void createAlbumPurchaseOrder({
    required AlbumModel album,
    PaymentMadeFrom paymentMadeFrom = PaymentMadeFrom.list,
  }) {
    if (isPurchasingAlbum.value) {
      return;
    }

    isPurchasingAlbum.value = true;
    this.paymentMadeFrom = paymentMadeFrom;
    this.album = album;

    _makePayment(
      productId: album.id!,
      productName: 'album',
      totalAmount: isCouponApplied.value
          ? discountedPrice.value
          : double.parse(album.price!),
    );
  }

  void createSermonPurchaseOrder({
    required SermonModel sermon,
    PaymentMadeFrom paymentMadeFrom = PaymentMadeFrom.list,
  }) {
    if (isPurchasingSermon.value) {
      return;
    }

    isPurchasingSermon.value = true;
    this.paymentMadeFrom = paymentMadeFrom;
    this.sermon = sermon;

    _makePayment(
      productId: sermon.id!,
      productName: 'videoalbum',
      totalAmount: isCouponApplied.value
          ? discountedPrice.value
          : double.parse(sermon.price!),
    );
  }

  Future<ApiResponse> _makePayment({
    required int productId,
    required double totalAmount,
    required String productName,
  }) async {
    isProcessing.value = true;

    this.productId = productId;
    this.totalAmount = totalAmount;
    this.productName = productName;

    final apiMessage = await _createOrderOnServer();

    if (apiMessage == ApiMessage.success) {
      RazorpayService.instance.openCheckout(
        key: order!.rpayData.key,
        amount: order!.rpayData.amount.floor(),
        orderId: order!.rpayData.orderId,
        email: order!.rpayData.prefill.email,
        contact: order!.rpayData.prefill.contact,
        name: order!.rpayData.name,
        description: order!.rpayData.description,
        image: order!.rpayData.image,
        orderType: OrderType.digital,
      );
    }

    isProcessing.value = false;
    return ApiResponse();
  }

  Future<ApiMessage> _createOrderOnServer() async {
    final response = await OrderRepository.instance.createOrderOnServer(
      data: {
        "product_id": productId,
        "total_amount": totalAmount,
        "product_name": productName,
        "status": "N",
      },
      url: '/orders/rpay/',
    );

    if (response.message == ApiMessage.success) {
      order = response.data;
      return ApiMessage.success;
    }

    isProcessing.value = false;
    isPurchasingAlbum.value = false;
    isPurchasingBook.value = false;
    isPurchasingSermon.value = false;

    return ApiMessage.somethingWantWrongError;
  }

  successOrder(trnsID) async {
    // log('trnsID: $trnsID');
    ApiMessage message = await _updateOrderStatusOnServer();

    if (message != ApiMessage.success) {
      _updateControllerData(status: 'N');
      Get.offAndToNamed(
        paymentFailScreenRoute,
        arguments: order,
      );
      _clearData();
      return;
    }

    // // log(order.toJson());
    _updateControllerData(status: 'P');

    _navigateToSuccessScreen();

    _clearData();
  }

  Future _updateOrderStatusOnServer() async {
    ApiResponse response = await OrderRepository.instance.updateOrderStatus(
      url: '/orders/rpay/',
      orderId: order!.orderId,
      data: {
        "status": 'P',
        "product_id": productId!,
        "total_amount": totalAmount!,
        "product_name": productName!,
        "transaction_id": RazorpayService.instance.transactionId,
      },
    );
    return response.message!;
  }

  void failedOrder() {
    _updateControllerData(status: 'N');
    Get.offAndToNamed(
      paymentFailScreenRoute,
      arguments: order,
    );
    _clearData();
  }

  void _clearData() {
    productId = null;
    totalAmount = null;
    productName = null;
    order = null;
    paymentMadeFrom = null;
    book = null;
    album = null;
    sermon = null;
  }

  _updateControllerData({required String status}) {
    if (productName == 'book') {
      book!.paymentStatus = 'P';

      if (paymentMadeFrom == PaymentMadeFrom.list) {
        BookListController bookListController = Get.find<BookListController>();
        bookListController.updateBookPayment(
          id: productId ?? 0,
          status: status,
        );
      } else if (paymentMadeFrom == PaymentMadeFrom.home) {
        HomeController homeController = Get.find<HomeController>();
        homeController.updateBookPayment(
          id: productId ?? 0,
          status: status,
        );
      } else if (paymentMadeFrom == PaymentMadeFrom.bookViewer) {
        BookListController bookListController = Get.find<BookListController>();
        bookListController.updateBookPayment(
          id: productId ?? 0,
          status: status,
        );
        Get.back();
      }
      isPurchasingBook.value = false;
    } else if (productName == 'videoalbum') {
      sermon!.paymentStatus = 'P';
      SermonController sermonController = Get.find<SermonController>();
      sermonController.updateSermonPayment(id: productId ?? 0, status: status);
      isPurchasingSermon.value = false;
    } else if (productName == 'album') {
      album!.paymentStatus = 'P';
      AlbumController albumController = Get.find<AlbumController>();
      albumController.updateAlbumPayment(id: productId ?? 0, status: status);
      isPurchasingAlbum.value = false;
    }
  }

  void _navigateToSuccessScreen() {
    if (productName == 'book') {
      Get.offAndToNamed(
        calvaryPdfViewerScreenRoute,
        arguments: {
          'book': book,
        },
      );
    } else if (productName == 'videoalbum') {
      Get.offAndToNamed(
        sermonViewScreenRoute,
        arguments: sermon,
      );
    } else if (productName == 'album') {
      Get.offAndToNamed(
        albumViewScreenRoute,
        arguments: album,
      );
    }
  }

  Future<bool> applyCoupon({
    required CouponModel coupon,
    String? productPrice,
  }) async {
    if (coupon.minimumAmount != null &&
        double.parse(productPrice!) < coupon.minimumAmount!) {
      Get.snackbar(
        'Error',
        'Minimum amount should be ${coupon.minimumAmount}',
      );
      return false;
    }

    isApplyingCoupon.value = true;

    ApiResponse response = ApiResponse(
      message: ApiMessage.success,
    );
    // ApiResponse response = await CartRepository.instance.applyCoupon(
    //   [
    //     coupon.id,
    //   ],
    // );

    if (response.message == ApiMessage.success) {
      isApplyingCoupon.value = false;

      discountedPrice.value = double.parse(productPrice!) -
          (coupon.discount! * double.parse(productPrice)) / 100;

      isCouponApplied.value = true;
      selectedCoupon = coupon;
      return true;
    }

    Get.snackbar(
      'Error',
      response.message.toString(),
      snackPosition: SnackPosition.BOTTOM,
    );

    isApplyingCoupon.value = false;
    return false;
  }

  void initCouponFetch({required String type}) {
    currentCouponPage = 1;
    coupons = [];
    isLastCouponPage = false;
    // discountedPrice.value = 0.0;
    // isCouponApplied.value = false;
    isFetchingCoupon.value = false;

    fetchCoupons(type: type);
    couponScrollController = ScrollController();
    couponScrollController.addListener(() {
      var nextPageTrigger =
          couponScrollController.position.maxScrollExtent * 0.8;

      if (couponScrollController.position.pixels >= nextPageTrigger &&
          !isFetchingCoupon.value &&
          !isLastCouponPage) {
        fetchCoupons(type: type);
      }
    });
  }

  void fetchCoupons({required String type}) async {
    isFetchingCoupon.value = true;

    ApiResponse response = await CartRepository.instance.fetchCoupons(
      page: currentCouponPage,
      type: type,
    );

    if (currentCouponPage == 1) {
      coupons = response.data;
    } else {
      coupons.addAll(response.data);
    }

    // log('coupons: ${coupons.toString()}');

    if (coupons.length < response.dataCount!) {
      currentCouponPage++;
    } else {
      isLastCouponPage = true;
    }

    isFetchingCoupon.value = false;
  }

  void removeCoupon() {
    isCouponApplied.value = false;
    selectedCoupon = CouponModel();
    discountedPrice.value = 0.0;
  }
}
