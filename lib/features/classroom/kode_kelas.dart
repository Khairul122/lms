import 'package:flutter/material.dart';
import 'package:lms/services/api_service.dart'; // Pastikan path ApiService sudah benar

class KodeKelasDialog extends StatefulWidget {
  const KodeKelasDialog({super.key});

  @override
  State<KodeKelasDialog> createState() => _KodeKelasDialogState();
}

class _KodeKelasDialogState extends State<KodeKelasDialog> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _handleJoinClass() async {
    final String classCode = _codeController.text.trim();

    // Validasi input jika kosong
    if (classCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silahkan masukkan kode kelas terlebih dahulu!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      debugPrint("🚀 [DEBUG] Mengirim kode kelas: $classCode ke ApiService...");

      // Memanggil endpoint Laravel /api/classes/join
      final response = await ApiService.post('/classes/join', {
        'class_code': classCode,
      });

      debugPrint("📩 [DEBUG] Response dari Server: $response");

      if (!mounted) return;

      // Cek apakah response berhasil
      if (response is Map && response['success'] == true) {
        final String message = response['message'] ?? 'Berhasil bergabung ke kelas!';
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.green,
          ),
        );

        // Tutup dialog dan beri sinyal 'true' ke beranda untuk auto-refresh
        Navigator.of(context).pop(true);
      } else {
        // Jika response mengembalikan pesan gagal/error dari backend
        final String errorMsg = (response is Map && response.containsKey('message'))
            ? response['message']
            : 'Gagal bergabung ke kelas';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint("❌ [DEBUG] Error saat join kelas: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // 🛑 DILAKUKAN SELALU: Mematikan animasi loading mutar-mutar
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Silahkan Masukkan\nKode Kelas',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Input Field Kode Kelas
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF00A3E9),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: TextField(
                controller: _codeController,
                textCapitalization: TextCapitalization.characters,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'KODE KELAS',
                  hintStyle: TextStyle(
                    color: Colors.white60,
                    fontSize: 16,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            const Text(
              'Note : Mintalah Kode Kelas\nKepada Pengajar',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),

            // Tombol Tambah / Loading Indicator
            SizedBox(
              width: 120,
              height: 42,
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        debugPrint("👉 [DEBUG] Tombol Tambah Ditekan!");
                        _handleJoinClass();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF42A5F5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text(
                        'Tambah',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper function untuk memanggil dialog ini dari file lain (seperti homepage.dart)
Future<bool?> showKodeKelasDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) => const KodeKelasDialog(),
  );
}