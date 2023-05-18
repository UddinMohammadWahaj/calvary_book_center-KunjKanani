import 'package:bookcenter/screens/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bookcenter/constants.dart';
import 'package:bookcenter/route/screen_export.dart';
import 'package:get/get.dart';

import 'components/profile_card.dart';
import 'components/profile_menu_item_list_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          GetX<ProfileController>(
            init: ProfileController(),
            builder: (controller) {
              return ProfileCard(
                name: controller.currentUser.value.name ?? "",
                email: controller.currentUser.value.email ?? "",
                imageSrc:
                    "https://cdn-icons-png.flaticon.com/512/147/147142.png",
                // proLableText: "Sliver",
                // isPro: true, //if the user is pro
                press: () {
                  Navigator.pushNamed(context, userInfoScreenRoute);
                },
              );
            },
          ),

          Padding(
            padding: const EdgeInsets.only(
              right: defaultPadding,
              left: defaultPadding,
              top: defaultPadding * 1.5,
            ),
            child: Text(
              "Account",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          ProfileMenuListTile(
            text: "Orders",
            svgSrc: "assets/icons/Order.svg",
            press: () {
              Navigator.pushNamed(context, ordersScreenRoute);
            },
          ),
          ProfileMenuListTile(
            text: "Wishlist",
            svgSrc: "assets/icons/Wishlist.svg",
            press: () {
              Get.toNamed(bookmarkScreenRoute);
            },
          ),
          ProfileMenuListTile(
            text: "Addresses",
            svgSrc: "assets/icons/Address.svg",
            press: () {
              Navigator.pushNamed(context, addressesScreenRoute);
            },
          ),
          // ProfileMenuListTile(
          //   text: "Payment",
          //   svgSrc: "assets/icons/card.svg",
          //   press: () {
          //     Navigator.pushNamed(context, emptyPaymentScreenRoute);
          //   },
          // ),
          // ProfileMenuListTile(
          //   text: "Wallet",
          //   svgSrc: "assets/icons/Wallet.svg",
          //   press: () {
          //     Navigator.pushNamed(context, walletScreenRoute);
          //   },
          // ),
          // const SizedBox(height: defaultPadding),
          // Padding(
          //   padding: const EdgeInsets.symmetric(
          //       horizontal: defaultPadding, vertical: defaultPadding / 2),
          //   child: Text(
          //     "Personalization",
          //     style: Theme.of(context).textTheme.titleSmall,
          //   ),
          // ),
          // DividerListTileWithTrilingText(
          //   svgSrc: "assets/icons/Notification.svg",
          //   title: "Notification",
          //   trilingText: "Off",
          //   press: () {
          //     Navigator.pushNamed(context, enableNotificationScreenRoute);
          //   },
          // ),
          // ProfileMenuListTile(
          //   text: "Preferences",
          //   svgSrc: "assets/icons/Preferences.svg",
          //   press: () {
          //     Navigator.pushNamed(context, preferencesScreenRoute);
          //   },
          // ),
          // const SizedBox(height: defaultPadding),
          // Padding(
          //   padding: const EdgeInsets.symmetric(
          //       horizontal: defaultPadding, vertical: defaultPadding / 2),
          //   child: Text(
          //     "Settings",
          //     style: Theme.of(context).textTheme.subtitle2,
          //   ),
          // ),
          // ProfileMenuListTile(
          //   text: "Language",
          //   svgSrc: "assets/icons/Language.svg",
          //   press: () {
          //     Navigator.pushNamed(context, selectLanguageScreenRoute);
          //   },
          // ),
          // ProfileMenuListTile(
          //   text: "Location",
          //   svgSrc: "assets/icons/Location.svg",
          //   press: () {},
          // ),
          // const SizedBox(height: defaultPadding),
          // ProfileMenuListTile(
          //   text: "Clear Cache (Testing Purposes)",
          //   svgSrc: "assets/icons/Location.svg",
          //   press: () {
          //     const FlutterSecureStorage().deleteAll();
          //   },
          // ),
          const SizedBox(height: defaultPadding),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding,
              vertical: defaultPadding / 2,
            ),
            child: Text(
              "Help & Support",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          ProfileMenuListTile(
            text: "Get Help",
            svgSrc: "assets/icons/Help.svg",
            press: () {
              Navigator.pushNamed(context, getHelpScreenRoute);
            },
          ),
          // ProfileMenuListTile(
          //   text: "FAQ",
          //   svgSrc: "assets/icons/FAQ.svg",
          //   press: () {},
          //   isShowDivider: false,
          // ),
          // const SizedBox(height: defaultPadding),

          // Log Out
          ListTile(
            onTap: () async {
              _openDialog(context);
            },
            minLeadingWidth: 24,
            leading: SvgPicture.asset(
              "assets/icons/Logout.svg",
              height: 24,
              width: 24,
              color: errorColor,
            ),
            title: const Text(
              "Log Out",
              style: TextStyle(color: errorColor, fontSize: 14, height: 1),
            ),
          ),
        ],
      ),
    );
  }

  void _openDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: defaultPadding),
                const Text(
                  "Comfirm",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: defaultPadding),
                const Text(
                  "Are you sure you want to log out?",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black45,
                  ),
                ),
                const SizedBox(height: defaultPadding * 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: defaultPadding),
                    Expanded(
                      child: GetX<ProfileController>(
                        builder: (controller) {
                          return ElevatedButton(
                            onPressed: () async {
                              Get.find<ProfileController>().logout();
                            },
                            child: controller.isLogoutLoading.value
                                ? const SpinKitThreeBounce(
                                    color: Colors.white,
                                    size: 20,
                                  )
                                : const Text("Log Out"),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
