import 'dart:developer';

import 'package:bookcenter/screens/checkout/controllers/payment_controller.dart';
import 'package:bookcenter/service/digital_product_payment_service.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

enum OrderType { physical, digital }

class RazorpayService {
  Razorpay? razorpay = Razorpay();

  RazorpayService._();

  static RazorpayService instance = RazorpayService._();

  var transactionId = '';
  late OrderType orderType;

  void init() {
    razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // log('payment success: ${response.paymentId}');
    transactionId = response.paymentId!;

    if (orderType == OrderType.physical) {
      Get.find<PaymentController>().successOrder(transactionId);
    } else {
      Get.find<DigitalProductPaymentService>().successOrder(transactionId);
    }

    dispose();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // log('payment error: ${response.code} - ${response.message}');
    if (orderType == OrderType.physical) {
      Get.find<PaymentController>().failedOrder();
    } else {
      Get.find<DigitalProductPaymentService>().failedOrder();
    }

    dispose();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // log('external wallet: ${response.walletName}');
    dispose();
  }

  void openCheckout({
    required int amount,
    required String name,
    required String description,
    required String email,
    required String contact,
    required String image,
    required String orderId,
    required String key,
    OrderType orderType = OrderType.physical,
  }) {
    init();
    this.orderType = orderType;

    var options = {
      'key': key,
      'amount': amount * 100,
      'name': name,
      'description': description,
      'prefill': {'contact': contact, 'email': email},
      'order_id': orderId,
    };

    try {
      razorpay!.open(options);
    } catch (e) {
      // log(e.toString());
    }
  }

  void dispose() {
    transactionId = '';
    razorpay!.clear();
  }
}
