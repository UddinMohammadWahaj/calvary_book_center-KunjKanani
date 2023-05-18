import 'package:flutter/material.dart';
import 'package:bookcenter/theme/input_decoration_theme.dart';

import '../constants.dart';
import 'button_theme.dart';
import 'checkbox_themedata.dart';
import 'theme_data.dart';

ThemeData darkTheme(BuildContext context) {
  return ThemeData(
    brightness: Brightness.dark,
    fontFamily: "Plus Jakarta",
    primarySwatch: primaryMaterialColor,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: blackColor,
    iconTheme: const IconThemeData(color: Colors.white),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: blackColor60),
    ),
    elevatedButtonTheme: elevatedButtonThemeData,
    outlinedButtonTheme: outlinedButtonTheme(borderColor: whileColor20),
    textButtonTheme: textButtonThemeData,
    inputDecorationTheme: darkInputDecorationTheme,
    checkboxTheme: checkboxThemeData,
    appBarTheme: appBarDarkTheme,
    scrollbarTheme: scrollbarThemeData,
    dataTableTheme: dataTableDarkThemeData,
  );
}
