import 'dart:developer';

import 'package:bookcenter/route/route_constants.dart';
import 'package:bookcenter/screens/checkout/controllers/cart_controller.dart';
import 'package:bookcenter/screens/download/controller/download_controller.dart';
import 'package:bookcenter/service/address_service.dart';
import 'package:bookcenter/service/api_services/api_service.dart';
import 'package:bookcenter/service/audio_service.dart';
import 'package:bookcenter/service/cart_service.dart';
import 'package:bookcenter/service/digital_product_payment_service.dart';
import 'package:bookcenter/service/download_service.dart';
import 'package:bookcenter/service/storage_services/secure_file_storage.dart';
import 'package:bookcenter/service/user_service.dart';
import 'package:bookcenter/util/helper_methods.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class EntryPointService extends GetxService {
  final currentPage = 0.obs;

  var isFetchingStatus = false.obs;

  init() async {
    if (Get.arguments == null) {
      await isLoggedInAllow();
    } else if (Get.arguments['checkStatus'] ?? true) {
      await isLoggedInAllow();
    }

    if (Get.arguments != null) {
      currentPage.value = Get.arguments['index'] ?? 0;
    }
  }

  // TODO: Follow Architecture for this method. It needs to be in a repository and called from a controller.
  Future isLoggedInAllow() async {
    isFetchingStatus.value = true;
    var deviceId = await getId();

    try {
      var response = await Get.find<ApiService>().post(
        '/users/check-device-status/',
        {
          'device_id': deviceId,
        },
      );

      if (response.statusCode == 200) {
        if (!response.data['is_logged']) {
          await Get.put(UserService()).clearLocalStorage();
          await Get.offAllNamed(splashScreenRoute);
        } else {
          Get.put(UserService());
          Get.put(CartService());
          Get.put(AddressService());
          Get.put(CartController(), permanent: true);
          Get.put(SecureFileStorageService());
          Get.lazyPut(() => DigitalProductPaymentService());
          Get.lazyPut(() => AudioPlayerService());
          Get.lazyPut(() => DownloadService());
          Get.put(DownloadController(), permanent: true);
        }
      }
    } catch (e) {
      if (e is DioError) {
        await Get.put(UserService()).clearLocalStorage();
        await Get.offAllNamed(splashScreenRoute);
      }
    }

    isFetchingStatus.value = false;
  }
}
