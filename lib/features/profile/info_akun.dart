import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guru/repositories/profile_repository.dart';
import 'package:guru/features/profile/profil.dart';
import 'package:guru/features/auth/ubah_sandi.dart';

class InfoProfil extends StatefulWidget {
  const InfoProfil({super.key});

  @override
  State<InfoProfil> createState() => _InfoProfilState();
}

class _InfoProfilState extends State<InfoProfil> {
  final User? user = FirebaseAuth.instance.currentUser;

  final ProfileRepository _repository = ProfileRepository();
  bool _isEditing = false;
  
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _teleponController.dispose();
    _nikController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

Future<void> _saveProfile() async {
  setState(() => _isEditing = false);

  try {
    await _repository.updateProfile({
      "name": _namaController.text,
      "phone": _teleponController.text,
      "nip": _nikController.text,
      "alamat": _alamatController.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profil berhasil diperbarui"),
      ),
    );

    setState(() {});
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
body: user == null
    ? const Center(
        child: Text("Silakan login kembali"),
      )
    : FutureBuilder<Map<String, dynamic>>(
        future: _repository.getProfile(),
        builder: (context, snapshot) {
if (snapshot.connectionState == ConnectionState.waiting) {
  return const Center(
    child: CircularProgressIndicator(),
  );
}

if (snapshot.hasError) {
  return Center(
    child: Text(snapshot.error.toString()),
  );
}

if (!snapshot.hasData) {
  return const Center(
    child: Text("Data tidak ditemukan"),
  );
}

final data = snapshot.data!;

if (!_isEditing) {
  _namaController.text = data["name"] ?? "";
  _teleponController.text = data["phone"] ?? "";
  _nikController.text = data["nip"] ?? "";
  _alamatController.text = data["alamat"] ?? "";
}

                return Column(
                  children: [
                    // Header
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
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: const Row(
                                  children: [
                                    Icon(Icons.arrow_back, color: Colors.white, size: 24),
                                    SizedBox(width: 8),
                                    Text('Kembali', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (_isEditing) {
                                    _saveProfile();
                                  } else {
                                    setState(() => _isEditing = true);
                                  }
                                },
                                child: Text(
                                  _isEditing ? 'Simpan' : 'Edit Profil',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text('Info Akun', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                    ),

                    // Main Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Info Akun Card
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE3F2FD),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildInfoField('Nama Lengkap', _namaController, isEditable: _isEditing),
                                  const SizedBox(height: 20),
                                  _buildInfoField('NO Hp', _teleponController, isEditable: _isEditing, keyboardType: TextInputType.phone),
                                  const SizedBox(height: 20),
                                 _buildInfoField(
                                  'Email',
                                  TextEditingController(
                                    text: data["email"] ?? "",
                                  ),
                                  isEditable: false,
                                ),
                                  _buildInfoField('NIK (Nomor Induk kepegawaian)', _nikController, isEditable: _isEditing),
                                  const SizedBox(height: 20),
                                  _buildInfoField('Alamat Diri', _alamatController, isEditable: _isEditing, maxLines: 3),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Sandi Card
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE3F2FD),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Sandi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                                  const SizedBox(height: 20),
                                  _buildInfoField('Nama Lengkap', _namaController, isEditable: false),
                                  const SizedBox(height: 20),
                                  _buildInfoField(
                                  'Email',
                                  TextEditingController(
                                    text: data["email"] ?? "",
                                  ),
                                  isEditable: false,
                                ),
                                  _buildInfoField('Sandi', TextEditingController(text: '*********'), isEditable: false),
                                ],
                              ),
                            ),

                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(right: 20, bottom: 20),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UbahSandi()),
            );
          },
          backgroundColor: const Color(0xFF1A237E),
          icon: const Icon(Icons.edit, color: Colors.white),
          label: const Text('Edit Sandi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, TextEditingController controller, {bool isEditable = true, TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A237E))),
        const SizedBox(height: 4),
        if (!isEditable) ...[
          Container(
            height: 1,
            color: const Color(0xFF1A237E).withValues(alpha: 0.3),
          ),
          const SizedBox(height: 8),
          Text(controller.text, style: const TextStyle(fontSize: 14, color: Color(0xFF1A237E))),
        ] else ...[
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: const TextStyle(fontSize: 14, color: Color(0xFF1A237E)),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF1A237E))),
              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF1A237E), width: 2)),
            ),
          ),
        ],
      ],
    );
  }
}
