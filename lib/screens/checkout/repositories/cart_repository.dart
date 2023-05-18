import 'dart:developer';

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/checkout/models/coupon_model.dart';
import 'package:bookcenter/screens/order/models/order_model.dart';
import 'package:bookcenter/service/api_services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class CartRepository {
  CartRepository._();

  static final CartRepository instance = CartRepository._();
  final _apiService = Get.find<ApiService>();

  Future<ApiResponse> fetchCoupons({
    required int page,
    required String type,
  }) async {
    try {
      final response = await _apiService.get(
        '/coupons/v1/code/?page=$page&product_type=$type&page_size=10',
      );

      if (response.statusCode == 200) {
        List<CouponModel> coupons = CouponModel.helper.fromMapArray(
          response.data['results'],
        );

        // log('coupons: ${coupons.length}');

        return ApiResponse(
          message: ApiMessage.success,
          data: coupons,
          dataCount: response.data['count'],
        );
      }
    } catch (e) {
      // log('fetchCoupons: $e');
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

  Future<ApiResponse> applyCoupon(List<int?> ids) async {
    try {
      final response = await _apiService.post(
        '/coupons/apply/',
        {
          'coupon': ids,
        },
      );

      if (response.statusCode == 200) {
        return ApiResponse(
          message: ApiMessage.success,
          data: response.data,
        );
      }
    } catch (e) {
      log('applyCoupon: $e');
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

  Future<ApiResponse> fetchDeliveryCharges({
    required int address,
    required double weight,
  }) async {
    try {
      final response = await _apiService.get(
        '/cart/delivery_price/?address=$address&total_weight=$weight',
      );

      if (response.statusCode == 200) {
        return ApiResponse(
          message: ApiMessage.success,
          data: response.data['delivery_price'],
        );
      }
    } catch (error) {
      if (error is DioError) {
        if (error.response?.statusCode == 400) {
          return ApiResponse(
            message: ApiMessage.apiError,
            data: error.response!.data,
          );
        }
      }
    }

    return ApiResponse(
      message: ApiMessage.somethingWantWrongError,
    );
  }

  Future<ApiResponse> fetchOrderDetails({required id}) async {
    try {
      final response = await _apiService.get(
        '/cart/orders/rpay/$id/',
      );

      if (response.statusCode == 200) {
        return ApiResponse(
          message: ApiMessage.success,
          data: OrderModel.fromMap(response.data),
        );
      }
    } catch (error) {
      if (error is DioError) {
        if (error.response?.statusCode == 400) {
          return ApiResponse(
            message: ApiMessage.apiError,
            data: error.response!.data,
          );
        }
      }
    }

    return ApiResponse(
      message: ApiMessage.somethingWantWrongError,
    );
  }
}
