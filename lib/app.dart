import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:guru/core/config/api_config.dart';
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
  bool _hasFirebaseUser = false;

  @override
  void initState() {
    super.initState();
    _checkAndSyncLaravel();
  }

  Future<void> _checkAndSyncLaravel() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      if (mounted) {
        setState(() {
          _hasFirebaseUser = false;
          _isSyncing = false;
        });
      }
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/firebase-login"),
        headers: ApiConfig.headers,
        body: jsonEncode({
          "email": firebaseUser.email,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["success"] == true) {
        final user = data["user"];
        final prefs = await SharedPreferences.getInstance();

        if (data["token"] != null) {
          await prefs.setString("token", data["token"].toString());
        }

        if (user != null) {
          await prefs.setInt("user_id", user["id"] ?? 0);
          await prefs.setString("name", user["name"] ?? "");
          await prefs.setString("email", user["email"] ?? "");
          await prefs.setString("role", user["role"] ?? "");
          await prefs.setString("nip", user["nip"] ?? "");
          await prefs.setString("phone", user["phone"] ?? "");
        }

        await prefs.reload();

        if (mounted) {
          setState(() {
            _hasFirebaseUser = true;
            _isSyncing = false;
          });
        }
        return;
      }
    } catch (e) {
      debugPrint("Gagal auto-sync Laravel saat startup: $e");
    }

    if (mounted) {
      setState(() {
        _hasFirebaseUser = false;
        _isSyncing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isSyncing) {
      return const SplashScreen();
    }

    if (_hasFirebaseUser) {
      return const HalamanUtama();
    } else {
      return const Login();
    }
  }
}
