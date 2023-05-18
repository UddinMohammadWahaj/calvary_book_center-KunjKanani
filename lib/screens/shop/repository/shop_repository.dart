import 'dart:developer';

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/shop/models/category.dart';
import 'package:bookcenter/service/api_services/api_service.dart';
import 'package:bookcenter/service/storage_services/cache_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class ShopRepository {
  ShopRepository._();
  final _apiService = Get.find<ApiService>();

  static final ShopRepository instance = ShopRepository._();

  Future<ApiResponse> fetchCategories() async {
    try {
      final response = await _apiService.get(
        '/store/v1/categories/',
        cache: true,
        cacheExpiry: const Duration(days: 1),
      );

      List<CategoryModel> categories = CategoryModel.helper.fromMapArray(
        response.data['results'],
      );

      return ApiResponse(
        data: categories,
        message: ApiMessage.success,
      );
    } catch (e) {
      // log(e.toString());
      if (e is DioError) {
        return ApiResponse(
          message: ApiMessage.apiError,
          data: e.response?.data,
        );
      }

      return ApiResponse(
        message: ApiMessage.somethingWantWrongError,
      );
    }
  }
}
