import 'dart:developer';

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/models/book_model.dart';
import 'package:bookcenter/screens/albums/models/album_model.dart';
import 'package:bookcenter/screens/home/models/upcoming_event.dart';
import 'package:bookcenter/service/api_services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class HomeRespository {
  HomeRespository._();

  final _apiService = Get.find<ApiService>();
  static final HomeRespository instance = HomeRespository._();

  Future<ApiResponse> fetchUpcomingEvents() async {
    try {
      final response = await _apiService.get('/upcoming/');

      return ApiResponse(
        data: UpcomingEvent.helper.fromMapArray(response.data['results']),
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

  Future<ApiResponse> fetchLastestAlbums() async {
    try {
      final response = await _apiService.get('/store/albums/');

      List<AlbumModel> albums = AlbumModel.helper.fromMapArray(
        response.data['results'],
      );

      return ApiResponse(
        data: albums,
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

  Future<ApiResponse> fetchLastestBooks() async {
    try {
      final response = await _apiService.get('/store/v3/books?is_popular=true');

      List<BookModel> books = BookModel.helper.fromMapArray(
        response.data['results'],
      );

      return ApiResponse(
        data: books,
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
