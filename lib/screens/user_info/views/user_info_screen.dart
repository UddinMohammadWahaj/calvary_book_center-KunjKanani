import 'package:bookcenter/screens/user_info/controllers/user_info_controller.dart';
import 'package:bookcenter/service/storage_services/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:bookcenter/constants.dart';
import 'package:bookcenter/route/route_constants.dart';
import 'package:get/get.dart';

import '../../profile/views/components/profile_card.dart';
import 'components/user_info_list_tile.dart';

class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          TextButton(
            onPressed: () {
              Get.toNamed(editUserInfoScreenRoute);
            },
            child: const Text("Edit"),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: GetX<UserInfoController>(
          init: UserInfoController(),
          builder: (controller) {
            return Column(
              children: [
                const SizedBox(height: defaultPadding),
                ProfileCard(
                  name: controller.currentUser.value.name ?? "",
                  email: controller.currentUser.value.email ?? "",
                  imageSrc:
                      "https://cdn-icons-png.flaticon.com/512/147/147142.png",
                  // proLableText: "Sliver",
                  // isPro: true, if the user is pro
                  isShowHi: false,
                  isShowArrow: false,
                ),
                const SizedBox(height: defaultPadding * 1.5),
                UserInfoListTile(
                  leadingText: "Name",
                  trailingText: Get.find<LocalStoragaeService>()
                      .getUserValue(UserField.name),
                ),
                // const UserInfoListTile(
                //   leadingText: "Date of birth",
                //   trailingText: "Date of birth",
                // ),
                UserInfoListTile(
                  leadingText: "Phone number",
                  trailingText: Get.find<LocalStoragaeService>()
                      .getUserValue(UserField.mobile),
                ),
                // const UserInfoListTile(
                //   leadingText: "Gender",
                //   trailingText: "Female",
                // ),
                UserInfoListTile(
                  leadingText: "Email",
                  trailingText: Get.find<LocalStoragaeService>()
                      .getUserValue(UserField.email),
                ),
                // ListTile(
                //   leading: const Text("Password"),
                //   trailing: TextButton(
                //     onPressed: () {
                //       // Navigator.pushNamed(context, currentPasswordScreenRoute);
                //     },
                //     child: const Text("Change password"),
                //   ),
                // )
              ],
            );
          },
        ),
      ),
    );
  }
}
