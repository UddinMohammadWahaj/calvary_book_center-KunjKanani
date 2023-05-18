import 'package:bookcenter/constants.dart';
import 'package:bookcenter/service/api_services/api_service.dart';
import 'package:bookcenter/service/storage_services/local_storage_service.dart';
import 'package:bookcenter/service/user_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class UserInfoRepository {
  UserInfoRepository._();
  static final UserInfoRepository instance = UserInfoRepository._();
  final _apiService = Get.find<ApiService>();

  Future<ApiResponse> updateUserInfo(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.patch(
        '/users/',
        Get.find<UserService>().user.value.userId ?? 0,
        data,
      );

      if (response.statusCode == 200) {
        Get.find<LocalStoragaeService>().updateUserData(data);
        Get.find<UserService>().refreshUser();
        return ApiResponse(
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
