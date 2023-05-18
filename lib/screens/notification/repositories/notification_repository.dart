import 'dart:developer';

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/notification/models/notificaiton_model.dart';
import 'package:bookcenter/service/api_services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class NotificationRepository {
  NotificationRepository._();

  static final NotificationRepository instance = NotificationRepository._();

  final ApiService _apiService = Get.find<ApiService>();

  Future<ApiResponse> fetchNotification() async {
    try {
      final response = await _apiService.get('/notifications/');

      if (response.statusCode == 200) {
        List<NotificationModel> notifications =
            NotificationModel.helper.fromMapArray(response.data['results']);

        // log('notifications: ${notifications.length}');
        return ApiResponse(
          data: notifications,
          message: ApiMessage.success,
        );
      }
    } catch (e) {
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
