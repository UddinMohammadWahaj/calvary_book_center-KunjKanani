import 'dart:developer';
import 'package:bookcenter/constants.dart';
import 'package:bookcenter/service/api_services/api_service.dart';
import 'package:get/get.dart';

Future<ApiResponse> sendOTP({
  required String mobileNo,
  required String otp,
}) async {
  try {
    ApiService apiService = Get.find<ApiService>();

    final response = await apiService.get(
      'https://txt.cleverstack.in/api/v2.0/sms_campaign.php?token=739150414612db69e7a8184.11466822&user_id=25472816&route=TR&template_id=5848&sender_id=CALVRY&language=EN&template=%3C%23%3E+Your+Calvary+account+is+being+registered+on+a+new+device.+Do+not+share+this+code+with+anyone.Your+Calvary+code%3A+$otp+Calvary+Book+Centre+$otp&contact_numbers=$mobileNo',
      customBaseURL: true,
    );

    if (response.statusCode == 200) {
      return ApiResponse(
        message: ApiMessage.success,
      );
    }
  } catch (error) {
    // log(error.toString());
    return ApiResponse(
      message: ApiMessage.apiError,
      data: 'OTP sending failed',
    );
  }

  return ApiResponse(
    message: ApiMessage.somethingWantWrongError,
  );
}
