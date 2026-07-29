import 'package:flutter/material.dart';
import 'package:guru/core/widgets/app_dialog.dart';
import 'package:guru/services/api_service.dart';

class UbahSandi extends StatefulWidget {
  const UbahSandi({super.key});

  @override
  State<UbahSandi> createState() => _UbahSandiState();
}

class _UbahSandiState extends State<UbahSandi> {
  final TextEditingController _sandiLamaController = TextEditingController();
  final TextEditingController _sandiBaruController = TextEditingController();
  final TextEditingController _konfirmasiSandiController = TextEditingController();
  bool _lihatKataSandi = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _sandiLamaController.dispose();
    _sandiBaruController.dispose();
    _konfirmasiSandiController.dispose();
    super.dispose();
  }

  Future<void> _handleSimpan() async {
    final sandiLama = _sandiLamaController.text.trim();
    final sandiBaru = _sandiBaruController.text.trim();
    final konfirmasiSandi = _konfirmasiSandiController.text.trim();

    if (sandiLama.isEmpty || sandiBaru.isEmpty || konfirmasiSandi.isEmpty) {
      AppDialog.showError(context, 'Semua field harus diisi');
      return;
    }

    if (sandiBaru != konfirmasiSandi) {
      AppDialog.showError(context, 'Konfirmasi kata sandi tidak cocok');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await ApiService.post("/change-password", {
        "current_password": sandiLama,
        "new_password": sandiBaru,
      });

      if (response is Map && response["success"] == true) {
        if (mounted) {
          await AppDialog.showSuccess(context, 'Kata sandi berhasil diubah');
          if (mounted) Navigator.pop(context);
        }
      } else {
        final message = (response is Map ? response["message"] : null) ?? "Gagal mengubah kata sandi.";
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
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF1A237E),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    const SizedBox(height: 16),
                    const Text('Ubah Kata Sandi', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildField('Kata Sandi Saat Ini', _sandiLamaController, true),
                        const SizedBox(height: 24),
                        _buildField('Kata Sandi Baru', _sandiBaruController, true),
                        const SizedBox(height: 24),
                        _buildField('Konfirmasi Kata Sandi Baru', _konfirmasiSandiController, true),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Checkbox(value: _lihatKataSandi, onChanged: (v) => setState(() => _lihatKataSandi = v ?? false), activeColor: const Color(0xFF1A237E)),
                            const Text('Lihat kata sandi', style: TextStyle(fontSize: 14, color: Color(0xFF1A237E))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSimpan,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A237E), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 2),
                child: _isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Simpan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, bool isPassword) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !_lihatKataSandi,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF1A237E), fontSize: 14),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF1A237E), width: 1)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF1A237E), width: 2)),
      ),
    );
  }
}
