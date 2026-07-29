import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lms/features/onboarding/homepage.dart';
import 'package:lms/features/auth/daftar.dart';
import 'package:lms/features/auth/lupa_sandi.dart';
import 'package:lms/notification_service.dart';
import 'package:lms/features/auth/lengkapi_profil.dart';
import 'package:lms/services/api_service.dart'; // 🔥 Import ApiService

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 🔥 Variabel baseUrl lokal ditiadakan, diganti pakai ApiService
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Decorative Header Blobs
          Positioned(
            top: -100,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: const Color(0xFFE1F5FE).withValues(alpha: 0.8),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: const BoxDecoration(
                color: Color(0xFF38B0FE),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                children: [
                  const SizedBox(height: 180),
                  const Text(
                    'Selamat Datang',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    'Silahkan masuk ke akun Anda',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 60),

                  // Email Field
                  _buildTextField(_emailController, 'Email', icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 20),

                  // Password Field
                  _buildTextField(
                    _passwordController,
                    'Kata Sandi',
                    icon: Icons.lock_outline,
                    isPassword: _obscureText,
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey, size: 20),
                      onPressed: () => setState(() => _obscureText = !_obscureText),
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LupaSandiScreen())),
                      child: const Text(
                        'Lupa Kata Sandi?',
                        style: TextStyle(color: Color(0xFF38B0FE), fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF38B0FE),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 4,
                        shadowColor: Colors.black.withValues(alpha: 0.3),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'MASUK',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                            ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Separator
                  Row(
                    children: [
                      Expanded(child: Container(height: 1, color: Colors.black12)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text('ATAU', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                      ),
                      Expanded(child: Container(height: 1, color: Colors.black12)),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Google Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : _signInWithGoogle,
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.g_mobiledata, color: Colors.red, size: 40),
                          const SizedBox(width: 8),
                          Text(
                            'Masuk dengan Google',
                            style: TextStyle(color: Colors.black.withValues(alpha: 0.6), fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Belum punya akun? ", style: TextStyle(color: Colors.black54)),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DaftarScreen())),
                        child: const Text(
                          'Daftar Sekarang',
                          style: TextStyle(color: Color(0xFF38B0FE), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {bool isPassword = false, TextInputType keyboardType = TextInputType.text, IconData? icon, Widget? suffixIcon}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: icon != null ? Icon(icon, color: const Color(0xFF38B0FE), size: 20) : null,
          suffixIcon: suffixIcon,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.grey.shade100),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.grey.shade100),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFF38B0FE), width: 1.5),
          ),
        ),
      ),
    );
  }

  /// 🔥 SINKRONISASI TOKEN LARAVEL SANCTUM MENGGUNAKAN API SERVICE
  Future<bool> syncLaravelUser() async {
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) return false;

      // 🔥 Langsung pakai ApiService.post
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
        return true;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Akun belum terdaftar pada LMS")),
        );
      }
      await FirebaseAuth.instance.signOut();
      return false;
    } catch (e) {
      debugPrint("Error sync Laravel: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal terhubung ke Laravel server\n$e")),
        );
      }
      return false;
    }
  }

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email dan kata sandi harus diisi')));
      return;
    }
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(), 
        password: _passwordController.text.trim()
      );
      
      bool success = await syncLaravelUser();
      if (success) {
        await NotificationService.syncTopics();
        if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const homepage()));
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Login gagal';
      if (e.code == 'user-not-found') message = 'Email tidak terdaftar';
      if (e.code == 'wrong-password') message = 'Kata sandi salah';
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;
      
      if (user != null) {
        bool success = await syncLaravelUser();
        if (success) {
          final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
          if (!userDoc.exists) {
            if (mounted) {
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(
                  builder: (context) => LengkapProfilScreen(
                    nama: user.displayName ?? '', 
                    email: user.email ?? '', 
                    photoUrl: user.photoURL
                  )
                )
              );
            }
          } else {
            await NotificationService.syncTopics();
            if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const homepage()));
          }
        }
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Koneksi bermasalah atau gagal: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}