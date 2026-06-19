import 'package:flutter/material.dart';
import 'package:my_notes/shared/theme/app_card_border.dart';
import 'package:my_notes/shared/theme/app_colors.dart';
import 'package:my_notes/shared/theme/app_dimensions.dart';

const _seedColor = Colors.deepPurple;

final _lightScheme = ColorScheme.fromSeed(
  seedColor: _seedColor,
  brightness: Brightness.light,
);

final _darkScheme = ColorScheme.fromSeed(
  seedColor: _seedColor,
  brightness: Brightness.dark,
);

final lightTheme = ThemeData(
  colorScheme: _lightScheme,
  useMaterial3: true,
  extensions: [
    AppDimensions.defaults,
    AppColors.light,
    AppCardBorder.fromScheme(_lightScheme),
  ],
);

final darkTheme = ThemeData(
  colorScheme: _darkScheme,
  useMaterial3: true,
  extensions: [
    AppDimensions.defaults,
    AppColors.dark,
    AppCardBorder.fromScheme(_darkScheme),
  ],
);
