import 'dart:developer';

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/models/book_model.dart';
import 'package:bookcenter/screens/albums/models/album_model.dart';
import 'package:bookcenter/screens/search/models/search_model.dart';
import 'package:bookcenter/screens/sermons/models/sermon_model.dart';
import 'package:bookcenter/service/api_services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class SearchRepository {
  SearchRepository._();

  static final SearchRepository instance = SearchRepository._();

  final _apiService = Get.find<ApiService>();

  Future<ApiResponse> search({required String query, required int page}) async {
    try {
      final response = await _apiService.get(
        "/store/v3/q?query=$query&page=$page",
      );

      var results = SearchModel.helper.fromMapArray(response.data['results']);

      return ApiResponse(
        message: ApiMessage.success,
        data: results,
        dataCount: response.data['count'],
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
        data: error.toString(),
      );
    }
  }
}
