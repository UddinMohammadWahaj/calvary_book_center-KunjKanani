import 'dart:developer';

import 'package:bookcenter/route/route_constants.dart';
import 'package:bookcenter/screens/address/controllers/address_controller.dart';
import 'package:bookcenter/screens/address/models/address_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../constants.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({
    Key? key,
    // required this.id,
    // required this.title,
    // required this.address,
    // required this.pnNumber,
    this.isActive = false,
    required this.press,
    required this.addressModel,
  }) : super(key: key);

  // final int id;
  // final String title, address, pnNumber;
  final bool isActive;
  final VoidCallback press;

  final AddressModel addressModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      borderRadius: const BorderRadius.all(
        Radius.circular(defaultPadding),
      ),
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          border: Border.all(
              color: isActive ? primaryColor : Theme.of(context).dividerColor),
          borderRadius: const BorderRadius.all(
            Radius.circular(defaultPadding),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: isActive
                      ? primaryColor
                      : Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .color!
                          .withOpacity(0.1),
                  child: SvgPicture.asset(
                    "assets/icons/Location.svg",
                    height: 20,
                    color: isActive ? Colors.white : null,
                  ),
                ),
                const SizedBox(width: defaultPadding),
                Text(
                  addressModel.name ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: isActive ? primaryColor : null),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Get.toNamed(
                      addNewAddressesScreenRoute,
                      arguments: addressModel,
                    );
                  },
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: Colors.blue,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Get.find<AddressController>()
                        .deleteAddress(addressModel.id ?? 0);
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Text(
              "${addressModel.address!}, ${addressModel.address2}",
            ),
            const SizedBox(height: defaultPadding / 2),
            Text(
              _getPlace(addressModel),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: defaultPadding / 2),
            Text(
              addressModel.mobile ?? "",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }

  String _getPlace(AddressModel addressModel) {
    var addressController = Get.find<AddressController>();

    if (addressModel.country == null ||
        addressModel.state == null ||
        addressModel.city == null) {
      return "";
    }

    return '${addressController.countryStateModel.countries.firstWhere(
          (element) => element.id == addressModel.country,
        ).states.firstWhere(
          (element) => element.id == addressModel.state,
        ).cities.firstWhere(
          (element) => element.id == addressModel.city,
        ).city}, ${addressController.countryStateModel.countries.firstWhere(
          (element) => element.id == addressModel.country,
        ).states.firstWhere(
          (element) => element.id == addressModel.state,
        ).state}, ${addressController.countryStateModel.countries.where(
          (element) => element.id == addressModel.country,
        ).first.country}';
  }
}
