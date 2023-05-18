import 'package:bookcenter/screens/auth/controllers/password_recovery_controller.dart';
import 'package:flutter/material.dart';
import 'package:bookcenter/constants.dart';
import 'package:bookcenter/route/screen_export.dart';
import 'package:get/get.dart';

import 'components/new_pass_form.dart';

class SetNewPasswordScreen extends StatelessWidget {
  const SetNewPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Set new password",
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: defaultPadding / 2),
              const Text(
                  "Your new password must be diffrent from previosly used passwords."),
              const SizedBox(
                height: defaultPadding * 2,
              ),
              const NewPassForm(),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Get.find<PasswordRecoveryController>().changePassword();
                },
                child: const Text("Change Password"),
              ),
              const SizedBox(height: defaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}
