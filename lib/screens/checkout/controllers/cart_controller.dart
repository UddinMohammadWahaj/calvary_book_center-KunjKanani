import 'dart:developer';

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/route/route_constants.dart';
import 'package:bookcenter/screens/address/models/address_model.dart';
import 'package:bookcenter/screens/address/repositories/address_repository.dart';
import 'package:bookcenter/screens/checkout/models/coupon_model.dart';
import 'package:bookcenter/screens/checkout/repositories/cart_repository.dart';
import 'package:bookcenter/screens/order/controllers/order_controller.dart';
import 'package:bookcenter/screens/product_list/models/product_model.dart';
import 'package:bookcenter/service/address_service.dart';
import 'package:bookcenter/service/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  RxList<ProductModel> cartItems = <ProductModel>[].obs;

  var subTotalPriceWithoutDiscount = 0.0.obs,
      subTotalPriceWithDiscount = 0.0.obs,
      totalPrice = 0.0.obs,
      couponDiscount = 0.0.obs,
      saleDiscount = 0.0.obs;
  RxList<CouponModel> coupons = <CouponModel>[].obs;
  var isFetchingCoupons = false.obs,
      isLastPage = false.obs,
      isApplyingCoupon = false.obs,
      isFetchingAddresses = false.obs,
      isFetchingOrder = false.obs;
  ScrollController couponScrollController = ScrollController();
  int currentPage = 1;
  var currentCoupon = CouponModel().obs;
  RxList<AddressModel> addresses = <AddressModel>[].obs;

  Rx<AddressModel> selectedAddress = AddressModel().obs;

  final CartService _cartService = Get.find();
  final AddressService _addressService = Get.find();

  var shippingCharges = 0.0.obs;

  var isFetchingDeliveryPrice = false.obs;

  var selectedTipIndex = 0.obs;

  var isDonation = false.obs;

  var donationAmount = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    initCartItems();
    initFetchCoupons();
  }

  void initCartItems() {
    _cartService.cartItems.listenAndPump((items) {
      cartItems.value = items;
      // // log(cartItems.toString());
      countTotalPrice();
    });
  }

  void decreaseQuantity(ProductModel product) {
    _cartService.removeFromCart(product);
    cartItems.refresh();
  }

  void increaseQuantity(ProductModel product) {
    _cartService.addToCart(product);
    cartItems.refresh();
  }

  void removeItem(ProductModel product) {
    _cartService.removeFromCart(product, fullRemove: true);
    cartItems.refresh();
    currentCoupon.value = CouponModel();
    countTotalPrice();
  }

  void countTotalPrice() {
    totalPrice.value = 0.0;
    subTotalPriceWithoutDiscount.value = 0.0;
    subTotalPriceWithDiscount.value = 0.0;

    // Calculating subtotal with and without discount
    for (var element in cartItems) {
      subTotalPriceWithoutDiscount.value +=
          double.parse(element.price ?? '0.0') * (element.buyingQuantity ?? 1);
      subTotalPriceWithDiscount.value +=
          double.parse(element.salePrice ?? '0.0') *
              (element.buyingQuantity ?? 1);
      // log('discountPrice.value: ${subTotalPriceWithoutDiscount.value} ${element.productTitle}');
    }

    // Sale Discount
    saleDiscount.value =
        subTotalPriceWithoutDiscount.value - subTotalPriceWithDiscount.value;

    // Total Price including sale discount
    totalPrice.value = subTotalPriceWithDiscount.value + shippingCharges.value;

    // log('totalPrice.value: ${totalPrice.value}');

    // Adding Tip
    totalPrice.value += getTipAmount();

    // Coupon discount
    if (currentCoupon.value.discountAmount != null &&
        currentCoupon.value.discountAmount! > 0) {
      couponDiscount.value = currentCoupon.value.discountAmount ?? 0.0;
      totalPrice.value = totalPrice.value - couponDiscount.value;
    }
  }

  Future fetchCoupons() async {
    isFetchingCoupons.value = true;

    ApiResponse response = await CartRepository.instance.fetchCoupons(
      page: currentPage,
      type: 'shop',
    );

    if (currentPage == 1) {
      coupons.value = response.data;
    } else {
      coupons.addAll(response.data);
    }

    // log('coupons: ${coupons.toString()}');

    if (coupons.length < response.dataCount!) {
      currentPage++;
    } else {
      isLastPage.value = true;
    }

    isFetchingCoupons.value = false;
  }

  void initFetchCoupons() {
    fetchCoupons();

    couponScrollController.addListener(() {
      var nextPageTrigger =
          couponScrollController.position.maxScrollExtent * 0.8;

      if (couponScrollController.position.pixels >= nextPageTrigger &&
          !isFetchingCoupons.value &&
          !isLastPage.value) {
        fetchCoupons();
      }
    });
  }

  Future applyCoupon(CouponModel coupon) async {
    var found = false;

    List<ProductModel> couponProducts = [];

    if (coupon.category != null && coupon.category!.isNotEmpty) {
      for (var element in cartItems) {
        if (coupon.category!.contains(element.categoryName!)) {
          found = true;
          couponProducts.add(element);
        }
      }
    } else if (coupon.subCategory != null && coupon.subCategory!.isNotEmpty) {
      for (var element in cartItems) {
        if (coupon.subCategory!.contains(element.subCategory!)) {
          found = true;
          couponProducts.add(element);
        }
      }
    } else if (coupon.category!.isEmpty && coupon.subCategory!.isEmpty) {
      found = true;
      for (var element in cartItems) {
        couponProducts.add(element);
      }
    }

    if (!found) {
      Get.snackbar(
        'Error',
        'No product found for this coupon',
        colorText: Colors.white,
        backgroundColor: primaryColor,
      );
      return;
    }

    var applicableProductsTotalPrice = 0.0;
    for (var element in couponProducts) {
      applicableProductsTotalPrice += double.parse(element.salePrice ?? '0.0') *
          (element.buyingQuantity ?? 1);
    }

    if (coupon.minimumAmount != null &&
        coupon.minimumAmount! > applicableProductsTotalPrice) {
      Get.snackbar(
        'Error',
        'Minimum amount is ${coupon.minimumAmount} for apply this coupon to ${coupon.category != null && coupon.category!.isNotEmpty ? coupon.category : coupon.subCategory}',
        colorText: Colors.white,
        backgroundColor: primaryColor,
      );
      return;
    }

    if (!(await _applyCouponServer(coupon))) {
      return;
    }

    currentCoupon.value = coupon.copyWith(
      discountAmount:
          ((coupon.discount ?? 0.0) * applicableProductsTotalPrice) / 100,
    );
    countTotalPrice();
    Get.back();
  }

  void removeCoupon() {
    currentCoupon.value = CouponModel();
    countTotalPrice();
  }

  Future _applyCouponServer(CouponModel coupon) async {
    isApplyingCoupon.value = true;
    ApiResponse response = await CartRepository.instance.applyCoupon(
      [
        coupon.id,
      ],
    );

    isApplyingCoupon.value = false;
    return response.message == ApiMessage.success;
  }

  Future fetchAddresses() async {
    isFetchingAddresses.value = true;
    ApiResponse response = await AddressRepository.instance.fetchAddresses();

    if (response.message != ApiMessage.success) {
      Get.snackbar(
        'Error',
        response.data,
        colorText: Colors.white,
        backgroundColor: primaryColor,
      );
    }
    addresses.value = response.data;

    isFetchingAddresses.value = false;
  }

  void initAddresses() {
    _addressService.addresses.listenAndPump((addresses) {
      this.addresses.value = addresses;
    });

    _addressService.isFetchingAddresses.listenAndPump((isFetching) {
      isFetchingAddresses.value = isFetching;
    });
  }

  void updateSelectedAddress(AddressModel address) async {
    await fetchDeliveryCharges(address.id);

    selectedAddress.value = address;
    addresses.refresh();
  }

  fetchDeliveryCharges(addressId) async {
    isFetchingDeliveryPrice.value = true;
    double totalWeight = 0.0;

    for (var element in cartItems) {
      for (ProductFeature feat in element.productFeatures ?? []) {
        if (feat.name == 'weight') {
          totalWeight +=
              double.parse(feat.value) * (element.buyingQuantity ?? 1);
        }
      }
    }

    ApiResponse apiResponse =
        await CartRepository.instance.fetchDeliveryCharges(
      address: addressId,
      weight: totalWeight,
    );

    if (apiResponse.message == ApiMessage.success) {
      shippingCharges.value = double.parse(apiResponse.data.toString());
    } else {
      shippingCharges.value = 0.0;
    }

    countTotalPrice();
    isFetchingDeliveryPrice.value = false;
  }

  void navigateToOrderDetail({required orderId}) async {
    isFetchingOrder.value = true;
    ApiResponse response = await CartRepository.instance.fetchOrderDetails(
      id: orderId,
    );

    // // log('navigateToOrderDetail: ${response.data}');

    Get.offNamed(
      orderDetailsScreenRoute,
      arguments: {
        'order': response.data,
        'status': OrderProcessState.processing,
      },
    );
    isFetchingOrder.value = false;
  }

  int getTipAmount() {
    if (donationAmount.text.isEmpty) {
      return 0;
    }
    return int.parse(donationAmount.text);
    // if (selectedTipIndex.value == 1) {
    //   return 10;
    // } else if (selectedTipIndex.value == 2) {
    //   return 25;
    // } else if (selectedTipIndex.value == 3) {
    //   return 50;
    // } else {
    //   return 0;
    // }
  }
}
