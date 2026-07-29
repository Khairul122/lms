import 'package:flutter/material.dart';
import 'package:lms/services/api_service.dart';

class InfoProfilScreen extends StatefulWidget {
  const InfoProfilScreen({super.key});

  @override
  State<InfoProfilScreen> createState() => _InfoProfilScreenState();
}

class _InfoProfilScreenState extends State<InfoProfilScreen> {
  bool _isEditing = false;
  bool _isLoading = true;
  bool _isSaving = false;
  String _email = '';

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();
  String _jenisKelamin = 'Laki-laki';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _usernameController.dispose();
    _teleponController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final response = await ApiService.get('/profile');
      if (response is Map && response['success'] == true) {
        final data = response['data'] is Map ? Map<String, dynamic>.from(response['data']) : <String, dynamic>{};
        _namaController.text = (data['name'] ?? '').toString();
        _usernameController.text = (data['name'] ?? '').toString();
        _teleponController.text = (data['phone'] ?? '').toString();
        _jenisKelamin = (data['jenis_kelamin'] ?? 'Laki-laki').toString();
        _email = (data['email'] ?? '').toString();
      }
    } catch (e) {
      debugPrint('Gagal memuat profil: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);

    try {
      final response = await ApiService.put('/profile', {
        'name': _namaController.text.trim(),
        'phone': _teleponController.text.trim(),
        'jenis_kelamin': _jenisKelamin,
      });

      if (response is Map && response['success'] == true) {
        if (mounted) {
          setState(() => _isEditing = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profil berhasil diperbarui')),
          );
        }
      } else {
        final message = (response is Map ? response['message'] : null) ?? 'Gagal memperbarui profil';
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message.toString())));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui profil: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Header
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF42A5F5), Color(0xFF64B5F6)],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('EduSmart', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Title with Back and Edit Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Color(0xFF42A5F5), size: 28),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 15),
                      const Expanded(
                        child: Text('Info Profil', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black)),
                      ),
                      TextButton(
                        onPressed: _isSaving
                            ? null
                            : () {
                                if (_isEditing) {
                                  _saveProfile();
                                } else {
                                  setState(() => _isEditing = true);
                                }
                              },
                        child: _isSaving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF42A5F5)),
                              )
                            : Text(
                                _isEditing ? 'Simpan' : 'Ubah',
                                style: const TextStyle(color: Color(0xFF42A5F5), fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoField('Nama', _namaController, isEditable: _isEditing),
                        const SizedBox(height: 20),
                        _buildInfoField('Nama Pengguna', _usernameController, isEditable: false),
                        const SizedBox(height: 20),
                        _buildGenderField(),
                        const SizedBox(height: 20),
                        _buildInfoField('Nomor Handphone', _teleponController, isEditable: _isEditing, keyboardType: TextInputType.phone),
                        const SizedBox(height: 20),
                        _buildInfoField('Email', TextEditingController(text: _email), isEditable: false),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildInfoField(String label, TextEditingController controller, {bool isEditable = true, TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black)),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: isEditable ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: isEditable ? Colors.white : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: isEditable ? Border.all(color: const Color(0xFF42A5F5)) : null,
          ),
          child: isEditable
              ? TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                  style: const TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w500),
                )
              : Text(controller.text, style: const TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }

  Widget _buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Jenis Kelamin', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black)),
        const SizedBox(height: 10),
        _isEditing
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF42A5F5)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _jenisKelamin,
                    isExpanded: true,
                    items: ['Laki-laki', 'Perempuan'].map((String value) {
                      return DropdownMenuItem<String>(value: value, child: Text(value));
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() => _jenisKelamin = newValue!);
                    },
                  ),
                ),
              )
            : Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
                child: Text(_jenisKelamin, style: const TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w500)),
              ),
      ],
    );
  }
}
