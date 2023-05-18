import 'dart:developer';

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/albums/models/album_model.dart';
import 'package:bookcenter/screens/bookstore/models/language_model.dart';
import 'package:bookcenter/service/api_services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class AlbumRepository {
  AlbumRepository._();

  static final AlbumRepository instance = AlbumRepository._();
  final _apiService = Get.find<ApiService>();

  Future<ApiResponse> fetchAlbums({
    required int page,
    required String paymentType,
    int? language,
    CancelToken? cancelToken,
  }) async {
    try {
      var url = '/store/v3/albums/?page=$page&payment_type=$paymentType';

      if (language != null && language != 0) {
        url += '&language=$language';
      }
      final response = await _apiService.get(
        url,
        cancelToken: cancelToken,
      );

      List<AlbumModel> albums = AlbumModel.helper.fromMapArray(
        response.data['results'],
      );

      return ApiResponse(
        data: albums,
        dataCount: response.data['count'],
        message: ApiMessage.success,
      );
    } catch (e) {
      log(e.toString());
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

  Future<ApiResponse> fetchAlbumById({required int id}) async {
    try {
      final response = await _apiService.get('/store/v2/albums/$id/');

      AlbumModel album = AlbumModel.fromMap(response.data['albums']);

      return ApiResponse(
        data: album,
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
