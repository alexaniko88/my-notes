import 'package:flutter/material.dart';
import 'package:my_notes/gen/app_localizations.dart';
import 'package:my_notes/shared/theme/app_dimensions.dart';

extension BuildContextExtensions on BuildContext {
  // ! safe: AppDimensions is always registered in both lightTheme and darkTheme
  AppDimensions get dimensions => Theme.of(this).extension<AppDimensions>()!;
  // ! safe: AppLocalizations delegate is always registered in MaterialApp
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
