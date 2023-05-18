import 'package:bookcenter/constants.dart';
import 'package:bookcenter/service/api_services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class WishlistRepository {
  WishlistRepository._();

  static final WishlistRepository instance = WishlistRepository._();
  final ApiService _apiService = Get.find<ApiService>();

  Future<ApiResponse> addToWishlist(int productId) async {
    try {
      final response = await _apiService.post(
        '/wishlist/',
        {
          'product': [
            productId,
          ],
        },
      );

      if (response.statusCode == 201) {
        return ApiResponse(
          message: ApiMessage.success,
          data: response.data,
        );
      }
    } catch (error) {
      if (error is DioError) {
        return ApiResponse(
          message: ApiMessage.apiError,
          data: error.response?.data,
        );
      }
    }
    return ApiResponse(
      message: ApiMessage.somethingWantWrongError,
    );
  }

  Future<ApiResponse> removeFromWishlist(int id) async {
    try {
      final response = await _apiService.post(
        '/wishlist/remove/',
        {
          'product': [id]
        },
      );

      if (response.statusCode == 200) {
        return ApiResponse(
          message: ApiMessage.success,
          data: response.data,
        );
      }
    } catch (error) {
      if (error is DioError) {
        return ApiResponse(
          message: ApiMessage.apiError,
          data: error.response?.data,
        );
      }
    }
    return ApiResponse(
      message: ApiMessage.somethingWantWrongError,
    );
  }
}
