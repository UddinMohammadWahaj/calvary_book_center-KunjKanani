import 'dart:developer';

import 'package:bookcenter/screens/auth/controllers/login_auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../constants.dart';

class LogInForm extends StatelessWidget {
  const LogInForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginAuthController loginAuthController =
        Get.put(LoginAuthController());
    return Form(
      key: loginAuthController.formKey,
      child: Column(
        children: [
          TextFormField(
            onSaved: (mno) {
              // Mobile Number
            },
            onChanged: (value) {
              if (value.length == 10) {
                FocusScope.of(context).nextFocus();
              }
            },
            controller: loginAuthController.mobileConrtoller,
            validator: mobileValidator,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: "Mobile Number",
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: defaultPadding * 0.75,
                ),
                child: SvgPicture.asset(
                  "assets/icons/Message.svg",
                  height: 24,
                  width: 24,
                  color: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .color!
                      .withOpacity(0.3),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Obx(() {
            return TextFormField(
              onSaved: (pass) {
                // Password
              },
              controller: loginAuthController.passwordController,
              validator: passwordValidator,
              obscureText: !loginAuthController.isPasswordVisible.value,
              decoration: InputDecoration(
                suffixIcon: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding * 0.75,
                  ),
                  child: IconButton(
                    icon: Icon(
                      loginAuthController.isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      loginAuthController.isPasswordVisible.value =
                          !loginAuthController.isPasswordVisible.value;
                    },
                  ),
                ),
                hintText: "Password",
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: defaultPadding * 0.75),
                  child: SvgPicture.asset(
                    "assets/icons/Lock.svg",
                    height: 24,
                    width: 24,
                    color: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .color!
                        .withOpacity(0.3),
                  ),
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
