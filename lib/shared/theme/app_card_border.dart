import 'package:flutter/material.dart';
import 'package:my_notes/shared/theme/app_dimensions.dart';

/// Card border shapes, by selection state. Holds the full [RoundedRectangleBorder]
/// for each state so radius, width, and color all live in the theme and widgets
/// only pick a shape — they never assemble one.
@immutable
class AppCardBorder extends ThemeExtension<AppCardBorder> {
  static const _thinWidth = 1.0;
  static const _thickWidth = 2.5;

  final RoundedRectangleBorder standard;
  final RoundedRectangleBorder selected;

  const AppCardBorder({required this.standard, required this.selected});

  factory AppCardBorder.fromScheme(ColorScheme scheme) {
    final radius = BorderRadius.circular(
      AppDimensions.defaults.borderRadius.md,
    );
    return AppCardBorder(
      standard: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: scheme.outlineVariant, width: _thinWidth),
      ),
      selected: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: scheme.primary, width: _thickWidth),
      ),
    );
  }

  @override
  AppCardBorder copyWith({
    RoundedRectangleBorder? standard,
    RoundedRectangleBorder? selected,
  }) {
    return AppCardBorder(
      standard: standard ?? this.standard,
      selected: selected ?? this.selected,
    );
  }

  @override
  AppCardBorder lerp(ThemeExtension<AppCardBorder>? other, double t) {
    if (other is! AppCardBorder) {
      return this;
    }
    final lerpedStandard = ShapeBorder.lerp(standard, other.standard, t);
    final lerpedSelected = ShapeBorder.lerp(selected, other.selected, t);
    return AppCardBorder(
      standard:
          lerpedStandard is RoundedRectangleBorder ? lerpedStandard : standard,
      selected:
          lerpedSelected is RoundedRectangleBorder ? lerpedSelected : selected,
    );
  }
}
