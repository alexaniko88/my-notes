import 'package:flutter/material.dart';

double _lerp(double a, double b, double t) => a + (b - a) * t;

@immutable
class AppDimensions extends ThemeExtension<AppDimensions> {
  static const defaults = AppDimensions();

  final AppSpacing spacing;
  final AppIconSize iconSize;
  final AppImageSize imageSize;
  final AppBorderRadius borderRadius;

  const AppDimensions({
    this.spacing = const AppSpacing(),
    this.iconSize = const AppIconSize(),
    this.imageSize = const AppImageSize(),
    this.borderRadius = const AppBorderRadius(),
  });

  @override
  AppDimensions copyWith({
    AppSpacing? spacing,
    AppIconSize? iconSize,
    AppImageSize? imageSize,
    AppBorderRadius? borderRadius,
  }) => AppDimensions(
    spacing: spacing ?? this.spacing,
    iconSize: iconSize ?? this.iconSize,
    imageSize: imageSize ?? this.imageSize,
    borderRadius: borderRadius ?? this.borderRadius,
  );

  @override
  AppDimensions lerp(ThemeExtension<AppDimensions>? other, double t) {
    if (other is! AppDimensions) {
      return this;
    }
    return AppDimensions(
      spacing: AppSpacing.lerp(spacing, other.spacing, t),
      iconSize: AppIconSize.lerp(iconSize, other.iconSize, t),
      imageSize: AppImageSize.lerp(imageSize, other.imageSize, t),
      borderRadius: AppBorderRadius.lerp(borderRadius, other.borderRadius, t),
    );
  }
}

@immutable
class AppSpacing {
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;

  const AppSpacing({
    this.xs = 4,
    this.sm = 8,
    this.md = 16,
    this.lg = 24,
    this.xl = 32,
    this.xxl = 48,
  });

  static AppSpacing lerp(AppSpacing a, AppSpacing b, double t) => AppSpacing(
    xs: _lerp(a.xs, b.xs, t),
    sm: _lerp(a.sm, b.sm, t),
    md: _lerp(a.md, b.md, t),
    lg: _lerp(a.lg, b.lg, t),
    xl: _lerp(a.xl, b.xl, t),
    xxl: _lerp(a.xxl, b.xxl, t),
  );
}

@immutable
class AppIconSize {
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;

  const AppIconSize({
    this.sm = 16,
    this.md = 24,
    this.lg = 32,
    this.xl = 48,
    this.xxl = 64,
  });

  static AppIconSize lerp(AppIconSize a, AppIconSize b, double t) =>
      AppIconSize(
        sm: _lerp(a.sm, b.sm, t),
        md: _lerp(a.md, b.md, t),
        lg: _lerp(a.lg, b.lg, t),
        xl: _lerp(a.xl, b.xl, t),
        xxl: _lerp(a.xxl, b.xxl, t),
      );
}

@immutable
class AppImageSize {
  final double xs;
  final double sm;
  final double md;
  final double lg;

  const AppImageSize({
    this.xs = 40,
    this.sm = 72,
    this.md = 120,
    this.lg = 200,
  });

  static AppImageSize lerp(AppImageSize a, AppImageSize b, double t) =>
      AppImageSize(
        xs: _lerp(a.xs, b.xs, t),
        sm: _lerp(a.sm, b.sm, t),
        md: _lerp(a.md, b.md, t),
        lg: _lerp(a.lg, b.lg, t),
      );
}

@immutable
class AppBorderRadius {
  final double sm;
  final double md;
  final double lg;
  final double xl;

  const AppBorderRadius({
    this.sm = 8,
    this.md = 12,
    this.lg = 16,
    this.xl = 24,
  });

  static AppBorderRadius lerp(AppBorderRadius a, AppBorderRadius b, double t) =>
      AppBorderRadius(
        sm: _lerp(a.sm, b.sm, t),
        md: _lerp(a.md, b.md, t),
        lg: _lerp(a.lg, b.lg, t),
        xl: _lerp(a.xl, b.xl, t),
      );
}
