import 'package:bookcenter/route/screen_export.dart';
import 'package:bookcenter/screens/auth/controllers/signup_auth_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:bookcenter/screens/auth/views/components/sign_up_form.dart';
import 'package:bookcenter/route/route_constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../../constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                "assets/satish_kumar.png",
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
              ),
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Let’s get started!",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    // const SizedBox(height: defaultPadding / 2),
                    // const Text(
                    //   "Please enter your valid data in order to create an account.",
                    // ),
                    const SizedBox(height: defaultPadding),
                    const SignUpForm(),
                    const SizedBox(height: defaultPadding),
                    Row(
                      children: [
                        GetX<SignUpAuthController>(builder: (controller) {
                          return Checkbox(
                            onChanged: (value) {
                              controller.termsAndConditionChecked.value =
                                  value ?? false;
                            },
                            value: controller.termsAndConditionChecked.value,
                          );
                        }),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              text: "I agree with the",
                              children: [
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushNamed(
                                          context, termsOfServicesScreenRoute);
                                    },
                                  text: " Terms of service ",
                                  style: const TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const TextSpan(
                                  text: "& privacy policy.",
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    GetX<SignUpAuthController>(
                      builder: (controller) {
                        return controller.hasTermsAndConditionError.value
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: defaultPadding),
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.error,
                                      color: Colors.red,
                                      size: 18,
                                    ),
                                    SizedBox(width: defaultPadding / 2),
                                    Expanded(
                                      child: Text(
                                        "Please Agree with our terms and conditions to continue",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox();
                      },
                    ),
                    const SizedBox(height: defaultPadding * 2),
                    GetX<SignUpAuthController>(
                      init: SignUpAuthController(),
                      builder: (controller) {
                        return ElevatedButton(
                          onPressed: () {
                            // Validate Form
                            // if (_formKey.currentState!.validate()) {}
                            // Navigator.pushNamed(context, profileSetupScreenRoute);
                            controller.validateAndProceed();
                          },
                          child: controller.isOtpInProgress.value
                              ? const SpinKitThreeBounce(
                                  color: Colors.white,
                                  size: 18,
                                )
                              : const Text("Continue"),
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Do you have an account?"),
                        TextButton(
                          onPressed: () {
                            Get.offAllNamed(logInScreenRoute);
                          },
                          child: const Text("Log in"),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
