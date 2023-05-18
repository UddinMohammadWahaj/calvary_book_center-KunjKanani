import 'dart:developer';

import 'package:bookcenter/components/custom_drop_down_button.dart';
import 'package:bookcenter/screens/address/controllers/address_controller.dart';
import 'package:bookcenter/screens/address/models/address_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:bookcenter/constants.dart';
import 'package:get/get.dart';

class AddNewAddressScreen extends StatefulWidget {
  const AddNewAddressScreen({Key? key}) : super(key: key);

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  bool isFormDataEditing = false;
  AddressModel? addressModel;

  @override
  void initState() {
    super.initState();
    Get.put(AddressController());
    if (mounted) {
      addressModel = Get.arguments;

      if (addressModel != null) {
        AddressController addressController = Get.find();

        addressController.isFormDataLoading.listenAndPump((p0) {
          if (!p0) {
            addressController.fullNameController.text =
                addressModel!.name ?? '';
            addressController.mobileController.text =
                addressModel!.mobile ?? '';
            addressController.addressController.text =
                addressModel!.address ?? '';
            addressController.address2Controller.text =
                addressModel!.address2 ?? '';

            addressController.selectCountryById(addressModel!.country ?? 0);
            addressController.selectStateById(addressModel!.state ?? 0);
            addressController.selectCityById(addressModel!.city ?? 0);
            addressController.selectPinCodeById(addressModel!.pinCode ?? 0);

            isFormDataEditing = true;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New address"),
      ),
      bottomNavigationBar: GetX<AddressController>(
        builder: (controller) {
          return Visibility(
            visible: !controller.isFormDataLoading.value,
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: defaultPadding * 1.5,
                right: defaultPadding,
                left: defaultPadding,
              ),
              child: ElevatedButton(
                onPressed: () {
                  if (isFormDataEditing) {
                    controller.updateAddress(addressId: addressModel!.id ?? 0);
                  } else {
                    controller.addAddress();
                  }
                },
                child: controller.isSavingAddress.value
                    ? const SizedBox(
                        height: 18,
                        child: SpinKitThreeBounce(
                          color: Colors.white,
                          size: 18,
                        ),
                      )
                    : const Text("Save address"),
              ),
            ),
          );
        },
      ),
      body: GetX<AddressController>(
        builder: (controller) {
          return controller.isFormDataLoading.value
              ? const Center(
                  child: SpinKitThreeBounce(
                    color: primaryColor,
                    size: 18,
                  ),
                )
              : SafeArea(
                  child: Form(
                    key: controller.formKey,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(defaultPadding),
                      reverse: true,
                      child: Column(
                        children: [
                          // TextFormField(
                          //   onSaved: (newValue) {},
                          //   validator:
                          //       RequiredValidator(errorText: "This field is required"),
                          //   decoration: const InputDecoration(
                          //     hintText: "Type address title",
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(
                          //       vertical: defaultPadding * 1.5),
                          //   child: UseCurrentLocationCard(press: () {}),
                          // ),
                          // const SizedBox(height: defaultPadding),
                          TextFormField(
                            controller: controller.fullNameController,
                            onSaved: (newValue) {},
                            validator: RequiredValidator(
                                errorText: "This field is required"),
                            decoration: InputDecoration(
                              hintText: "Full name",
                              prefixIcon: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: defaultPadding * 0.74),
                                child: SvgPicture.asset(
                                  "assets/icons/Profile.svg",
                                  height: 24,
                                  width: 24,
                                  color: Theme.of(context)
                                      .inputDecorationTheme
                                      .hintStyle!
                                      .color,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: defaultPadding),
                          TextFormField(
                            controller: controller.mobileController,
                            keyboardType: TextInputType.phone,
                            validator: mobileValidator,
                            maxLength: 10,
                            onChanged: (value) {
                              if (value.length == 10) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                            decoration: InputDecoration(
                              hintText: "Phone number",
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.only(left: defaultPadding),
                                child: SizedBox(
                                  width: 72,
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/Call.svg",
                                        height: 24,
                                        width: 24,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .color!,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: defaultPadding / 2,
                                        ),
                                        child: Text(
                                          "+91",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 24,
                                        child: VerticalDivider(
                                          thickness: 1,
                                          width: defaultPadding / 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: defaultPadding),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: controller.addressController,
                            validator: RequiredValidator(
                              errorText: "This field is required",
                            ),
                            decoration: const InputDecoration(
                              hintText: "Address line 1",
                            ),
                          ),
                          const SizedBox(height: defaultPadding),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: controller.address2Controller,
                            decoration: const InputDecoration(
                              hintText: "Address line 2",
                            ),
                          ),
                          const SizedBox(height: defaultPadding),
                          TypeAheadFormField(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: controller.countryController,
                              decoration: const InputDecoration(
                                hintText: "Country",
                              ),
                            ),
                            validator: (val) {
                              if (controller.selectedCountryId.value == 0) {
                                return "Please select a country from the list";
                              }
                              return null;
                            },
                            suggestionsCallback: (pattern) async {
                              return controller.getCountrySuggestions(pattern);
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                title: Text(
                                  suggestion,
                                ),
                              );
                            },
                            onSuggestionSelected: (suggestion) {
                              controller.selectCountry(suggestion);
                            },
                          ),
                          const SizedBox(height: defaultPadding),
                          TypeAheadFormField(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: controller.stateController,
                              decoration: const InputDecoration(
                                hintText: "State",
                              ),
                            ),
                            suggestionsCallback: (pattern) async {
                              return controller.getStateSuggestions(pattern);
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                title: Text(
                                  suggestion,
                                ),
                              );
                            },
                            validator: (val) {
                              if (controller.selectedStateId.value == 0) {
                                return "Please select a state from the list";
                              }
                              return null;
                            },
                            onSuggestionSelected: (suggestion) {
                              controller.selectState(suggestion);
                            },
                          ),
                          const SizedBox(height: defaultPadding),
                          TypeAheadFormField(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: controller.cityController,
                              decoration: const InputDecoration(
                                hintText: "City",
                              ),
                            ),
                            suggestionsCallback: (pattern) async {
                              return controller.getCitySuggestions(pattern);
                            },
                            validator: (val) {
                              if (controller.selectedStateId.value == 0) {
                                return "Please select a city from the list";
                              }
                              return null;
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                title: Text(
                                  suggestion,
                                ),
                              );
                            },
                            onSuggestionSelected: (suggestion) {
                              controller.selectCity(suggestion);
                            },
                          ),
                          const SizedBox(height: defaultPadding),
                          TypeAheadFormField(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: controller.pinCodeController,
                              decoration: const InputDecoration(
                                hintText: "Pin Code",
                              ),
                            ),
                            suggestionsCallback: (pattern) async {
                              return controller.getPinCodeSuggestions(pattern);
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                title: Text(
                                  suggestion,
                                ),
                              );
                            },
                            validator: (val) {
                              if (controller.selectedPinCodeId.value == 0) {
                                return "Please select a pin code from the list";
                              }
                              return null;
                            },
                            onSuggestionSelected: (suggestion) {
                              controller.selectPinCode(suggestion);
                            },
                          ),

                          // TextFormField(
                          //   initialValue: "India",
                          //   enabled: false,
                          //   validator: RequiredValidator(
                          //       errorText: "This field is required"),
                          //   decoration: InputDecoration(
                          //     hintText: "Country/Region",
                          //     prefixIcon: Padding(
                          //       padding: const EdgeInsets.symmetric(
                          //           vertical: defaultPadding * 0.74),
                          //       child: SvgPicture.asset(
                          //         "assets/icons/Address.svg",
                          //         height: 24,
                          //         width: 24,
                          //         color: Theme.of(context)
                          //             .inputDecorationTheme
                          //             .hintStyle!
                          //             .color,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // ListTile(
                          //   contentPadding: EdgeInsets.zero,
                          //   title: const Text("Set default address"),
                          //   trailing: CupertinoSwitch(
                          //     onChanged: (value) {},
                          //     value: true,
                          //     activeColor: primaryColor,
                          //   ),
                          // ),
                          const SizedBox(
                            height: defaultPadding * 1.5,
                          ),

                          if (MediaQuery.of(context).viewInsets.bottom > 100)
                            const SizedBox(
                              height: defaultPadding * 10,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }

  @override
  void dispose() {
    Get.find<AddressController>().clearData();
    super.dispose();
  }
}
