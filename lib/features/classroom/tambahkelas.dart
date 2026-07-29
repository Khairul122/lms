import 'package:flutter/material.dart';
import 'dart:math';

import 'package:guru/services/api_service.dart';
import 'package:guru/features/classroom/buatkelas.dart';
import 'package:guru/features/onboarding/halamanutama.dart';
import 'package:guru/features/classroom/daftarkelas.dart';
import 'package:guru/features/profile/profil.dart';

class TambahKelas extends StatefulWidget {
  const TambahKelas({super.key});

  @override
  State<TambahKelas> createState() => _TambahKelasState();
}

class _TambahKelasState extends State<TambahKelas> {
  final TextEditingController _namaLengkapController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _namaSekolahController = TextEditingController();
  final TextEditingController _mataPelajaranController =
      TextEditingController();
  final TextEditingController _kelasController = TextEditingController();

  bool _isLoading = false;
  String? _generatedCode;

  String _generateClassCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    return List.generate(6, (index) => chars[Random().nextInt(chars.length)]).join();
  }
Future<void> _createClass() async {

  if (_namaLengkapController.text.isEmpty ||
      _emailController.text.isEmpty ||
      _namaSekolahController.text.isEmpty ||
      _mataPelajaranController.text.isEmpty ||
      _kelasController.text.isEmpty) {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Harap isi semua field"),
      ),
    );
    return;
  }

  setState(() {
    _isLoading = true;
  });

  try {

    final code = _generateClassCode();

    await ApiService.post(
      "/classes",
      {
        "teacher_name": _namaLengkapController.text.trim(),
        "teacher_email": _emailController.text.trim(),
        "school_name": _namaSekolahController.text.trim(),
        "subject": _mataPelajaranController.text.trim(),
        "class_name": _kelasController.text.trim(),
        "class_code": code,
      },
    );

    setState(() {
      _generatedCode = code;
      _isLoading = false;
    });

    if (mounted) {
      _showSuccessDialog(context);
    }

  } catch (e) {

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
      ),
    );

  }

}

  @override
  void dispose() {
    _namaLengkapController.dispose();
    _emailController.dispose();
    _namaSekolahController.dispose();
    _mataPelajaranController.dispose();
    _kelasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF1A237E),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header with dark blue background
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF1A237E),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: const Center(
                child: Text(
                  'Buat Kelas',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          // Main Content Area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Form Title
                  const Text(
                    'Form Buat Kelas',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Nama Lengkap Field
                  const Text(
                    'Nama Lengkap',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _namaLengkapController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan Nama Lengkap Anda',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFE3F2FD),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Email Field
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Masukkan Email Anda',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFE3F2FD),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Nama Sekolah Field
                  const Text(
                    'Nama Sekolah',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _namaSekolahController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan Nama Sekolah',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFE3F2FD),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Mata Pelajaran Field
                  const Text(
                    'Mata Pelajaran',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _mataPelajaranController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan Mata Pelajaran',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFE3F2FD),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Kelas Field
                  const Text(
                    'Kelas',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _kelasController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan Kelas',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFE3F2FD),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Buat Kelas Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _createClass,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A237E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading 
                        ? const SizedBox(
                            height: 20, 
                            width: 20, 
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                          )
                        : const Text(
                            'Buat Kelas',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Background with curved top edge
              ClipPath(
                clipper: BottomNavBarClipper(),
                child: Container(
                  decoration: const BoxDecoration(color: Color(0xFF1A237E)),
                  child: SafeArea(
                    top: false,
                    child: Container(
                      height: 70,
                      padding: const EdgeInsets.only(bottom: 8, top: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildNavItem(
                            Icons.home,
                            'Beranda',
                            0,
                            false,
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HalamanUtama(),
                                ),
                              );
                            },
                          ),
                          _buildNavItem(
                            Icons.present_to_all,
                            'Kelas',
                            1,
                            false,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DaftarKelas(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 70), // Space for center button
                          _buildNavItem(Icons.assignment, 'Nilai', 3, false),
                          _buildNavItem(
                            Icons.person_outline,
                            'Profil',
                            4,
                            false,
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Profil(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Center button (elevated) - outside ClipPath
              Positioned(
                left: constraints.maxWidth / 2 - 35,
                bottom: 55, // Position from bottom - button elevated higher
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TambahKelas(),
                      ),
                    );
                  },
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A237E),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Transform.translate(
                      offset: const Offset(0, 3),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    int index,
    bool isSelected, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isSelected
                  ? const Color(0xFF1A237E)
                  : Color.fromRGBO(255, 255, 255, 0.6),
              size: 22,
            ),
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isSelected
                    ? Colors.white
                    : Color.fromRGBO(255, 255, 255, 0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                const Text(
                  'Berhasil !',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                // Green Checkmark Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 50),
                ),
                const SizedBox(height: 20),
                // Message
                const Text(
                  'Anda Berhasil Membuat Kelas Baru',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 24),
                // Lanjut Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      Navigator.of(context).pop(); // Go back to previous page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BuatKelas(classCode: _generatedCode ?? ''),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A237E),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Lanjut',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Custom clipper for straight top edge
class BottomNavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Simple rectangle - no curves
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
