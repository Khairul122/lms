import 'package:flutter/material.dart';

/// Centralized brand palette for the siswa app.
/// `primary` (0xFF38B0FE) and `primaryDark` (0xFF42A5F5) were previously
/// hardcoded inline across ~29 files. Kept the same class name/shape as
/// guru's AppColors so the pattern is portable between the two apps.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF38B0FE);
  static const Color primaryDark = Color(0xFF42A5F5);
  static const Color background = Color(0xFFF5F6FA);
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF2E7D32);
  static const Color textPrimary = Color(0xFF1B1B1F);
  static const Color textSecondary = Color(0xFF6B6B70);
}
