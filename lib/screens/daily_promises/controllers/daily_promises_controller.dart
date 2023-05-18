import 'dart:developer';

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/daily_promises/model/daily_promises_model.dart';
import 'package:bookcenter/screens/daily_promises/repository/daily_promise_repository.dart';
import 'package:get/get.dart';

class DailyPromissesController extends GetxController {
  final isFetchingDailyPromises = true.obs;
  List<DailyPromise> dailyPromises = [];

  @override
  void onInit() {
    fetchDailyPromise();
    super.onInit();
  }

  Future fetchDailyPromise() async {
    isFetchingDailyPromises.value = true;

    ApiResponse apiResponse =
        await DailyPromiseRepository.instance.fetchDailyPromises();

    // log(apiResponse.data.toString());
    if (apiResponse.message == ApiMessage.success) {
      dailyPromises = apiResponse.data;
    }

    isFetchingDailyPromises.value = false;
  }
}
