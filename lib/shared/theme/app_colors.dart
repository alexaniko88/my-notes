import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  const AppColors({required this.searchHighlight, required this.fabScrim});

  final Color searchHighlight;
  final Color fabScrim;

  static const light = AppColors(
    searchHighlight: Color(0xFFFFEB3B),
    fabScrim: Colors.black54,
  );
  static const dark = AppColors(
    searchHighlight: Color(0xFF827717),
    fabScrim: Colors.black54,
  );

  @override
  AppColors copyWith({Color? searchHighlight, Color? fabScrim}) {
    return AppColors(
      searchHighlight: searchHighlight ?? this.searchHighlight,
      fabScrim: fabScrim ?? this.fabScrim,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      searchHighlight: Color.lerp(searchHighlight, other.searchHighlight, t)!,
      fabScrim: Color.lerp(fabScrim, other.fabScrim, t)!,
    );
  }
}
