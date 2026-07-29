import 'package:flutter/material.dart';
import 'package:guru/features/onboarding/routes.dart';
import 'package:guru/features/classroom/routes.dart';
import 'package:guru/features/tasks/routes.dart';
import 'package:guru/features/profile/routes.dart';

/// Single composition point translating a bottom-nav tab index into a
/// navigation action, using each feature's own routes.dart. Lives outside
/// core/ and features/ since it depends on multiple features - this is the
/// one place allowed to know about all of them, keeping
/// core/widgets/bottom_nav_bar.dart itself feature-agnostic.
class AppNavigation {
  AppNavigation._();

  static void goToTab(BuildContext context, int index) {
    final Route<dynamic> route;
    switch (index) {
      case 0:
        route = OnboardingRoutes.home();
        break;
      case 1:
        route = ClassroomRoutes.daftarKelas();
        break;
      case 2:
        route = TasksRoutes.penilaian();
        break;
      case 3:
        route = ProfileRoutes.profil();
        break;
      default:
        return;
    }
    Navigator.pushReplacement(context, route);
  }

  static void openTambahKelas(BuildContext context) {
    Navigator.push(context, ClassroomRoutes.tambahKelas());
  }
}
