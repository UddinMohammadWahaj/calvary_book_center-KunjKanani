import 'package:bookcenter/firebase_options.dart';
import 'package:bookcenter/route/route_constants.dart';
import 'package:bookcenter/screens/auth/controllers/login_auth_controller.dart';
import 'package:bookcenter/service/api_services/api_service.dart';
import 'package:bookcenter/service/fcm.dart';
import 'package:bookcenter/service/storage_services/cache_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:bookcenter/route/router.dart' as router;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'theme/dark_theme.dart';
import 'theme/light_theme.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Make View protrait only
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  /// HIVE configuraion
  final directory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  // await Hive.openBox(kUserDataBoxName);
  // await Hive.openBox(kCartBoxName);
  await Hive.openBox(kCacheBoxName);

  await NoScreenshot.instance.screenshotOff();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Calvary Book Center',
      theme: lightTheme(context),
      darkTheme: darkTheme(context),
      themeMode: ThemeMode.light,
      initialRoute: splashScreenRoute,
      initialBinding: BindingsBuilder(
        () {
          Get.put(ApiService());
          Get.put(LoginAuthController());
          Get.put(FCM());
        },
      ),
      getPages: router.getXRouterPages(),
    );
  }
}
