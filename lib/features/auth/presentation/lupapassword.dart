import 'package:flutter/material.dart';
import 'package:guru/core/widgets/app_dialog.dart';
import 'package:guru/features/auth/presentation/aturulangpassword.dart';
import 'package:guru/services/api_service.dart';

class LupaPassword extends StatefulWidget {
  const LupaPassword({super.key});

  @override
  State<LupaPassword> createState() => _LupaPasswordState();
}

class _LupaPasswordState extends State<LupaPassword> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      AppDialog.showError(context, 'Masukkan email Anda terlebih dahulu!');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await ApiService.post("/forgot-password", {
        "email": email,
      });

      if (response is Map && response["success"] == true) {
        if (mounted) {
          _showSuccessDialog(email);
        }
      } else {
        final message = (response is Map ? response["message"] : null) ?? "Gagal mengirim email reset.";
        if (mounted) {
          AppDialog.showError(context, message.toString());
        }
      }
    } catch (e) {
      if (mounted) {
        AppDialog.showError(context, 'Error: $e');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog(String email) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Email Terkirim!'),
        content: const Text('Silakan periksa email Anda untuk mendapatkan link reset kata sandi.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => AturUlangPassword(email: email)));
            },
            child: const Text('LANJUTKAN KE PENGATURAN SANDI', style: TextStyle(color: Color(0xFF1A237E), fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('KEMBALI KE LOGIN', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            right: -120,
            top: -130,
            child: Container(
              width: 350,
              height: 350,
              decoration: const BoxDecoration(color: Color(0xFF1A237E), shape: BoxShape.circle),
            ),
          ),
          Positioned(
            left: -20,
            top: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: const BoxDecoration(color: Color(0xFFE3F2FD), shape: BoxShape.circle),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      'Lupa Kata Sandi?',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF212121), height: 1.3),
                    ),
                    const SizedBox(height: 48),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Masukkan Email Terdaftar', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF212121))),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'email@guru.com',
                            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1A237E), width: 1.5)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _resetPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A237E),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                        ),
                        child: _isLoading
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text('KIRIM LINK RESET', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
