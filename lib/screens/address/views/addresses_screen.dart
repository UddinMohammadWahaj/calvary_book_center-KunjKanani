import 'package:bookcenter/components/skleton/others/adreess_skeleton.dart';
import 'package:bookcenter/screens/address/controllers/address_controller.dart';
import 'package:bookcenter/screens/checkout/views/empty_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bookcenter/constants.dart';
import 'package:bookcenter/route/screen_export.dart';
import 'package:get/get.dart';

import 'components/address_card.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Addresses"),
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: SvgPicture.asset(
        //       "assets/icons/DotsV.svg",
        //       color: Theme.of(context).iconTheme.color,
        //     ),
        //   ),
        // ],
      ),
      body: GetX<AddressController>(
        init: AddressController(),
        builder: (controller) {
          return controller.isAddressLoading.value
              ? const AddressSkeleton()
              : controller.addresses.isEmpty
                  ? const NoAddressScreen()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding,
                        vertical: defaultPadding,
                      ),
                      child: Column(
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {
                              Get.toNamed(addNewAddressesScreenRoute);
                            },
                            icon: SvgPicture.asset(
                              "assets/icons/Location.svg",
                              color: Theme.of(context).iconTheme.color,
                            ),
                            label: Text(
                              "Add new address",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                              ),
                            ),
                          ),
                          const SizedBox(height: defaultPadding / 2),
                          controller.addresses.isEmpty
                              ? const EmptyScreen(
                                  title: 'No Address Found',
                                )
                              : Expanded(
                                  child: ListView.builder(
                                    itemCount: controller.addresses.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: defaultPadding / 2,
                                        ),
                                        child: controller
                                                    .addresses[index].country !=
                                                null
                                            ? AddressCard(
                                                addressModel:
                                                    controller.addresses[index],
                                                isActive: index == 0,
                                                press: () {},
                                              )
                                            : Container(),
                                      );
                                    },
                                  ),
                                ),
                        ],
                      ),
                    );
        },
      ),
    );
  }
}
