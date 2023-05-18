import 'dart:developer';

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/service/api_services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class ProfileRepo {
  ProfileRepo._();

  static ProfileRepo instance = ProfileRepo._();

  final _apiService = Get.find<ApiService>();

  Future<ApiResponse> logout({
    required String deviceId,
  }) async {
    try {
      final response = await _apiService.post(
        '/user/device/logout/',
        {
          'device_id': deviceId,
        },
      );

      if (response.statusCode == 200) {
        return ApiResponse(
          message: ApiMessage.success,
        );
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response?.statusCode == 400) {
          return ApiResponse(
            message: ApiMessage.apiError,
            data: e.response!.data.toString(),
          );
        }
      }
    }

    return ApiResponse(
      message: ApiMessage.apiError,
    );
  }
}
