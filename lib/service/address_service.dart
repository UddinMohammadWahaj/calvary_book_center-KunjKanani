import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/address/models/address_model.dart';
import 'package:bookcenter/screens/address/models/country_state_model.dart';
import 'package:get/get.dart';

import '../screens/address/repositories/address_repository.dart';

class AddressService extends GetxService {
  RxList<AddressModel> addresses = <AddressModel>[].obs;
  var isFetchingAddresses = false.obs, isFormDataLoading = false.obs;
  late var countryStateModel = CountryStateModel().obs;

  @override
  void onInit() {
    fetchAddresses();
    fetchCountryState();
    super.onInit();
  }

  fetchAddresses() async {
    isFetchingAddresses.value = true;
    ApiResponse apiResponse = await AddressRepository.instance.fetchAddresses();

    if (apiResponse.message == ApiMessage.success) {
      addresses.value = apiResponse.data;
      addresses.refresh();
    }

    isFetchingAddresses.value = false;
  }

  fetchCountryState() async {
    isFormDataLoading.value = true;

    ApiResponse apiResponse = await AddressRepository.instance.fetchFormData();

    if (apiResponse.message == ApiMessage.success) {
      countryStateModel.value = apiResponse.data;
    }

    isFormDataLoading.value = false;
  }
}
