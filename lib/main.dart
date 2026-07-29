import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';

import 'features/onboarding/onboarding.dart';
import 'package:lms/notification_service.dart';
import 'features/onboarding/homepage.dart';
import 'package:lms/services/api_service.dart'; // 🔥 Import ApiService

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Tangkap error framework Flutter
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  
  // Tangkap error asynchronous
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await NotificationService.initialize();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduSmart LMS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), 
        useMaterial3: true
      ),
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
    // 1. Jeda 2 detik untuk menampilkan animasi splash screen
    await Future.delayed(const Duration(seconds: 2));
    
    final firebaseUser = FirebaseAuth.instance.currentUser;

    // 2. Jika tidak ada sesi Firebase, langsung lempar ke halaman Onboarding
    if (firebaseUser == null) {
      _navigateTo(const OnboardingScreen());
      return;
    }

    // 3. Jika sesi Firebase aktif, tarik Token Laravel Sanctum secara otomatis via ApiService
    try {
      final response = await ApiService.post('/firebase-login', {
        "email": firebaseUser.email,
      });

      if (response != null && response is Map && response["success"] == true) {
        final user = response["user"];
        final token = response["token"];
        final prefs = await SharedPreferences.getInstance();

        // Tanam Token Sanctum hasil sync ke internal storage
        if (token != null) {
          await prefs.setString("token", token.toString());
        }

        // Tanam data informasi dasar profil siswa
        if (user != null) {
          await prefs.setInt("user_id", user["id"] ?? 0);
          await prefs.setString("name", user["name"] ?? "");
          await prefs.setString("email", user["email"] ?? "");
          await prefs.setString("role", user["role"] ?? "");
        }

        await prefs.reload(); // Paksa sinkronisasi memori ke penyimpanan lokal
        
        // Buka beranda dengan status terautentikasi Laravel
        _navigateTo(const homepage());
        return;
      }
    } catch (e) {
      debugPrint("Gagal auto-sync Laravel startup siswa: $e");
    }

    // Jika terjadi kegagalan koneksi ke server, arahkan kembali ke Onboarding demi keamanan
    _navigateTo(const OnboardingScreen());
  }

  void _navigateTo(Widget targetPage) {
    if (mounted) {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => targetPage)
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
                  color: Colors.white
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}