import 'package:bookcenter/screens/user_info/controllers/user_info_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

import '../../../../constants.dart';

class UserInfoForm extends StatelessWidget {
  const UserInfoForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserInfoController userInfoController = Get.find<UserInfoController>();
    return Form(
      key: userInfoController.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: Column(
          children: [
            TextFormField(
              controller: userInfoController.nameController,
              textInputAction: TextInputAction.next,
              validator: RequiredValidator(errorText: "Name is required"),
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: defaultPadding * 0.75),
                  child: SvgPicture.asset(
                    "assets/icons/Profile.svg",
                    color: Theme.of(context).iconTheme.color,
                    height: 24,
                    width: 24,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: TextFormField(
                controller: userInfoController.emailController,
                validator: MultiValidator(
                  [
                    RequiredValidator(errorText: "Email is required"),
                    EmailValidator(errorText: "Enter a valid email address"),
                  ],
                ),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: defaultPadding * 0.75),
                    child: SvgPicture.asset(
                      "assets/icons/Message.svg",
                      color: Theme.of(context).iconTheme.color,
                      height: 24,
                      width: 24,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: TextFormField(
                enabled: false,
                controller: userInfoController.mobileController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: defaultPadding),
                    child: SizedBox(
                      width: 72,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/Call.svg",
                            height: 24,
                            width: 24,
                            color:
                                Theme.of(context).textTheme.bodyText1!.color!,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: defaultPadding / 2),
                            child: Text("+91",
                                style: Theme.of(context).textTheme.bodyText1),
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
            ),
          ],
        ),
      ),
    );
  }
}
