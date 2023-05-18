import 'dart:developer';

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/product_list/models/product_model.dart';
import 'package:bookcenter/service/api_services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class BookmarkRepository {
  BookmarkRepository._();
  static final BookmarkRepository instance = BookmarkRepository._();

  final ApiService _apiService = Get.find<ApiService>();

  Future<ApiResponse> fetchBookmarks({required int page}) async {
    try {
      final response = await _apiService.get(
        '/wishlist/?page=$page',
      );

      List<ProductModel> bookmarkedProducts = ProductModel.helper.fromMapArray(
        response.data['results'],
      );
      // log(response.data['count'].toString());
      return ApiResponse(
        data: bookmarkedProducts,
        dataCount: response.data['count'] ?? 0,
        message: ApiMessage.success,
      );
    } catch (error) {
      if (error is DioError) {
        return ApiResponse(
          message: ApiMessage.apiError,
          data: error.response?.data,
        );
      }

      return ApiResponse(
        message: ApiMessage.somethingWantWrongError,
      );
    }
  }
}
