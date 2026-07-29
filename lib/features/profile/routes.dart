import 'package:flutter/material.dart';
import 'presentation/profil.dart';

class ProfileRoutes {
  ProfileRoutes._();

  static Route<dynamic> profil() {
    return MaterialPageRoute(builder: (_) => const ProfilScreen());
  }
}
