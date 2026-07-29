import 'package:flutter/material.dart';
import 'presentation/penilaian.dart';

class TasksRoutes {
  TasksRoutes._();

  static Route<dynamic> penilaian() {
    return MaterialPageRoute(builder: (_) => const Penilaian());
  }
}
