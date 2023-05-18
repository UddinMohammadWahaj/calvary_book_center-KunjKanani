import 'dart:developer';

import 'package:bookcenter/components/skleton/others/adreess_skeleton.dart';
import 'package:bookcenter/screens/address/controllers/address_controller.dart';
import 'package:bookcenter/screens/address/models/address_model.dart';
import 'package:bookcenter/screens/address/views/components/address_card.dart';
import 'package:bookcenter/screens/checkout/controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bookcenter/constants.dart';
import 'package:bookcenter/route/screen_export.dart';
import 'package:get/get.dart';

class SelectAddressScreen extends StatelessWidget {
  SelectAddressScreen({Key? key}) : super(key: key);

  final addressController = Get.put(AddressController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Address"),
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: SizedBox(
          width: double.infinity,
          child: GetX<CartController>(
            builder: (controller) {
              return ElevatedButton(
                onPressed: controller.isFetchingDeliveryPrice.value
                    ? null
                    : () {
                        if (controller.selectedAddress.value.id == null) {
                          Get.snackbar(
                            "Error",
                            "Please select an address",
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return;
                        }

                        var data = {
                          "address":
                              Get.find<CartController>().selectedAddress.value,
                          "total": Get.find<CartController>().totalPrice.value,
                        };

                        data['tip'] = Get.find<CartController>().getTipAmount();

                        Get.offAndToNamed(
                          paymentProcessingScreenRoute,
                          arguments: data,
                        );
                        controller.selectedAddress.value = AddressModel();
                        controller.shippingCharges.value = 0;
                        controller.countTotalPrice();
                      },
                child: const Text("Make Payment"),
              );
            },
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Get.find<CartController>().shippingCharges.value = 0;
          Get.find<CartController>().selectedAddress.value = AddressModel();
          Get.find<CartController>().countTotalPrice();
          return true;
        },
        child: GetX<CartController>(
          init: CartController(),
          builder: (controller) {
            return controller.isFetchingAddresses.value
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
                                        .bodyText1!
                                        .color),
                              ),
                            ),
                            const SizedBox(height: defaultPadding / 2),
                            if (controller.selectedAddress.value.id != null)
                              ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  "Shipping charges : ${controller.shippingCharges.value} ",
                                ),
                              ),
                            const SizedBox(height: defaultPadding / 2),
                            Expanded(
                              child: ListView.builder(
                                itemCount: controller.addresses.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: defaultPadding / 2,
                                    ),
                                    child: AddressCard(
                                      addressModel: controller.addresses[index],
                                      isActive: controller
                                                  .selectedAddress.value.id ==
                                              null
                                          ? false
                                          : controller
                                                  .selectedAddress.value.id ==
                                              controller.addresses[index].id,
                                      press: () {
                                        controller.updateSelectedAddress(
                                          controller.addresses[index],
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
          },
        ),
      ),
    );
  }
}
