import 'dart:developer';

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/product_list/models/product_model.dart';
import 'package:bookcenter/service/api_services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class ProductListRepository {
  ProductListRepository._();

  final _apiService = Get.find<ApiService>();
  static final ProductListRepository instance = ProductListRepository._();

  Future<ApiResponse> fetchProductsBySubCategory({
    required int subCategory,
    int? page,
  }) async {
    try {
      final response = await _apiService.get(
        '/store/v1/products/?sub_category=$subCategory&page=$page',
      );

      List<ProductModel> products = ProductModel.helper.fromMapArray(
        response.data['results'],
      );

      return ApiResponse(
        data: products,
        dataCount: response.data['count'],
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
