import 'package:flutter/material.dart';
import 'presentation/daftar_tugas.dart';

class TasksRoutes {
  TasksRoutes._();

  static Route<dynamic> daftarTugas() {
    return MaterialPageRoute(builder: (_) => const DaftarTugasScreen());
  }
}
