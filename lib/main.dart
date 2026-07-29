import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:ui'; // Untuk PlatformDispatcher

import 'features/onboarding/splash_screen.dart';
import 'features/onboarding/halamanutama.dart';
import 'features/auth/login.dart';
import 'package:guru/notification_service.dart';
import 'package:guru/config/api_config.dart'; // 🔥 Import ApiConfig

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // KONFIGURASI CRASHLYTICS GURU
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await NotificationService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduSmart Guru',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
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

    // 🔥 Tembak API menggunakan ApiConfig.baseUrl
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