import 'package:flutter/material.dart';

const _colorPurple = Color(0xFF7957D8);
const _colorRed = Color(0xFFCC3361);
const _colorGreen = Color(0xFF1DDDA3);
const _colorBlue = Color(0xFF169CE9);
const _colorWhite = Color(0xFFFFFFFF);
const _colorOrange = Color(0xFFF67944);
const _colorGrey = Color(0xFF2B343A);
const _colorPink = Color(0xFFF7EAFF);
const _colorBlack = Color(0xFF2A2B2D);

const _titleFontSize = 30.0;
const _normalFontSize = 12.0;
const _buttonFontSize = 18.0;

class CustomColorsInterface {
  final Color? purple;
  final Color? red;
  final Color? green;
  final Color? blue;
  final Color? white;
  final Color? orange;
  final Color? grey;
  final Color? pink;
  final Color? black;

  const CustomColorsInterface({
    this.purple,
    this.red,
    this.green,
    this.blue,
    this.white,
    this.orange,
    this.grey,
    this.pink,
    this.black,
  });
}

class CustomButtonTheme {
  final TextStyle? textStyle;

  const CustomButtonTheme({
    this.textStyle,
  });
}

class CustomFontSizeTheme {
  final double? title;
  final double? normal;

  const CustomFontSizeTheme({
    this.title,
    this.normal,
  });
}

@immutable
class CustomColors extends ThemeExtension<CustomColors> {

  const CustomColors({
    required this.interfaceColors,
    required this.buttonTheme,
    required this.fontSize,
    required this.backgroundCurveHeight,
  });

  final CustomColorsInterface interfaceColors;
  final CustomButtonTheme buttonTheme;
  final CustomFontSizeTheme fontSize;
  final double backgroundCurveHeight;

  @override
  CustomColors copyWith({
    Color? backgroundTop,
  }) {
    return light;
  }

  // Controls how the properties change on theme changes
  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }

    return light;
  }

  // Controls how it displays when the instance is being passed to the `print()` method.
  @override
  String toString() => 'CustomColors(...)';

  // the light theme
  static const light = CustomColors(
    interfaceColors: CustomColorsInterface(
      purple: _colorPurple,
      red: _colorRed,
      green: _colorGreen,
      blue: _colorBlue,
      white: _colorWhite,
      orange: _colorOrange,
      grey: _colorGrey,
      pink: _colorPink,
      black: _colorBlack,
    ),
    buttonTheme: CustomButtonTheme(
        textStyle: TextStyle(
          color: _colorWhite,
          fontSize: _buttonFontSize,
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w600,
          letterSpacing: 1.3
        )
    ),
    fontSize: CustomFontSizeTheme(
      title: _titleFontSize,
      normal: _normalFontSize,
    ),
    backgroundCurveHeight: 50.0,
  );
}