import 'package:bookcenter/route/route_constants.dart';
import 'package:bookcenter/screens/auth/models/user_model.dart';
import 'package:bookcenter/screens/checkout/controllers/cart_controller.dart';
import 'package:bookcenter/screens/download/controller/download_controller.dart';
import 'package:bookcenter/screens/home/controllers/home_controller.dart';
import 'package:bookcenter/service/address_service.dart';
import 'package:bookcenter/service/audio_service.dart';
import 'package:bookcenter/service/cart_service.dart';
import 'package:bookcenter/service/entry_point_service.dart';
import 'package:bookcenter/service/storage_services/cache_service.dart';
import 'package:bookcenter/service/storage_services/local_storage_service.dart';
import 'package:bookcenter/service/storage_services/secure_file_storage.dart';
import 'package:get/get.dart';

class UserService extends GetxService {
  final user = UserModel().obs;
  var isUserLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.find<LocalStoragaeService>().getUserValue(UserField.userId) !=
        null) {
      refreshUser();

      isUserLoggedIn();
    }
  }

  void refreshUser() {
    user.value = UserModel(
      name: Get.find<LocalStoragaeService>().getUserValue(UserField.name),
      email: Get.find<LocalStoragaeService>().getUserValue(UserField.email),
      mobile: Get.find<LocalStoragaeService>().getUserValue(UserField.mobile),
      token: Get.find<LocalStoragaeService>().getUserValue(UserField.token),
      userId: int.parse(
        Get.find<LocalStoragaeService>().getUserValue(UserField.userId),
      ),
    );
  }

  Future clearLocalStorage() async {
    await Get.put(CartService()).clearCart();
    await Get.find<LocalStoragaeService>().clearUserData();
    await Get.find<LocalStoragaeService>().clearCartData();

    await Get.find<LocalStoragaeService>().close();
    await CacheService.instance.deleteAllDataFromCache();

    await Get.put(SecureFileStorageService()).deleteAllFiles();
    await Get.delete<EntryPointService>();
  }

  Future logout() async {
    // await Get.find<LocalStoragaeService>().clearUserData();
    // await Get.find<LocalStoragaeService>().clearCartData();

    // await Get.find<LocalStoragaeService>().close();
    // await CacheService.instance.deleteAllDataFromCache();
    // Get.find<CartService>().clearCart();

    // await Get.find<SecureFileStorageService>().deleteAllFiles();

    await clearLocalStorage();
    Get.delete<CacheService>(force: true);
    Get.delete<AddressService>(force: true);
    Get.delete<HomeController>(force: true);
    Get.delete<DownloadController>(force: true);
    Get.delete<CartController>(force: true);
    Get.delete<AudioPlayerService>(force: true);
    Get.delete<LocalStoragaeService>(force: true);
    Get.delete<EntryPointService>(force: true);

    await Get.offAllNamed(splashScreenRoute);
  }
}
