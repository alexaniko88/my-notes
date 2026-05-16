import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  const AppColors({required this.searchHighlight});

  final Color searchHighlight;

  static const light = AppColors(searchHighlight: Color(0xFFFFEB3B));
  static const dark = AppColors(searchHighlight: Color(0xFF827717));

  @override
  AppColors copyWith({Color? searchHighlight}) {
    return AppColors(searchHighlight: searchHighlight ?? this.searchHighlight);
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      searchHighlight: Color.lerp(searchHighlight, other.searchHighlight, t)!,
    );
  }
}
