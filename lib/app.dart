import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:guru/core/theme/app_theme.dart';
import 'package:guru/features/onboarding/presentation/splash_screen.dart';
import 'package:guru/features/onboarding/presentation/halamanutama.dart';
import 'package:guru/features/auth/presentation/login.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduSmart Guru',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: const AuthCheck(),
    );
  }
}

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool _isSyncing = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    final token = prefs.getString("token");

    if (mounted) {
      setState(() {
        _isLoggedIn = token != null && token.isNotEmpty;
        _isSyncing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isSyncing) {
      return const SplashScreen();
    }

    if (_isLoggedIn) {
      return const HalamanUtama();
    } else {
      return const Login();
    }
  }
}
