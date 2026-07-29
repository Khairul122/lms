import 'package:flutter/material.dart';
import 'package:lms/features/onboarding/routes.dart';
import 'package:lms/features/classroom/routes.dart';
import 'package:lms/features/tasks/routes.dart';
import 'package:lms/features/profile/routes.dart';

/// Single composition point translating a bottom-nav tab index into a
/// navigation action, using each feature's own routes.dart. Lives outside
/// core/ and features/ since it depends on multiple features - mirrors
/// guru's app_navigation.dart.
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
        route = TasksRoutes.daftarTugas();
        break;
      case 3:
        route = ProfileRoutes.profil();
        break;
      default:
        return;
    }
    Navigator.pushReplacement(context, route);
  }
}
