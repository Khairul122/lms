import 'package:flutter/material.dart';
import 'package:lms/core/theme/app_colors.dart';

/// Shared loading indicator dialog. Same API as guru's LoadingDialog
/// (LoadingDialog.show(context) / LoadingDialog.hide(context)).
class LoadingDialog {
  LoadingDialog._();

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }

  static void hide(BuildContext context) {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
