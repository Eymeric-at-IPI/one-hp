import 'package:flutter/material.dart';
import 'custom_color_scheme.dart';

ThemeData appTheme() {
  return ThemeData(
    fontFamily: 'Gilroy',
    extensions: const <ThemeExtension<dynamic>>[
      CustomColors.light,
    ],
  );
}