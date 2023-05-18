import 'dart:developer';

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/route/screen_export.dart';
import 'package:bookcenter/screens/address/models/address_model.dart';
import 'package:bookcenter/screens/checkout/models/payment_model.dart';
import 'package:bookcenter/screens/checkout/repositories/order_repository.dart';
import 'package:bookcenter/service/cart_service.dart';
import 'package:bookcenter/service/razorpay_service.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController {
  var isProcessing = false.obs;
  double totalAmount = 0;
  int tip = 0;
  late AddressModel address;
  late PaymentModel order;
  @override
  void onInit() {
    extrectOrderData();
    initOrder();
    super.onInit();
  }

  void initOrder() async {
    isProcessing.value = true;
    ApiMessage apiMessage = await createOrderOnServer();

    if (apiMessage == ApiMessage.success) {
      RazorpayService.instance.openCheckout(
        key: order.rpayData.key,
        amount: order.rpayData.amount.floor(),
        orderId: order.rpayData.orderId,
        email: order.rpayData.prefill.email,
        contact: order.rpayData.prefill.contact,
        name: order.rpayData.name,
        description: order.rpayData.description,
        image: order.rpayData.image,
      );
    }

    isProcessing.value = false;
  }

  Future<ApiMessage> createOrderOnServer() async {
    ApiResponse response = await OrderRepository.instance.createOrderOnServer(
      data: {
        "items": Get.find<CartService>()
            .cartItems
            .map(
              (e) => {
                "product_id": e.id,
                "quantity": e.buyingQuantity,
                "price": e.salePrice,
              },
            )
            .toList(),
        "payment_status": "N",
        "payment_type": "RAZORPAY",
        "total_amount": totalAmount,
        "address_id": address.id,
        "tip": tip,
      },
    );

    if (response.message == ApiMessage.success) {
      // log(response.data.toString());
      order = response.data;
    }

    return response.message!;
  }

  void extrectOrderData() {
    address = Get.arguments['address'];
    totalAmount = Get.arguments['total'];
    tip = Get.arguments['tip'] ?? 0;
  }

  successOrder(trnsID) async {
    // log('trnsID: $trnsID');
    ApiMessage message = await _updateOrderStatusOnServer();

    if (message != ApiMessage.success) {
      Get.offAndToNamed(
        paymentFailScreenRoute,
        arguments: order,
      );
      return;
    }

    Get.find<CartService>().clearCart();
    Get.offAndToNamed(
      thanksForOrderScreenRoute,
      arguments: {
        "order": order,
        "isTrackOrder": true,
      },
    );
  }

  Future _updateOrderStatusOnServer() async {
    ApiResponse response = await OrderRepository.instance.updateOrderStatus(
      orderId: order.orderId,
      data: {
        "items": Get.find<CartService>()
            .cartItems
            .map(
              (e) => {
                "product_id": e.id,
                "quantity": e.buyingQuantity,
                "price": e.price,
              },
            )
            .toList(),
        "payment_status": "P",
        "payment_type": "RAZORPAY",
        "total_amount": totalAmount,
        "address_id": address.id!,
        "tip": tip,
        "transaction_id": RazorpayService.instance.transactionId,
      },
    );
    return response.message!;
  }

  void failedOrder() {
    Get.offAndToNamed(
      paymentFailScreenRoute,
      arguments: order,
    );
  }
}
