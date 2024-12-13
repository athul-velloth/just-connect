import 'package:flutter/material.dart';

import '../constants/color_constants.dart';

class JustTheme {
  final ThemeData themeData;

  JustTheme._(this.themeData);

  factory JustTheme() {
    return JustTheme._(defaultThemeData);
  }

  JustTheme copyWith({
    Color? primaryColor,
    TextTheme? textTheme,
    Size? size,
    // Add more properties to customize as needed.
  }) {
    return JustTheme._(
      themeData.copyWith(
        primaryColor: primaryColor ?? themeData.primaryColor,
        textTheme: textTheme ?? themeData.textTheme,
      ),
    );
  }

  static final ThemeData defaultThemeData = ThemeData(
    // Define your default theme values here.
    primaryColor: ColorConstant.primaryColor,
    appBarTheme: AppBarTheme(
      backgroundColor: ColorConstant.primaryColor,
    ),
    fontFamily: "Poppins",
    package: "common",
    textTheme: const TextTheme(
      displayMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    disabledColor: ColorConstant.tfDisabledColor,
    // focusColor:
    // Add more default theme properties here.
  );
}
