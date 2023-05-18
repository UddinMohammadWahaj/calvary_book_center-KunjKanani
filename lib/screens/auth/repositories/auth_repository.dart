// Auth repository class to handle all the authentication related operations using the REST API

import 'dart:convert';
import 'dart:developer';

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/auth/models/user_model.dart';
import 'package:bookcenter/service/storage_services/local_storage_service.dart';
import 'package:bookcenter/service/user_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:bookcenter/service/api_services/api_service.dart';

// Singleton class
class AuthRepository {
  final _apiService = Get.find<ApiService>();
  final _userService = Get.put(UserService());
  static final instance = AuthRepository._();

  AuthRepository._();

  Future<ApiResponse> login(
    String mobile,
    String password, {
    required String deviceId,
  }) async {
    try {
      final response = await _apiService.post(
        '/auth/',
        {
          'username': mobile,
          'password': password,
          'device_id': deviceId,
        },
      );

      if (response.statusCode == 201) {
        // Save the userdata in the local storage
        // log(response.data.toString());
        await Get.find<LocalStoragaeService>().updateUserData(
          response.data,
        );

        // Update the user data in the user service
        _userService.refreshUser();

        return ApiResponse(
          data: UserModel.fromMap(response.data),
          message: ApiMessage.success,
        );
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response?.statusCode == 400) {
          return ApiResponse(
            message: ApiMessage.apiError,
            data: e.response!.data['non_field_errors'][0],
          );
        }
      }
      // log(e.toString());
    }

    return ApiResponse(
      message: ApiMessage.somethingWantWrongError,
    );
  }

  Future<ApiResponse> register({
    required String mobile,
    required String password,
    required String name,
    required String email,
    required String deviceId,
  }) async {
    try {
      final response = await _apiService.post(
        '/users/',
        {
          'mobile': mobile,
          'password': password,
          'name': name,
          'email': email,
          'device_id': deviceId,
        },
      );

      if (response.statusCode == 201) {
        // log(response.data.toString());

        // Save the userdata in the local storage
        await Get.find<LocalStoragaeService>().updateUserData(
          response.data,
        );

        _userService.refreshUser();

        return ApiResponse(
          message: ApiMessage.success,
        );
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response?.statusCode == 400) {
          return ApiResponse(
            message: ApiMessage.apiError,
            data: e.response!.data['mobile'][0],
          );
        }
      }
      // log(e.toString());
    }

    return ApiResponse(
      message: ApiMessage.somethingWantWrongError,
    );
  }

  Future<ApiResponse> checkUserExist({
    required String email,
    String mobile = '',
  }) async {
    try {
      final response = await _apiService.get(
        '/users/?email=$email&mobile=$mobile',
      );

      // log(response.data.toString());

      if (response.statusCode == 200) {
        Map<String, dynamic> userData = response.data['results'][0];
        return ApiResponse(
          message: ApiMessage.success,
          data: UserModel.fromMap(
            userData,
          ),
        );
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response?.statusCode == 400) {
          return ApiResponse(
            message: ApiMessage.apiError,
            data: e.response!.data['mobile'][0],
          );
        }
      }
      // log(e.toString());
    }

    return ApiResponse(
      message: ApiMessage.somethingWantWrongError,
    );
  }

  Future<ApiResponse> changePassword(
    int? userId,
    String? mobile,
    String text,
  ) async {
    try {
      final response = await _apiService.post(
        '/users/${userId.toString()}/change-password/',
        {
          'mobile': mobile,
          'password': text,
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
            data: e.response!.data['mobile'][0],
          );
        }
      }
    }
    return ApiResponse(
      message: ApiMessage.somethingWantWrongError,
    );
  }
}
