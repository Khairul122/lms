import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lms/services/api_service.dart';
import 'package:lms/features/auth/presentation/login.dart';
import 'package:lms/core/services/notification_service.dart';
import 'package:lms/features/onboarding/presentation/homepage.dart';

class DaftarScreen extends StatefulWidget {
  const DaftarScreen({super.key});

  @override
  State<DaftarScreen> createState() => _DaftarScreenState();
}

class _DaftarScreenState extends State<DaftarScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _tempatLahirController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
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
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2008),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF38B0FE)),
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
                  _buildTextField(_phoneController, 'Nomor Handphone', keyboardType: TextInputType.phone),
                  
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
                            'Daftar dengan Google',
                            style: TextStyle(color: Colors.black.withValues(alpha: 0.6), fontSize: 16, fontWeight: FontWeight.w600),
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
                        backgroundColor: const Color(0xFF38B0FE),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 4,
                        shadowColor: Colors.black.withValues(alpha: 0.3),
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
                        color: Colors.black87,
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

  Widget _buildTextField(TextEditingController controller, String hint, {bool isPassword = false, TextInputType keyboardType = TextInputType.text}) {
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

  Widget _buildDropdownField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
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

  /// 🔥 PROSES SINKRONISASI AKUN BARU KE BACKEND LARAVEL
  Future<bool> _syncNewUserToLaravel(String name, String email, String password) async {
    try {
      final response = await ApiService.post("/register", {
        "name": name,
        "email": email,
        "password": password,
        "role": "siswa", // 🔥 Diubah ke "siswa" agar lolos validasi ENUM MySQL
      });

      if (response != null && response['success'] == true) {
        final user = response['user'];
        final token = response['token'];
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
      return false;
    } catch (e) {
      debugPrint("Gagal melempar data registrasi ke Laravel: $e");
      return false;
    }
  }

  Future<void> _register() async {
    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nama, Email, dan Sandi harus diisi')));
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Konfirmasi kata sandi tidak cocok')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      // 1. Daftarkan kredensial akun ke Firebase Auth
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Sinkronisasikan data profil lengkap ke MySQL Server Laravel
      bool syncSuccess = await _syncNewUserToLaravel(name, email, password);

      if (syncSuccess) {
        await NotificationService.syncTopics();

        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Berhasil'),
              content: const Text('Akun Anda telah berhasil dibuat di database server.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const homepage()));
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        throw Exception("Gagal mendaftarkan data profil Anda ke MySQL Server.");
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Pendaftaran gagal';
      if (e.code == 'email-already-in-use') message = 'Email sudah digunakan';
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
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
        bool syncSuccess = await _syncNewUserToLaravel(
          user.displayName ?? 'Siswa Google', 
          user.email ?? '', 
          'google_authenticated_secure_123'
        );

        if (syncSuccess) {
          await NotificationService.syncTopics();
          if (mounted) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const homepage()));
          }
        } else {
          await FirebaseAuth.instance.signOut();
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Akun Google gagal disinkronkan ke LMS')));
        }
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal masuk dengan Google: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}