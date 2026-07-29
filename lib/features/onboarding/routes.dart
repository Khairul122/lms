import 'package:flutter/material.dart';
import 'presentation/halamanutama.dart';

class OnboardingRoutes {
  OnboardingRoutes._();

  static Route<dynamic> home() {
    return MaterialPageRoute(builder: (_) => const HalamanUtama());
  }
}
