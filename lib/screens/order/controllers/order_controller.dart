import 'dart:developer';

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/order/models/order_model.dart';
import 'package:bookcenter/screens/order/repositories/order_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum OrderProcessState { processing, failed, success, none }

extension OrderProcessStatusExtension on OrderProcessState {
  String get asString {
    switch (this) {
      case OrderProcessState.processing:
        return "Processing";
      case OrderProcessState.failed:
        return "Failed";
      case OrderProcessState.success:
        return "Success";
      case OrderProcessState.none:
        return "None";
    }
  }
}

class OrderController extends GetxController {
  RxList<OrderModel> orders = <OrderModel>[].obs;
  var orderStatus = OrderProcessState.none.obs;
  ScrollController scrollController = ScrollController();
  int currentpage = 1;
  var paymentStatus = false, deliveredStatus = false, isLastPage = false;
  var isFetchingOrder = false.obs;

  @override
  void onInit() {
    configureOrderStatus();
    initFetchOrder();

    super.onInit();
  }

  void configureOrderStatus() {
    Map<String, bool> currentStatus = Get.arguments as Map<String, bool>;

    paymentStatus = currentStatus['payment']!;
    deliveredStatus = currentStatus['delivered']!;

    if (paymentStatus && deliveredStatus) {
      orderStatus.value = OrderProcessState.success;
    } else if (paymentStatus && !deliveredStatus) {
      orderStatus.value = OrderProcessState.processing;
    } else {
      orderStatus.value = OrderProcessState.failed;
    }
  }

  void initFetchOrder() {
    fetchOrder(page: currentpage);

    scrollController.addListener(() {
      var nextPageTrigger = scrollController.position.maxScrollExtent * 0.8;

      if (scrollController.position.pixels >= nextPageTrigger &&
          !isLastPage &&
          !isFetchingOrder.value) {
        fetchOrder(page: currentpage);
      }
    });
  }

  void fetchOrder({required int page}) async {
    isFetchingOrder.value = true;

    final response = await OrderRepository.instance.fetchOrders(
      page,
      paymentStatus ? 'P' : 'N',
      deliveredStatus ? 'D' : 'P',
    );

    if (page == 1) {
      orders.value = response.data;
    } else {
      orders.addAll(response.data);
    }

    if (orders.length < response.dataCount!) {
      currentpage++;
    } else {
      isLastPage = true;
    }

    isFetchingOrder.value = false;
  }
}
