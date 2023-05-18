import 'dart:convert';
import 'dart:developer';

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/bookstore/models/language_model.dart';
import 'package:bookcenter/screens/sermons/models/sermon_model.dart';
import 'package:bookcenter/service/api_services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;

class SermonRepository {
  SermonRepository._();

  static final SermonRepository instance = SermonRepository._();
  final _apiService = getx.Get.find<ApiService>();

  Future<ApiResponse> fetchSermons({
    required int page,
    required String paymentType,
    int? language,
  }) async {
    try {
      var url = '/store/v3/sermons?page=$page&payment_type=$paymentType';

      if (language != null && language != 0) {
        url += '&language=$language';
      }
      final response = await _apiService.get(
        url,
      );
      // final response = Response(
      //   requestOptions: RequestOptions(path: ''),
      //   data: tempData,
      // );

      List<SermonModel> sermons = SermonModel.helper.fromMapArray(
        // jsonDecode(response.data!)['results'],
        response.data['results'],
      );

      return ApiResponse(
        data: sermons,
        // dataCount: jsonDecode(response.data!)['count'],
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

  Future<ApiResponse> fetchSermonById({required int id}) async {
    try {
      final response = await _apiService.get('/store/sermons/$id/');

      SermonModel sermon = SermonModel.fromMap(response.data);

      return ApiResponse(
        data: sermon,
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

  Future<ApiResponse> fetchLanguages({required int page}) async {
    try {
      final response = await _apiService.get(
        '/store/v3/book_languages/?page=$page',
      );

      List<LanguageModel> languages = LanguageModel.helper.fromMapArray(
        response.data['results'],
      );

      return ApiResponse(
        data: languages,
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
