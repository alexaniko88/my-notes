import 'package:flutter/material.dart';
import 'package:my_notes/shared/theme/app_colors.dart';
import 'package:my_notes/shared/theme/app_dimensions.dart';

const _seedColor = Colors.deepPurple;

final lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: _seedColor,
    brightness: Brightness.light,
  ),
  useMaterial3: true,
  extensions: const [AppDimensions.defaults, AppColors.light],
);

final darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: _seedColor,
    brightness: Brightness.dark,
  ),
  useMaterial3: true,
  extensions: const [AppDimensions.defaults, AppColors.dark],
);
