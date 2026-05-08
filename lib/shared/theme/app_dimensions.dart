import 'package:flutter/material.dart';

class AppDimensions extends ThemeExtension<AppDimensions> {
  const AppDimensions({
    this.spacing = const AppSpacing(),
    this.iconSize = const AppIconSize(),
    this.imageSize = const AppImageSize(),
  });

  final AppSpacing spacing;
  final AppIconSize iconSize;
  final AppImageSize imageSize;

  static const defaults = AppDimensions();

  @override
  AppDimensions copyWith({
    AppSpacing? spacing,
    AppIconSize? iconSize,
    AppImageSize? imageSize,
  }) =>
      AppDimensions(
        spacing: spacing ?? this.spacing,
        iconSize: iconSize ?? this.iconSize,
        imageSize: imageSize ?? this.imageSize,
      );

  @override
  AppDimensions lerp(ThemeExtension<AppDimensions>? other, double t) {
    if (other is! AppDimensions) return this;
    return AppDimensions(
      spacing: AppSpacing.lerp(spacing, other.spacing, t),
      iconSize: AppIconSize.lerp(iconSize, other.iconSize, t),
      imageSize: AppImageSize.lerp(imageSize, other.imageSize, t),
    );
  }
}

class AppSpacing {
  const AppSpacing({
    this.xs = 4,
    this.sm = 8,
    this.md = 16,
    this.lg = 24,
    this.xl = 32,
    this.xxl = 48,
  });

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;

  static AppSpacing lerp(AppSpacing a, AppSpacing b, double t) => AppSpacing(
        xs: a.xs + (b.xs - a.xs) * t,
        sm: a.sm + (b.sm - a.sm) * t,
        md: a.md + (b.md - a.md) * t,
        lg: a.lg + (b.lg - a.lg) * t,
        xl: a.xl + (b.xl - a.xl) * t,
        xxl: a.xxl + (b.xxl - a.xxl) * t,
      );
}

class AppIconSize {
  const AppIconSize({
    this.sm = 16,
    this.md = 24,
    this.lg = 32,
    this.xl = 48,
  });

  final double sm;
  final double md;
  final double lg;
  final double xl;

  static AppIconSize lerp(AppIconSize a, AppIconSize b, double t) =>
      AppIconSize(
        sm: a.sm + (b.sm - a.sm) * t,
        md: a.md + (b.md - a.md) * t,
        lg: a.lg + (b.lg - a.lg) * t,
        xl: a.xl + (b.xl - a.xl) * t,
      );
}

class AppImageSize {
  const AppImageSize({
    this.xs = 40,
    this.sm = 72,
    this.md = 120,
    this.lg = 200,
  });

  final double xs;
  final double sm;
  final double md;
  final double lg;

  static AppImageSize lerp(AppImageSize a, AppImageSize b, double t) =>
      AppImageSize(
        xs: a.xs + (b.xs - a.xs) * t,
        sm: a.sm + (b.sm - a.sm) * t,
        md: a.md + (b.md - a.md) * t,
        lg: a.lg + (b.lg - a.lg) * t,
      );
}
