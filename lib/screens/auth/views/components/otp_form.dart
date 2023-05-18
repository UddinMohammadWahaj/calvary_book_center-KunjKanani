import 'package:bookcenter/screens/auth/controllers/password_recovery_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OtpForm extends StatelessWidget {
  const OtpForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Pinput(
        controller: Get.find<PasswordRecoveryController>()
            .passwordRecoveryOtpController,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        length: 4,
        keyboardType: TextInputType.number,
        autofocus: true,
      ),
    );
  }
}
