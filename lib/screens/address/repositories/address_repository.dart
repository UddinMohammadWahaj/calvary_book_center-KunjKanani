import 'dart:developer';

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/address/models/address_model.dart';
import 'package:bookcenter/screens/address/models/country_state_model.dart';
import 'package:bookcenter/service/api_services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class AddressRepository {
  AddressRepository._();

  static final AddressRepository instance = AddressRepository._();
  final _apiService = Get.find<ApiService>();

  // Fetch Addresses
  Future<ApiResponse> fetchAddresses() async {
    try {
      final response = await _apiService.get(
        '/cart/address/',
        cache: true,
        cacheExpiry: const Duration(days: 365),
      );

      if (response.statusCode == 200) {
        List<AddressModel> addresses = AddressModel.helper.fromMapArray(
          response.data['result']['results'],
        );
        return ApiResponse(
          message: ApiMessage.success,
          data: addresses,
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

  Future<ApiResponse> fetchFormData() async {
    try {
      final response = await _apiService.get(
        '/cart/state/',
        cache: true,
        cacheExpiry: const Duration(days: 365),
      );

      if (response.statusCode == 200) {
        CountryStateModel countryStateModel =
            CountryStateModel.fromMap(response.data);
        return ApiResponse(
          message: ApiMessage.success,
          data: countryStateModel,
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

  Future<ApiResponse> addAddress({
    required String name,
    required String mobile,
    required String address,
    required String address2,
    required int countryId,
    required int stateId,
    required int cityId,
    required int pinCodeId,
  }) async {
    try {
      final response = await _apiService.post(
        '/cart/address/',
        {
          'name': name,
          'mobile': mobile,
          'address': address,
          'address2': address2,
          'country': countryId,
          'state': stateId,
          'city': cityId,
          'pin_code': pinCodeId,
        },
      );

      if (response.statusCode == 201) {
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

  Future<ApiResponse> deleteAddress(int id) async {
    try {
      final response = await _apiService.delete('/cart/address/', id);

      if (response.statusCode == 204) {
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

  updateAddress({
    required int addressId,
    required String name,
    required String mobile,
    required String address,
    required String address2,
    required int countryId,
    required int stateId,
    required int cityId,
    required int pinCodeId,
  }) async {
    try {
      final response = await _apiService.patch(
        '/cart/address/',
        addressId,
        {
          'name': name,
          'mobile': mobile,
          'address': address,
          'address2': address2,
          'country': countryId,
          'state': stateId,
          'city': cityId,
          'pin_code': pinCodeId,
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
            data: e.response!.data,
          );
        }
      }

      return ApiResponse(
        message: ApiMessage.somethingWantWrongError,
      );
    }
  }
}
