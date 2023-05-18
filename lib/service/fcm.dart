import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (message.data.containsKey("data")) {
    final data = message.data['data'];
    // log("NOTIFICATION DATA: $data");
  }

  if (message.data.containsKey("notification")) {
    String subTitle = message.notification!.body!.toString(),
        title = message.notification!.title!.toString();
    // log("NOTIFICATION: $title$subTitle");
  }
  // log("Handling a background message: ${message.messageId}");
}

class FCM extends GetxController {
  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  initialize() {
    // log("FCM initialized");
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    foregroundNotification();

    backgroundNotification();

    terminatedNotification();
    getToken();
  }

  Future<String?> getToken() async {
    final token = await FirebaseMessaging.instance.getToken();

    // log("FCM token: $token");
    return token;
  }

  void foregroundNotification() {
    // log("foregroundNotification");
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        String subTitle = message.notification!.body ?? "",
            title = message.notification!.title!.toString();
        var data = message.data;
        // log("foregroundNotification DATA: $title - $subTitle");

        Get.snackbar(
          title,
          subTitle,
        );

        // OrderController orderController = Get.find();
        // orderController.validateOrder(OrderModel.fromMap(data));

        // Get.snackbar(title, subTitle, duration: const Duration(seconds: 5));
      },
    );
  }

  void backgroundNotification() {
    // log("backgroundNotification");
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      String subTitle = message.notification!.body!.toString(),
          title = message.notification!.title!.toString();
      // log("BackgroundNotification DATA: $title - $subTitle");
      // Get.snackbar(title, subTitle, duration: const Duration(seconds: 5));
    });
  }

  void terminatedNotification() async {
    // log("terminatedNotification");
    String subTitle = "";
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      // log("NOTIFICATION DATA: message.data.toString() - $subTitle ter");
      // Get.snackbar(message.data.toString(), subTitle);
    }
  }
}
