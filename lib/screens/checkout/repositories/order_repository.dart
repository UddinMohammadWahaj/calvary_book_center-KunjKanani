import 'dart:developer';

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/checkout/models/payment_model.dart';
import 'package:bookcenter/service/api_services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class OrderRepository {
  OrderRepository._();
  static final OrderRepository instance = OrderRepository._();

  final _apiService = Get.find<ApiService>();

  Future createOrderOnServer({
    required Map<String, dynamic> data,
    String? url,
  }) async {
    try {
      final reponse = await _apiService.post(
        url ?? '/cart/orders/rpay/',
        data,
      );

      if (reponse.statusCode == 201) {
        // log('createOrderOnServer: ${reponse.data}');
        return ApiResponse(
          message: ApiMessage.success,
          data: PaymentModel.fromMap(reponse.data),
        );
      }
    } catch (e) {
      // log('createOrderOnServer: $e');
      if (e is DioError) {
        if (e.response?.statusCode == 400) {
          return ApiResponse(
            message: ApiMessage.apiError,
            data: e.response!.data,
          );
        }
      }
    }

    return ApiResponse(
      message: ApiMessage.somethingWantWrongError,
    );
  }

  Future updateOrderStatus({
    required int orderId,
    required Map<String, Object> data,
    String? url,
  }) async {
    try {
      final reponse = await _apiService.put(
        url != null ? '$url$orderId/' : '/cart/orders/rpay/$orderId/',
        data,
      );

      if (reponse.statusCode == 201 || reponse.statusCode == 200) {
        // log('updateOrderStatus: ${reponse.data}');
        return ApiResponse(
          message: ApiMessage.success,
        );
      }
    } catch (e) {
      // log('updateOrderStatus: $e');
      if (e is DioError) {
        if (e.response?.statusCode == 400) {
          return ApiResponse(
            message: ApiMessage.apiError,
            data: e.response!.data,
          );
        }
      }
    }

    return ApiResponse(
      message: ApiMessage.somethingWantWrongError,
    );
  }
}
