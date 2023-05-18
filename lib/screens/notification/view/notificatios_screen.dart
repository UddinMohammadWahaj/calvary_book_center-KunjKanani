import 'package:bookcenter/components/skleton/others/notification_skeleton.dart';
import 'package:bookcenter/screens/checkout/views/empty_screen.dart';
import 'package:bookcenter/screens/notification/controllers/notification_controller.dart';
import 'package:bookcenter/screens/notification/view/components/no_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bookcenter/constants.dart';
import 'package:get/get.dart';

import 'components/notification_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: const [
          // IconButton(
          //   onPressed: () {},
          //   icon: SvgPicture.asset(
          //     "assets/icons/DotsV.svg",
          //     color: Theme.of(context).iconTheme.color,
          //   ),
          // )
        ],
      ),
      body: SafeArea(
        // For no notification use
        // NoNotification()
        child: GetX<NotificationController>(
          init: NotificationController(),
          builder: (controller) {
            return controller.isNotificationFetching.value
                ? ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) =>
                        const NotificationSkeleton(),
                  )
                : controller.notifications.isEmpty
                    ? const EmptyScreen(title: 'No Notification')
                    : ListView.builder(
                        itemCount: controller.notifications.length,
                        itemBuilder: (context, index) => NotificationCard(
                          title: controller.notifications[index].title,
                          svgSrc: index.isEven
                              ? "assets/icons/Discount.svg"
                              : "assets/icons/diamond.svg",
                          time: controller.notifications[index].body,
                          iconBgColor: index.isEven
                              ? const Color(0xFFF3B923)
                              : primaryColor,
                          isRead: index > 2,
                        ),
                      );
          },
        ),
      ),
    );
  }
}
