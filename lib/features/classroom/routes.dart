import 'package:flutter/material.dart';
import 'presentation/dftr_kelas.dart';

class ClassroomRoutes {
  ClassroomRoutes._();

  static Route<dynamic> daftarKelas() {
    return MaterialPageRoute(builder: (_) => const DaftarKelasScreen());
  }
}
