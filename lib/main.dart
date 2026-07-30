import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:lms/app.dart';
import 'package:lms/core/services/local_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  await LocalNotificationService.instance.init();

  runApp(const App());
}
