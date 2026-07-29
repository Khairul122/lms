import 'package:flutter/material.dart';

/// Centralized brand palette for the guru app.
/// `primary` (0xFF1A237E) was previously hardcoded inline across ~39 files.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF1A237E);
  static const Color primaryLight = Color(0xFF3949AB);
  static const Color background = Color(0xFFF5F6FA);
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF2E7D32);
  static const Color textPrimary = Color(0xFF1B1B1F);
  static const Color textSecondary = Color(0xFF6B6B70);
}
