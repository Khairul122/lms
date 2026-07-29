import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lms/core/widgets/app_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lms/services/api_service.dart';
import 'package:lms/features/profile/presentation/info_profil.dart';
import 'package:lms/features/auth/presentation/ubah_kata_sandi.dart';
import 'package:lms/features/notifications/presentation/notifikasi.dart';
import 'package:lms/features/auth/presentation/login.dart';
import 'package:lms/core/widgets/bottom_nav_bar.dart';
import 'package:lms/app_navigation.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  bool _isUploading = false;

  // 🔥 Helper Fetch Profil langsung pakai ApiService bawaan projek Siswa
  Future<Map<String, dynamic>> _fetchProfileData() async {
    try {
      final response = await ApiService.get('/profile');
      if (response != null && response is Map<String, dynamic>) {
        return response;
      }
    } catch (e) {
      debugPrint("Gagal fetch profil via ApiService: $e");
    }

    // Fallback dari SharedPreferences jika API bermasalah/offline
    final prefs = await SharedPreferences.getInstance();
    return {
      "success": true,
      "data": {
        "name": prefs.getString("name") ?? "Siswa EduSmart",
        "email": prefs.getString("email") ?? "",
      }
    };
  }

  // 🔥 Helper Ekstraksi String Aman (Anti Null / Belum Diisi)
  String _getValue(Map<String, dynamic> source, List<String> possibleKeys) {
    for (String key in possibleKeys) {
      if (source.containsKey(key) && source[key] != null) {
        String val = source[key].toString().trim();
        if (val.isNotEmpty && val != 'null') {
          return val;
        }
      }
    }
    return 'Siswa EduSmart';
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (pickedFile != null) {
      setState(() {
        _isUploading = true;
      });

      try {
        final bytes = await pickedFile.readAsBytes();
        final String base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';

        final response = await ApiService.post('/profile', {
          'photo': base64Image,
        });

        if (response != null && response['success'] == true) {
          if (mounted) {
            await AppDialog.showSuccess(context, 'Foto profil berhasil diperbarui');
          }
        } else {
          final msg = (response is Map ? response['message'] : null) ?? 'Gagal memperbarui foto profil.';
          if (mounted) {
            AppDialog.showError(context, msg.toString());
          }
        }
      } catch (e) {
        debugPrint("Upload photo failed: $e");
        if (mounted) {
          AppDialog.showError(context, 'Gagal memperbarui foto: $e');
        }
      } finally {
        if (mounted) {
          setState(() {
            _isUploading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchProfileData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          Map<String, dynamic> profileData = {};
          if (snapshot.hasData && snapshot.data != null) {
            final rawData = snapshot.data!;
            profileData = (rawData['data'] is Map<String, dynamic>)
                ? rawData['data']
                : rawData;
          }

          String siswaNama = _getValue(profileData, ['name', 'nama']);
          String? photoUrl;
          if (profileData['photo'] != null && profileData['photo'].toString().trim().isNotEmpty) {
            photoUrl = profileData['photo'].toString();
          }

          return Column(
            children: [
              // Header Custom
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF38B0FE),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        const Expanded(
                          child: Center(
                            child: Text(
                              'EduSmart',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Profil',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  child: Column(
                    children: [
                      // Avatar Profile
                      Stack(
                        children: [
                          Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey[200]!, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: _isUploading
                                  ? const Center(child: CircularProgressIndicator())
                                  : (photoUrl != null
                                      ? (photoUrl.startsWith('data:image')
                                          ? Image.memory(
                                              base64Decode(photoUrl.split(',').last),
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) => _buildDefaultAvatar(),
                                            )
                                          : Image.network(
                                              photoUrl,
                                              headers: const {
                                                'localtonet-skip-warning': 'true',
                                                'ngrok-skip-browser-warning': 'true',
                                              },
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) => _buildDefaultAvatar(),
                                            ))
                                      : _buildDefaultAvatar()),
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            right: 5,
                            child: GestureDetector(
                              onTap: _isUploading ? null : _pickAndUploadImage,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF38B0FE),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),

                      // Nama Siswa dari Backend
                      Text(
                        siswaNama,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),

                      // Menu Items
                      _buildMenuItem(context, 'Info Profil', Icons.person_outline),
                      const SizedBox(height: 15),
                      _buildMenuItem(context, 'Ubah Kata Sandi', Icons.lock_outline),
                      const SizedBox(height: 15),
                      _buildMenuItem(context, 'Notifikasi', Icons.notifications_none_outlined),

                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _showLogoutDialog(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF38B0FE),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Keluar',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 3,
        onTabSelected: (index) => AppNavigation.goToTab(context, index),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return const Icon(Icons.person, size: 80, color: Color(0xFF38B0FE));
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF38B0FE)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {
          if (title == 'Info Profil') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const InfoProfilScreen()),
            );
          } else if (title == 'Ubah Kata Sandi') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UbahKataSandiScreen()),
            );
          } else if (title == 'Notifikasi') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotifikasiScreen()),
            );
          }
        },
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final confirm = await AppDialog.showConfirm(
      context,
      title: 'Konfirmasi Logout',
      message: 'Apakah Anda yakin ingin keluar dari akun ini?',
      confirmText: 'Ya, Keluar',
      cancelText: 'Batal',
      confirmColor: Colors.red,
    );

    if (!confirm) return;

    try {
      await ApiService.post("/logout", {});
    } catch (e) {
      debugPrint("Session Laravel sudah hangus atau server offline: $e");
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    await prefs.remove("user_id");
    await prefs.remove("name");
    await prefs.remove("email");
    await prefs.remove("role");

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

}