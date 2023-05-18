import 'package:bookcenter/screens/auth/controllers/password_recovery_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bookcenter/constants.dart';
import 'package:bookcenter/route/route_constants.dart';
import 'package:get/get.dart';

class PasswordRecoveryScreen extends StatelessWidget {
  const PasswordRecoveryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PasswordRecoveryController passwordRecoveryController =
        Get.put(PasswordRecoveryController());
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: defaultPadding),
              Text(
                "Password recovery",
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: defaultPadding / 2),
              const Text("Enter your E-mail address to recover your password"),
              const SizedBox(height: defaultPadding * 2),
              Form(
                key: passwordRecoveryController.formKeyForPasswordRecovery,
                child: TextFormField(
                  autofocus: true,
                  controller: passwordRecoveryController.emailController,
                  onChanged: (value) {
                    // if (value.length == 10) {
                    //   FocusScope.of(context).unfocus();
                    // }
                  },
                  validator: emaildValidator,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Email address",
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
              ),
              const Spacer(),
              GetX<PasswordRecoveryController>(
                builder: (controller) {
                  return ElevatedButton(
                    onPressed: () {
                      passwordRecoveryController.sendOTPIfRegister();
                    },
                    child: controller.isLoading.value
                        ? const SpinKitThreeBounce(
                            color: Colors.white,
                            size: 18,
                          )
                        : const Text("Next"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
