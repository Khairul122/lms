import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guru/features/profile/data/profile_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:guru/core/widgets/bottom_nav_bar.dart';
import 'package:guru/app_navigation.dart';
import 'package:guru/features/auth/presentation/login.dart';
import 'package:guru/features/profile/presentation/info_akun.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  final ProfileRepository _repository = ProfileRepository();
  final User? user = FirebaseAuth.instance.currentUser;
  bool _isUploading = false;

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _isUploading = true;
      });
      
      try {
        // Implementasi upload foto jika diperlukan
      } catch (e) {
        debugPrint("Upload failed: $e");
      } finally {
        if (mounted) {
          setState(() {
            _isUploading = false;
          });
        }
      }
    }
  }

  // 🔥 Helper Ekstraksi String Aman & Anti Null
  String _getValue(Map<String, dynamic> source, List<String> possibleKeys) {
    for (String key in possibleKeys) {
      if (source.containsKey(key) && source[key] != null) {
        String val = source[key].toString().trim();
        if (val.isNotEmpty && val != 'null') {
          return val;
        }
      }
    }
    return 'Belum diisi';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _repository.getProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text("Profil tidak ditemukan"),
            );
          }

          final Map<String, dynamic> rawResponse = snapshot.data!;

          // 🔥 Buka pembungkus objek 'data' dari Response JSON Laravel
          final Map<String, dynamic> profileData = 
              (rawResponse['data'] is Map<String, dynamic>)
                  ? rawResponse['data']
                  : rawResponse;

          // 🔥 PETAKAN KEY JSON SESUAI RESPONSE BACKEND LARAVEL
          String nama = _getValue(profileData, ['name', 'nama']);
          String email = _getValue(profileData, ['email']);
          String telepon = _getValue(profileData, ['phone', 'telepon', 'no_hp']);
          String ttl = _getValue(profileData, ['ttl', 'tanggal_lahir', 'birth_date']);
          String jenisKelamin = _getValue(profileData, ['jenis_kelamin', 'gender']);
          String nip = _getValue(profileData, ['nip', 'nisn', 'nik']);
          String mataPelajaran = _getValue(profileData, ['mata_pelajaran', 'subject', 'jurusan']);
          String sekolahAsal = _getValue(profileData, ['sekolah_asal', 'school', 'instansi']);
          String alamat = _getValue(profileData, ['alamat', 'address']);
          
          String? photoUrl;
          if (profileData['photo'] != null && profileData['photo'].toString().trim().isNotEmpty) {
            photoUrl = profileData['photo'].toString();
          }

          return Column(
            children: [
              // Header Profil
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF1A237E),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
                    child: Column(
                      children: [
                        const Text(
                          'Profil',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Stack(
                          children: [
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 5),
                              ),
                              child: ClipOval(
                                child: _isUploading
                                    ? const Center(
                                        child: CircularProgressIndicator(color: Colors.white),
                                      )
                                    : (photoUrl != null
                                        ? Image.network(
                                            photoUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => _buildDefaultAvatar(),
                                          )
                                        : _buildDefaultAvatar()),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _isUploading ? null : _pickAndUploadImage,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Color(0xFF1A237E),
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          nama,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          email,
                          style: const TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          telepon,
                          style: const TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Detail List Info Profil
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 30, 20, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoField('Nama Lengkap', nama),
                        const SizedBox(height: 20),
                        _buildInfoField('Tempat, Tanggal Lahir', ttl),
                        const SizedBox(height: 20),
                        _buildInfoField('Jenis Kelamin', jenisKelamin),
                        const SizedBox(height: 20),
                        _buildInfoField('Nomor Induk Pegawai / NISN', nip),
                        const SizedBox(height: 20),
                        _buildInfoField('Mata Pelajaran / Jurusan', mataPelajaran),
                        const SizedBox(height: 20),
                        _buildInfoField('Sekolah Asal', sekolahAsal),
                        const SizedBox(height: 20),
                        _buildInfoField('Alamat', alamat),
                        const SizedBox(height: 40),
                        
                        // Tombol Aksi
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  await FirebaseAuth.instance.signOut();
                                  if (context.mounted) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => const Login()),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: const BorderSide(color: Color(0xFF1A237E), width: 1),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.arrow_back, color: Color(0xFF1A237E), size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Keluar',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1A237E),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const InfoProfil()),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: const BorderSide(color: Color(0xFF1A237E), width: 1),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.settings_outlined, color: Color(0xFF1A237E), size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Info Akun',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1A237E),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Tombol Tes Crash
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => FirebaseCrashlytics.instance.crash(),
                            icon: const Icon(Icons.bug_report, color: Colors.red),
                            label: const Text(
                              'Tes Crash (Debug)',
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.red),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
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
        onCenterTap: () => AppNavigation.openTambahKelas(context),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: Colors.grey.shade300,
      child: const Icon(Icons.person, size: 70, color: Color(0xFF1A237E)),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A237E),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
        ),
        const SizedBox(height: 12),
        Container(
          height: 1.5,
          color: const Color(0xFF1A237E).withValues(alpha: 0.2),
        ),
      ],
    );
  }
}