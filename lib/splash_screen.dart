import 'package:bookcenter/route/screen_export.dart';
import 'package:bookcenter/service/storage_services/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 2),
      () async {
        var openOnBoarding = false;
        LocalStoragaeService localStoragaeService =
            Get.put(LocalStoragaeService());

        await localStoragaeService.initBoxes();

        if (localStoragaeService.getUserValue(UserField.isFirstTime) == null) {
          await const FlutterSecureStorage().deleteAll();
          await localStoragaeService.clearUserData();

          await localStoragaeService.updateUserData({
            UserField.isFirstTime.asString: true,
          });

          openOnBoarding = true;
        }
        // Get.snackbar(
        //   localStoragaeService.getUserValue(UserField.token) ?? 'Empty',
        //   '',
        // );
        String route =
            localStoragaeService.getUserValue(UserField.token) == null ||
                    localStoragaeService.getUserValue(UserField.token) == "" ||
                    localStoragaeService.getUserValue(UserField.token) == " " ||
                    localStoragaeService.getUserValue(UserField.token) == "null"
                ? openOnBoarding
                    ? onbordingScreenRoute
                    : logInScreenRoute
                : entryPointScreenRoute;

        Get.offAllNamed(route);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Image.asset(
              "assets/logo/calvary.png",
              width: 200,
              height: 200,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              "Calvary Book Center",
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
        ],
      ),
    );
  }
}
