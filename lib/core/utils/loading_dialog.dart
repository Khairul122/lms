import 'package:flutter/material.dart';
import 'package:guru/core/theme/app_colors.dart';

/// Shared loading indicator dialog, replacing ~26 duplicated inline
/// showDialog(...CircularProgressIndicator...) implementations.
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
