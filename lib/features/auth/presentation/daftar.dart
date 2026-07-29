import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:guru/features/onboarding/presentation/halamanutama.dart';
import 'package:guru/features/auth/presentation/login.dart';
import 'package:guru/config/api_config.dart'; // 🔥 Import ApiConfig

class Daftar extends StatefulWidget {
  const Daftar({super.key});

  @override
  State<Daftar> createState() => _DaftarState();
}

class _DaftarState extends State<Daftar> {
  // 🔥 Variable baseUrl lokal ditiadakan, memakai ApiConfig.baseUrl
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _tempatLahirController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  final TextEditingController _nipController = TextEditingController();
  final TextEditingController _mapelController = TextEditingController();
  final TextEditingController _sekolahController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  
  String _jenisKelamin = 'Laki-laki';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _tempatLahirController.dispose();
    _tanggalLahirController.dispose();
    _nipController.dispose();
    _mapelController.dispose();
    _sekolahController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF1A237E)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _tanggalLahirController.text = "${picked.day}-${picked.month}-${picked.year}";
      });
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
                color: const Color(0xFFE3F2FD).withOpacity(0.8),
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
                color: Color(0xFF1A237E),
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
                    'Buat Akun Baru',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Form Fields
                  _buildTextField(_nameController, 'Nama Lengkap'),
                  const SizedBox(height: 15),
                  _buildTextField(_usernameController, 'Username'),
                  const SizedBox(height: 15),
                  _buildTextField(_emailController, 'Email', keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 15),
                  _buildTextField(_passwordController, 'Kata Sandi', isPassword: true),
                  const SizedBox(height: 15),
                  _buildTextField(_confirmPasswordController, 'Konfirmasi Kata Sandi', isPassword: true),
                  const SizedBox(height: 15),
                  
                  // Personal Info
                  _buildTextField(_tempatLahirController, 'Tempat Lahir'),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: _buildTextField(_tanggalLahirController, 'Tanggal Lahir'),
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildDropdownField(),
                  const SizedBox(height: 15),
                  
                  // Professional Info
                  _buildTextField(_nipController, 'Nomor Induk Pegawai (NIP)'),
                  const SizedBox(height: 15),
                  _buildTextField(_mapelController, 'Mata Pelajaran'),
                  const SizedBox(height: 15),
                  _buildTextField(_sekolahController, 'Sekolah Asal'),
                  const SizedBox(height: 15),
                  _buildTextField(_alamatController, 'Alamat', maxLines: 3),
                  
                  const SizedBox(height: 30),
                  
                  // Separator
                  Row(
                    children: [
                      Expanded(child: Container(height: 1, color: Colors.black26)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text('ATAU', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                      ),
                      Expanded(child: Container(height: 1, color: Colors.black26)),
                    ],
                  ),
                  
                  const SizedBox(height: 30),

                  // Google Sign-In Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : _signInWithGoogle,
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.g_mobiledata, color: Colors.red, size: 40),
                          const SizedBox(width: 8),
                          Text(
                            'Daftar dengan Google',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.7),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Register Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10346B),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 4,
                        shadowColor: Colors.black.withOpacity(0.5),
                      ),
                      child: _isLoading 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'DAFTAR SEKARANG',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                          ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Footer
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Sudah Punya Akun?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool isPassword = false, TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(maxLines > 1 ? 20 : 30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(maxLines > 1 ? 20 : 30),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(maxLines > 1 ? 20 : 30),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(maxLines > 1 ? 20 : 30),
            borderSide: const BorderSide(color: Color(0xFF1A237E), width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _jenisKelamin,
          isExpanded: true,
          items: ['Laki-laki', 'Perempuan'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: const TextStyle(color: Colors.black87, fontSize: 14)),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _jenisKelamin = newValue!;
            });
          },
        ),
      ),
    );
  }

  Future<void> _register() async {
    final String name = _nameController.text.trim();
    final String username = _usernameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty || username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nama, Username, Email, dan Sandi harus diisi')));
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Konfirmasi kata sandi tidak cocok')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 🔥 Request Register ke Backend menggunakan ApiConfig
      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/register"),
        headers: ApiConfig.headers,
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "role": "guru",
          "nip": _nipController.text.trim(),
          "phone": "",
          "ttl": "${_tempatLahirController.text.trim()}, ${_tanggalLahirController.text.trim()}",
          "jenis_kelamin": _jenisKelamin,
          "mata_pelajaran": _mapelController.text.trim(),
          "sekolah_asal": _sekolahController.text.trim(),
          "alamat": _alamatController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(data["message"] ?? "Terjadi kesalahan saat pendaftaran");
      }

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Berhasil'),
            content: const Text('Akun Guru telah berhasil dibuat. Silahkan login.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Pendaftaran gagal';
      if (e.code == 'email-already-in-use') message = 'Email sudah digunakan';
      if (e.code == 'weak-password') message = 'Kata sandi terlalu lemah';
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
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
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'nama': user.displayName ?? '',
            'username': user.email?.split('@')[0] ?? '',
            'email': user.email ?? '',
            'role': 'guru',
            'created_at': FieldValue.serverTimestamp(),
            'telepon': '',
            'nik': '',
            'alamat': '',
            'tempat_lahir': '',
            'tanggal_lahir': '',
            'jenis_kelamin': 'Laki-laki',
            'mata_pelajaran': '',
            'sekolah_asal': '',
          });
        }
        if (mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HalamanUtama()));
        }
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Koneksi bermasalah atau gagal: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}