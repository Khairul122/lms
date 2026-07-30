import 'package:flutter/material.dart';

import 'package:guru/app.dart';
import 'package:guru/core/services/local_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalNotificationService.instance.init();

  runApp(const App());
}
