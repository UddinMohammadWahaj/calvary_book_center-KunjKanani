import 'dart:developer';

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/models/book_model.dart';
import 'package:bookcenter/screens/bookstore/models/book_category_model.dart';
import 'package:bookcenter/screens/bookstore/models/language_model.dart';
import 'package:bookcenter/service/api_services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class BookStoreRepository {
  BookStoreRepository._();
  static final BookStoreRepository instance = BookStoreRepository._();

  final ApiService _apiService = Get.find<ApiService>();

  Future<ApiResponse> getBookCategories(int page) async {
    try {
      final response = await _apiService.get(
        '/store/v3/book_categories/?page=$page',
      );

      List<BookCategoryModel> bookCategories =
          BookCategoryModel.helper.fromMapArray(response.data['results']);

      return ApiResponse(
        data: bookCategories,
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

  fetchBooksBySubCategory({
    int? category,
    required int page,
    int? language,
    required String paymentType,
  }) async {
    try {
      var booksApi = '/store/v3/books/?page=$page&payment_type=$paymentType';

      if (category != null && category != 0) {
        booksApi += '&category=$category';
      }

      if (language != null && language != 0) {
        booksApi += '&language=$language';
      }

      final response = await _apiService.get(
        booksApi,
      );

      List<BookModel> books = BookModel.helper.fromMapArray(
        response.data['results'],
      );

      return ApiResponse(
        data: books,
        dataCount: response.data['count'],
        message: ApiMessage.success,
      );
    } catch (error) {
      // log(error.toString());
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

  Future<ApiResponse> fetchBookById({required int bookId}) async {
    try {
      final response = await _apiService.get('/store/v3/books/$bookId/');

      BookModel book = BookModel.fromMap(response.data['albums']);

      return ApiResponse(
        data: book,
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
