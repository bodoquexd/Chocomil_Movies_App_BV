import 'package:flutter/material.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';

class AppTheme {
  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: const Color(0xFF2862F5),
    scaffoldBackgroundColor: AppColors.cardBackground,
    canvasColor: AppColors.cardBackground,
  );
}