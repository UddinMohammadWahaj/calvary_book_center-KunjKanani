import 'dart:developer';

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/order/models/order_model.dart';
import 'package:bookcenter/service/api_services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class OrderRepository {
  OrderRepository._();

  static final OrderRepository instance = OrderRepository._();
  final ApiService _apiService = Get.find<ApiService>();

  Future<ApiResponse> fetchOrders(
      int page, String paymentStatus, String deliveryStatus) async {
    try {
      final response = await _apiService.get(
        '/cart/orders/rpay/?page=$page&payment_status=$paymentStatus&delivery_status=$deliveryStatus',
      );

      if (response.statusCode == 200) {
        List<OrderModel> orders = OrderModel.helper.fromMapArray(
          response.data['results'],
        );

        return ApiResponse(
          data: orders,
          message: ApiMessage.success,
          dataCount: response.data['count'],
        );
      }
    } catch (error) {
      // log(error.toString());
      if (error is DioError) {
        return ApiResponse(
          message: ApiMessage.apiError,
          data: error.response?.data,
        );
      }
    }

    return ApiResponse(
      message: ApiMessage.somethingWantWrongError,
    );
  }
}
