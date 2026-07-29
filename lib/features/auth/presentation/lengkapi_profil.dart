import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guru/features/onboarding/presentation/halamanutama.dart';

class LengkapProfilScreen extends StatefulWidget {
  final String nama;
  final String email;
  final String? photoUrl;

  const LengkapProfilScreen({
    super.key,
    required this.nama,
    required this.email,
    this.photoUrl,
  });

  @override
  State<LengkapProfilScreen> createState() => _LengkapProfilScreenState();
}

class _LengkapProfilScreenState extends State<LengkapProfilScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  final TextEditingController _nipController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.nama);
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'nama': _nameController.text.trim(),
          'email': widget.email,
          'nip': _nipController.text.trim(),
          'no_hp': _phoneController.text.trim(),
          'role': 'guru',
          'photo_url': widget.photoUrl,
          'created_at': FieldValue.serverTimestamp(),
        });

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HalamanUtama()),
          );
        }
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Lengkapi Profil Guru', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: widget.photoUrl != null ? NetworkImage(widget.photoUrl!) : null,
                  child: widget.photoUrl == null ? const Icon(Icons.person, size: 50) : null,
                ),
              ),
              const SizedBox(height: 30),
              const Text('Selamat Datang, Guru!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const Text('Silahkan lengkapi data profesional Anda untuk melanjutkan.', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 30),
              
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap (beserta gelar)',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
                validator: (v) => v!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 20),
              
              TextFormField(
                controller: _nipController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'NIP / ID Guru',
                  prefixIcon: const Icon(Icons.badge_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
                validator: (v) => v!.isEmpty ? 'NIP wajib diisi' : null,
              ),
              const SizedBox(height: 20),
              
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Nomor HP Aktif',
                  prefixIcon: const Icon(Icons.phone_android),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
                validator: (v) => v!.isEmpty ? 'Nomor HP wajib diisi' : null,
              ),
              const SizedBox(height: 40),
              
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('KONFIRMASI & MASUK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
