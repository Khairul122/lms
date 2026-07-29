import 'package:flutter/material.dart';
import 'package:lms/core/theme/app_colors.dart';

/// Shared SnackBar helper. Same API as guru's SnackbarHelper
/// (SnackbarHelper.showError/showSuccess(context, message)).
class SnackbarHelper {
  SnackbarHelper._();

  static void showSuccess(BuildContext context, String message) {
    _show(context, message, AppColors.success);
  }

  static void showError(BuildContext context, String message) {
    _show(context, message, AppColors.error);
  }

  static void _show(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }
}
