import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guru/features/auth/presentation/login.dart';

class AturUlangPassword extends StatefulWidget {
  const AturUlangPassword({super.key});

  @override
  State<AturUlangPassword> createState() => _AturUlangPasswordState();
}

class _AturUlangPasswordState extends State<AturUlangPassword> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    final code = _codeController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (code.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Semua field harus diisi'), backgroundColor: Colors.orange));
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kata sandi tidak cocok'), backgroundColor: Colors.red));
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.confirmPasswordReset(code: code, newPassword: newPassword);
      if (mounted) {
        _showSuccessDialog();
      }
    } on FirebaseAuthException catch (e) {
      String message = "Gagal mengubah sandi.";
      if (e.code == 'invalid-action-code') message = "Kode tidak valid atau sudah kadaluarsa.";
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Berhasil!', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Kata sandi Anda telah berhasil diperbarui.'),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Login()), (route) => false);
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A237E), foregroundColor: Colors.white),
              child: const Text('KEMBALI KE LOGIN'),
            ),
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
          Positioned(right: -120, top: -130, child: Container(width: 350, height: 350, decoration: const BoxDecoration(color: Color(0xFF1A237E), shape: BoxShape.circle))),
          Positioned(left: -20, top: -100, child: Container(width: 250, height: 250, decoration: const BoxDecoration(color: Color(0xFFE3F2FD), shape: BoxShape.circle))),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    const Text('Atur Ulang Sandi', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF212121), height: 1.3)),
                    const SizedBox(height: 48),
                    _buildInput('Kode dari Email', 'Masukkan Kode dari Link Email', _codeController, Icons.vpn_key_outlined),
                    const SizedBox(height: 20),
                    _buildInput('Kata Sandi Baru', 'Masukkan Kata Sandi Baru', _newPasswordController, Icons.lock_outline, isPassword: true, obscure: _obscureNewPassword, toggle: () => setState(() => _obscureNewPassword = !_obscureNewPassword)),
                    const SizedBox(height: 20),
                    _buildInput('Konfirmasi Sandi', 'Konfirmasi Kata Sandi Baru', _confirmPasswordController, Icons.lock_reset_outlined, isPassword: true, obscure: _obscureConfirmPassword, toggle: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword)),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _updatePassword,
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A237E), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 2),
                        child: _isLoading
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text('GANTI SANDI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
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

  Widget _buildInput(String label, String hint, TextEditingController controller, IconData icon, {bool isPassword = false, bool obscure = false, VoidCallback? toggle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.grey),
            suffixIcon: isPassword ? IconButton(icon: Icon(obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: Colors.grey), onPressed: toggle) : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}
