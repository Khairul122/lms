import 'package:flutter/material.dart';
import 'presentation/daftarkelas.dart';
import 'presentation/tambahkelas.dart';

class ClassroomRoutes {
  ClassroomRoutes._();

  static Route<dynamic> daftarKelas() {
    return MaterialPageRoute(builder: (_) => const DaftarKelas());
  }

  static Route<dynamic> tambahKelas() {
    return MaterialPageRoute(builder: (_) => const TambahKelas());
  }
}
