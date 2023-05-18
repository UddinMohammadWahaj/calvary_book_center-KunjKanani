import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/notification/models/notificaiton_model.dart';
import 'package:bookcenter/screens/notification/repositories/notification_repository.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  var isNotificationFetching = false.obs;
  List<NotificationModel> notifications = [];

  @override
  void onInit() {
    super.onInit();
    fetchNotification();
  }

  fetchNotification() async {
    isNotificationFetching.value = true;

    ApiResponse notificationResponse =
        await NotificationRepository.instance.fetchNotification();

    if (notificationResponse.message == ApiMessage.success) {
      notifications = notificationResponse.data as List<NotificationModel>;
    }
    isNotificationFetching.value = false;
  }
}
