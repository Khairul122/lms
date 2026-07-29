import 'package:flutter/material.dart';
import 'package:lms/core/widgets/app_dialog.dart';
import 'package:lms/services/api_service.dart';
import 'package:lms/features/auth/presentation/login.dart';

class AturUlangSandiScreen extends StatefulWidget {
  final String email;

  const AturUlangSandiScreen({super.key, required this.email});

  @override
  State<AturUlangSandiScreen> createState() => _AturUlangSandiScreenState();
}

class _AturUlangSandiScreenState extends State<AturUlangSandiScreen> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscureText1 = true;
  bool _obscureText2 = true;
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
      AppDialog.showError(context, 'Semua field harus diisi!');
      return;
    }

    if (newPassword != confirmPassword) {
      AppDialog.showError(context, 'Konfirmasi kata sandi tidak cocok!');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await ApiService.post("/reset-password", {
        "email": widget.email,
        "token": code,
        "password": newPassword,
      });

      if (response is Map && response["success"] == true) {
        if (mounted) {
          await AppDialog.showSuccess(context, 'Kata sandi berhasil diubah! Silakan login.');
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
            );
          }
        }
      } else {
        final message = (response is Map ? response["message"] : null) ?? "Gagal mengubah sandi.";
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
                color: const Color(0xFFE1F5FE).withOpacity(0.8),
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
                    'Atur Ulang Sandi',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Masukkan token dari email yang dikirim ke ${widget.email} beserta kata sandi baru Anda',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 50),

                  _buildTextField(_codeController, 'Token dari Email', icon: Icons.vpn_key_outlined),
                  const SizedBox(height: 20),

                  _buildTextField(
                    _newPasswordController,
                    'Kata Sandi Baru',
                    icon: Icons.lock_outline,
                    isPassword: _obscureText1,
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText1 ? Icons.visibility_off : Icons.visibility, color: Colors.grey, size: 20),
                      onPressed: () => setState(() => _obscureText1 = !_obscureText1),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildTextField(
                    _confirmPasswordController,
                    'Konfirmasi Sandi',
                    icon: Icons.lock_reset_outlined,
                    isPassword: _obscureText2,
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText2 ? Icons.visibility_off : Icons.visibility, color: Colors.grey, size: 20),
                      onPressed: () => setState(() => _obscureText2 = !_obscureText2),
                    ),
                  ),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _updatePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF38B0FE),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 4,
                        shadowColor: Colors.black.withOpacity(0.3),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'GANTI SANDI',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                            ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),

          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {bool isPassword = false, IconData? icon, Widget? suffixIcon}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
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
}
