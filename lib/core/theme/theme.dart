import 'package:flutter/material.dart';

import '../constant/color.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: white,
    primaryContainer : black,
    primary: sevenBackColor,
    secondary: fourBackColor,
    tertiary: secondBackColor,
    tertiaryContainer: sixBackColor,
    //tertiaryFixed: green,
    //tertiaryFixedDim: Colors.grey[200],
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Colors.grey.shade900,
    primaryContainer : white,
    primary: Colors.grey.shade500,
    secondary: Colors.grey.shade600,
    tertiary: Colors.grey.shade200,
    tertiaryContainer: Colors.grey.shade300,
    //tertiaryFixed: Colors.grey.shade700,
    //tertiaryFixedDim: Colors.grey[600],

  ),
);

