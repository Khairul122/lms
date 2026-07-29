import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guru/features/onboarding/presentation/intro1.dart';
import 'package:guru/features/onboarding/presentation/halamanutama.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Cek Status Login setelah 3 detik
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // Jika sudah login, ke Halaman Utama
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HalamanUtama()),
          );
        } else {
          // Jika belum login, ke Intro
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Intro1()),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A237E), // Dark blue background
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Image
              Image.asset(
                'assets/logo.png',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              // EduSmart Text
            ],
          ),
        ),
      ),
    );
  }
}
