import 'package:bookcenter/screens/auth/controllers/signup_auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class SignUpVerificationOtpForm extends StatelessWidget {
  const SignUpVerificationOtpForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Pinput(
        length: 4,
        controller: Get.find<SignUpAuthController>().otpController,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        autofocus: true,
      ),
    );
  }
}
