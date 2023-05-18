import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bookcenter/constants.dart';
import 'package:bookcenter/route/screen_export.dart';
import 'package:get/get.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Text(
              "Orders history",
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
          OrderHistoryListTile(
            svgSrc: "assets/icons/Product.svg",
            title: "Processing",
            // numOfItem: 1,
            press: () {
              Get.toNamed(
                orderListScreenRoute,
                arguments: {
                  'payment': true,
                  'delivered': false,
                },
              );
            },
          ),
          OrderHistoryListTile(
            svgSrc: "assets/icons/Delivery.svg",
            title: "Delivered",
            // numOfItem: 5,
            press: () {
              Get.toNamed(
                orderListScreenRoute,
                arguments: {
                  'payment': true,
                  'delivered': true,
                },
              );
            },
          ),
          OrderHistoryListTile(
            svgSrc: "assets/icons/Close-Circle.svg",
            title: "Failed",
            // numOfItem: 2,
            counterColor: errorColor,
            press: () {
              Get.toNamed(
                orderListScreenRoute,
                arguments: {
                  'payment': false,
                  'delivered': false,
                },
              );
            },
            isShowDivider: false,
          ),
        ],
      ),
    );
  }
}

class OrderHistoryListTile extends StatelessWidget {
  const OrderHistoryListTile({
    Key? key,
    required this.svgSrc,
    required this.title,
    this.counterColor = primaryColor,
    this.numOfItem,
    required this.press,
    this.isShowDivider = true,
  }) : super(key: key);

  final String svgSrc, title;
  final Color counterColor;
  final int? numOfItem;
  final VoidCallback press;
  final bool isShowDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: press,
          minLeadingWidth: 24,
          leading: SvgPicture.asset(
            svgSrc,
            height: 24,
            width: 24,
            color: Theme.of(context).iconTheme.color,
          ),
          title: Text(title),
          trailing: SizedBox(
            width: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (numOfItem != null)
                  Container(
                    height: 20,
                    width: 28,
                    decoration: BoxDecoration(
                      color: counterColor,
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Center(
                      child: Text(
                        numOfItem.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 12,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                SvgPicture.asset(
                  "assets/icons/miniRight.svg",
                  color: Theme.of(context).iconTheme.color!.withOpacity(0.4),
                ),
              ],
            ),
          ),
        ),
        if (isShowDivider) const Divider(),
      ],
    );
  }
}
