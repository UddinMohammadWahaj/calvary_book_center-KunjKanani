import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bookcenter/constants.dart';
import 'package:bookcenter/route/route_constants.dart';
import 'package:bookcenter/theme/input_decoration_theme.dart';

import 'components/language_card.dart';

class PreferredLanguageScreen extends StatelessWidget {
  const PreferredLanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text(
                "Select your preferred lanaguage",
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: defaultPadding / 2),
              const Text("You will use the same language throughout the app."),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                child: Form(
                  child: TextFormField(
                    onSaved: (language) {},
                    validator: (value) {}, // validate your textfield
                    decoration: InputDecoration(
                      hintText: "Search your language",
                      filled: false,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(defaultPadding / 2),
                        child: SvgPicture.asset(
                          "assets/icons/Search.svg",
                          height: 24,
                          width: 24,
                          color: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .color!
                              .withOpacity(0.25),
                        ),
                      ),
                      border: secodaryOutlineInputBorder(context),
                      enabledBorder: secodaryOutlineInputBorder(context),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: ListView.separated(
                  itemCount: 5,
                  itemBuilder: (context, index) => LanguageCard(
                    language: demoLanguage[index],
                    flag: demoFlags[index],
                    isActive: index == 0,
                    press: () {},
                  ),
                  separatorBuilder: (context, index) => const SizedBox(
                    height: defaultPadding / 2,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, logInScreenRoute);
                },
                child: const Text("Next"),
              ),
              const SizedBox(height: defaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}

// Only for preview
const List<String> demoFlags = [
  "assets/flags/England.svg",
  "assets/flags/france.svg",
  "assets/flags/German.svg",
  "assets/flags/India.svg",
  "assets/flags/Italy.svg",
  "assets/flags/japaness.svg",
];
const List<String> demoLanguage = [
  "English",
  "France",
  "German",
  "India",
  "Italy",
  "Japaness"
];
