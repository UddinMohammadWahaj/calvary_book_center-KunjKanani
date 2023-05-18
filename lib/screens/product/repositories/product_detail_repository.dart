import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/product_list/models/product_model.dart';
import 'package:bookcenter/service/api_services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class ProductDetailRepository {
  ProductDetailRepository._();

  static final ProductDetailRepository instance = ProductDetailRepository._();

  final ApiService _apiService = Get.find<ApiService>();

  Future<ApiResponse> getProductDetail(String productId) async {
    try {
      final response = await _apiService.get('/store/v1/products/$productId/');

      if (response.statusCode == 200) {
        ProductModel product = ProductModel.fromMap(response.data);

        return ApiResponse(
          data: product,
          message: ApiMessage.success,
        );
      }
    } catch (e) {
      if (e is DioError) {
        return ApiResponse(
          message: ApiMessage.apiError,
          data: e.response?.data,
        );
      }
    }
    return ApiResponse(
      message: ApiMessage.somethingWantWrongError,
    );
  }
}
