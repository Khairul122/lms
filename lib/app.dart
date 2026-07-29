import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/services/api_service.dart';
import 'package:lms/features/onboarding/presentation/onboarding.dart';
import 'package:lms/features/onboarding/presentation/homepage.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduSmart LMS',
      theme: AppTheme.light,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 2));

    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      _navigateTo(const OnboardingScreen());
      return;
    }

    try {
      final response = await ApiService.post('/firebase-login', {
        "email": firebaseUser.email,
      });

      if (response != null && response is Map && response["success"] == true) {
        final user = response["user"];
        final token = response["token"];
        final prefs = await SharedPreferences.getInstance();

        if (token != null) {
          await prefs.setString("token", token.toString());
        }

        if (user != null) {
          await prefs.setInt("user_id", user["id"] ?? 0);
          await prefs.setString("name", user["name"] ?? "");
          await prefs.setString("email", user["email"] ?? "");
          await prefs.setString("role", user["role"] ?? "");
        }

        await prefs.reload();

        _navigateTo(const homepage());
        return;
      }
    } catch (e) {
      debugPrint("Gagal auto-sync Laravel startup siswa: $e");
    }

    _navigateTo(const OnboardingScreen());
  }

  void _navigateTo(Widget targetPage) {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => targetPage),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF3498DB);
    return Scaffold(
      backgroundColor: primaryBlue,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 250,
                height: 250,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.menu_book_rounded,
                  size: 120,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
