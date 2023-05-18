import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/daily_promises/model/daily_promises_model.dart';
import 'package:bookcenter/service/api_services/api_service.dart';
import 'package:get/get.dart';

class DailyPromiseRepository {
  static final DailyPromiseRepository instance = DailyPromiseRepository._();
  DailyPromiseRepository._();
  final _apiService = Get.find<ApiService>();
  Future<ApiResponse> fetchDailyPromises() async {
    try {
      final response = await _apiService.get('/daily_promise/');

      List<DailyPromise> dailyPromises = DailyPromise.helper.fromMapArray(
        response.data['results'],
      );

      return ApiResponse(
        data: dailyPromises,
        message: ApiMessage.success,
      );
    } catch (e) {
      return ApiResponse(
        message: ApiMessage.somethingWantWrongError,
      );
    }
  }
}
