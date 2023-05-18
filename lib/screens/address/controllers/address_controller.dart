import 'dart:developer';

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/address/models/address_model.dart';
import 'package:bookcenter/screens/address/models/country_state_model.dart';
import 'package:bookcenter/screens/address/repositories/address_repository.dart';
import 'package:bookcenter/service/address_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressController extends GetxController {
  var isAddressLoading = false.obs,
      isFormDataLoading = false.obs,
      isSavingAddress = false.obs;

  RxList<AddressModel> addresses = <AddressModel>[].obs;
  late CountryStateModel countryStateModel;

  var selectedCountryIndex = 0.obs,
      selectedStateIndex = 0.obs,
      selectedCityIndex = 0.obs,
      selectedPinCodeIndex = 0.obs;

  var selectedCountryId = 0.obs,
      selectedStateId = 0.obs,
      selectedCityId = 0.obs,
      selectedPinCodeId = 0.obs;

  var selectedCountryName = "".obs,
      selectedStateName = "".obs,
      selectedCityName = "".obs,
      selectedPinCodeName = "".obs;

  var countryController = TextEditingController(),
      stateController = TextEditingController(),
      cityController = TextEditingController(),
      pinCodeController = TextEditingController();

  TextEditingController fullNameController = TextEditingController(),
      mobileController = TextEditingController(),
      addressController = TextEditingController(),
      address2Controller = TextEditingController();

  final formKey = GlobalKey<FormState>();
  AddressService addressService = Get.find<AddressService>();

  @override
  void onInit() {
    super.onInit();
    initAddresses();
  }

  Future initAddresses({bool fetchWithoutLoading = false}) async {
    addressService.addresses.listenAndPump((addressesList) {
      // log(addressesList.length.toString());
      addresses.value = addressesList;
    });

    addressService.isFetchingAddresses.listenAndPump((isFetching) {
      isAddressLoading.value = isFetching;
    });

    addressService.isFormDataLoading.listenAndPump((isFetching) {
      isFormDataLoading.value = isFetching;
    });

    addressService.countryStateModel.listenAndPump((countryState) {
      countryStateModel = countryState;
    });
  }

  void selectCountry(val) {
    countryController.text = val;

    selectedCountryId.value = countryStateModel.countries
        .firstWhere((element) => element.country == val)
        .id;

    selectedCountryIndex.value = countryStateModel.countries
        .indexWhere((element) => element.country == val);
    selectedCountryName.value = val;

    selectedStateName.value = "";
    selectedCityName.value = "";
    selectedPinCodeName.value = "";

    selectedStateId.value = 0;
    selectedCityId.value = 0;
    selectedPinCodeId.value = 0;
  }

  void selectState(val) {
    stateController.text = val;

    selectedStateId.value = countryStateModel
        .countries[selectedCountryIndex.value].states
        .firstWhere((element) => element.state == val)
        .id;
    selectedStateIndex.value = countryStateModel
        .countries[selectedCountryIndex.value].states
        .indexWhere((element) => element.state == val);
    selectedStateName.value = val;

    selectedCityName.value = "";
    selectedPinCodeName.value = "";

    selectedCityId.value = 0;
    selectedPinCodeId.value = 0;
  }

  void selectCity(val) {
    cityController.text = val;

    selectedCityId.value = countryStateModel
        .countries[selectedCountryIndex.value]
        .states[selectedStateIndex.value]
        .cities
        .firstWhere((element) => element.city == val)
        .id;
    selectedCityIndex.value = countryStateModel
        .countries[selectedCountryIndex.value]
        .states[selectedStateIndex.value]
        .cities
        .indexWhere((element) => element.city == val);
    selectedCityName.value = val;

    selectedPinCodeName.value = "";

    selectedPinCodeId.value = 0;
  }

  void selectPinCode(val) {
    pinCodeController.text = val;

    selectedPinCodeId.value = countryStateModel
        .countries[selectedCountryIndex.value]
        .states[selectedStateIndex.value]
        .cities[selectedCityIndex.value]
        .pinCodes
        .firstWhere((element) => element.name == val)
        .id;
    selectedPinCodeIndex.value = countryStateModel
        .countries[selectedCountryIndex.value]
        .states[selectedStateIndex.value]
        .cities[selectedCityIndex.value]
        .pinCodes
        .indexWhere((element) => element.name == val);
    selectedPinCodeName.value = val;
  }

  Future addAddress() async {
    if (isSavingAddress.value) {
      return;
    }

    if (formKey.currentState!.validate()) {
      isSavingAddress.value = true;
      ApiResponse apiResponse = await AddressRepository.instance.addAddress(
        name: fullNameController.text,
        mobile: mobileController.text,
        address: addressController.text,
        address2: address2Controller.text,
        countryId: selectedCountryId.value,
        stateId: selectedStateId.value,
        cityId: selectedCityId.value,
        pinCodeId: selectedPinCodeId.value,
      );

      if (apiResponse.message == ApiMessage.success) {
        Get.back();
        addressService.fetchAddresses();

        clearData();
      }

      isSavingAddress.value = false;
    }
  }

  void deleteAddress(int id) async {
    ApiResponse apiResponse =
        await AddressRepository.instance.deleteAddress(id);
    // log(apiResponse.message.toString());

    if (apiResponse.message == ApiMessage.success) {
      addressService.fetchAddresses();
    } else {
      // log(apiResponse.data.toString());
      // Get.snackbar("Error", apiResponse.data.toString());
    }
  }

  void selectCountryById(int country) {
    if (country == 0) {
      return;
    }

    selectedCountryId.value = country;
    selectedCountryIndex.value = countryStateModel.countries
        .indexWhere((element) => element.id == country);
    selectedCountryName.value =
        countryStateModel.countries[selectedCountryIndex.value].country;

    countryController.text = selectedCountryName.value;
  }

  void selectStateById(int state) {
    if (state == 0) {
      return;
    }
    selectedStateId.value = state;
    selectedStateIndex.value = countryStateModel
        .countries[selectedCountryIndex.value].states
        .indexWhere((element) => element.id == state);
    selectedStateName.value = countryStateModel
        .countries[selectedCountryIndex.value]
        .states[selectedStateIndex.value]
        .state;

    stateController.text = selectedStateName.value;
  }

  void selectCityById(int city) {
    if (city == 0) {
      return;
    }
    selectedCityId.value = city;
    selectedCityIndex.value = countryStateModel
        .countries[selectedCountryIndex.value]
        .states[selectedStateIndex.value]
        .cities
        .indexWhere((element) => element.id == city);
    selectedCityName.value = countryStateModel
        .countries[selectedCountryIndex.value]
        .states[selectedStateIndex.value]
        .cities[selectedCityIndex.value]
        .city;

    cityController.text = selectedCityName.value;
  }

  void selectPinCodeById(int pinCode) {
    if (pinCode == 0) {
      return;
    }
    selectedPinCodeId.value = pinCode;
    selectedPinCodeIndex.value = countryStateModel
        .countries[selectedCountryIndex.value]
        .states[selectedStateIndex.value]
        .cities[selectedCityIndex.value]
        .pinCodes
        .indexWhere((element) => element.id == pinCode);
    selectedPinCodeName.value = countryStateModel
        .countries[selectedCountryIndex.value]
        .states[selectedStateIndex.value]
        .cities[selectedCityIndex.value]
        .pinCodes[selectedPinCodeIndex.value]
        .name;

    pinCodeController.text = selectedPinCodeName.value;
  }

  Future updateAddress({required int addressId}) async {
    if (isSavingAddress.value) {
      return;
    }
    if (formKey.currentState!.validate()) {
      isSavingAddress.value = true;
      ApiResponse apiResponse = await AddressRepository.instance.updateAddress(
        addressId: addressId,
        name: fullNameController.text,
        mobile: mobileController.text,
        address: addressController.text,
        address2: address2Controller.text,
        countryId: selectedCountryId.value,
        stateId: selectedStateId.value,
        cityId: selectedCityId.value,
        pinCodeId: selectedPinCodeId.value,
      );
      // log(apiResponse.message.toString());

      if (apiResponse.message == ApiMessage.success) {
        Get.back(result: {"isUpdated": true});
        addressService.fetchAddresses();
        clearData();
      }

      isSavingAddress.value = false;
    }
  }

  void clearData() {
    fullNameController.clear();
    mobileController.clear();
    addressController.clear();
    address2Controller.clear();
    countryController.clear();
    stateController.clear();
    cityController.clear();
    pinCodeController.clear();
    selectedCountryId.value = 0;
    selectedStateId.value = 0;
    selectedCityId.value = 0;
    selectedPinCodeId.value = 0;
    selectedCountryIndex.value = 0;
    selectedStateIndex.value = 0;
    selectedCityIndex.value = 0;
    selectedPinCodeIndex.value = 0;
    selectedCountryName.value = "";
    selectedStateName.value = "";
    selectedCityName.value = "";
    selectedPinCodeName.value = "";
  }

  List<String> getCountrySuggestions(String pattern) {
    List<String> suggestions = [];
    for (var element in countryStateModel.countries) {
      if (element.country.toLowerCase().contains(pattern.toLowerCase())) {
        suggestions.add(element.country);
      }
    }
    return suggestions;
  }

  List<String> getStateSuggestions(String pattern) {
    List<String> suggestions = [];
    for (var element
        in countryStateModel.countries[selectedCountryIndex.value].states) {
      if (element.state.toLowerCase().contains(pattern.toLowerCase())) {
        suggestions.add(element.state);
      }
    }
    return suggestions;
  }

  List<String> getCitySuggestions(String pattern) {
    List<String> suggestions = [];
    for (var element in countryStateModel.countries[selectedCountryIndex.value]
        .states[selectedStateIndex.value].cities) {
      if (element.city.toLowerCase().contains(pattern.toLowerCase())) {
        suggestions.add(element.city);
      }
    }
    return suggestions;
  }

  List<String> getPinCodeSuggestions(String pattern) {
    List<String> suggestions = [];
    for (var element in countryStateModel
        .countries[selectedCountryIndex.value]
        .states[selectedStateIndex.value]
        .cities[selectedCityIndex.value]
        .pinCodes) {
      if (element.name.toLowerCase().contains(pattern.toLowerCase())) {
        suggestions.add(element.name);
      }
    }
    return suggestions;
  }
}
