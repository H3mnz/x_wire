import 'package:flutter/material.dart';

import 'colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData themeData = ThemeData(
    fontFamily: 'Rubik',
    brightness: Brightness.dark,
    colorSchemeSeed: AppColors.color1,
    scaffoldBackgroundColor: AppColors.backgroundColor,
  );
}
