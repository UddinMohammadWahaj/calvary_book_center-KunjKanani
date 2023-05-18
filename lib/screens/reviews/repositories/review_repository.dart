import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/reviews/models/review_model.dart';
import 'package:bookcenter/service/api_services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class ReviewRepository {
  ReviewRepository._();
  static final ReviewRepository instance = ReviewRepository._();
  final ApiService _apiService = Get.find<ApiService>();

  Future<ApiResponse> getProductReviews(int productId, int page) async {
    try {
      final response = await _apiService.get(
        '/store/v1/product_reviews/?product=$productId&page=$page',
      );

      if (response.statusCode == 200) {
        List<ReviewModel> reviews = ReviewModel.helper.fromMapArray(
          response.data['results'],
        );

        return ApiResponse(
          data: reviews,
          message: ApiMessage.success,
          dataCount: response.data['count'],
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

  Future<ApiResponse> createReview({
    required int productId,
    required double rating,
    required String title,
    required String description,
  }) async {
    try {
      final response = await _apiService.post(
        '/store/v1/product_reviews/',
        {
          'product': productId,
          'ratings': rating,
          'title': title,
          'description': description,
        },
      );

      if (response.statusCode == 201) {
        return ApiResponse(
          message: ApiMessage.success,
        );
      }
    } catch (e) {
      if (e is DioError) {
        return ApiResponse(
          message: ApiMessage.apiError,
          data: e.response?.data['non_field_errors'][0],
        );
      }
    }

    return ApiResponse(
      message: ApiMessage.somethingWantWrongError,
    );
  }
}
