import 'package:flutter/material.dart';
import 'package:guru/core/widgets/app_dialog.dart';

class SnackbarHelper {
  SnackbarHelper._();

  static void showSuccess(BuildContext context, String message) {
    AppDialog.showSuccess(context, message);
  }

  static void showError(BuildContext context, String message) {
    AppDialog.showError(context, message);
  }

  static void showInfo(BuildContext context, String message) {
    AppDialog.showInfo(context, message);
  }
}
