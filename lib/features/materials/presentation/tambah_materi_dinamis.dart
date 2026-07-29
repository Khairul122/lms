import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:guru/services/api_service.dart';
import 'package:guru/core/widgets/file_source_dialog.dart';

class TambahMateriDinamis extends StatefulWidget {
  final String classCode;
  final String className;
  final int pertemuanKe;

  const TambahMateriDinamis({
    super.key,
    required this.classCode,
    required this.className,
    required this.pertemuanKe,
  });

  @override
  State<TambahMateriDinamis> createState() => _TambahMateriDinamisState();
}

class _TambahMateriDinamisState extends State<TambahMateriDinamis> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  List<Map<String, dynamic>> _selectedFiles = [];
  bool _isLoading = false;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );

    if (result != null) {
      setState(() {
        for (var file in result.files) {
          if (file.path != null) {
            _selectedFiles.add({
              'name': file.name,
              'path': file.path,
              'type': file.extension?.toLowerCase() ?? 'file',
            });
          }
        }
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _selectedFiles.add({
            'name': image.name,
            'path': image.path,
            'type': 'image',
          });
        });
      }
    } catch (e) {
      debugPrint("❌ Error Image Picker: $e");
    }
  }

  /// PROSES SIMPAN MATERI KE LARAVEL REST API
  Future<void> _saveMateri() async {
    if (_judulController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi judul materi')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Susun payload JSON data materi
      final Map<String, dynamic> body = {
        'class_code': widget.classCode,
        'meeting_number': widget.pertemuanKe,
        'title': _judulController.text.trim(),
        'description': _deskripsiController.text.trim(),
        // Kirim list lampiran file
        'files': _selectedFiles.map((f) => {
          'name': f['name'],
          'type': f['type'],
          'path': f['path'], // atau URL jika sudah diunggah
        }).toList(),
      };

      // 2. Tembak REST API Laravel
      final response = await ApiService.post('/materials', body);

      if (response != null && (response['success'] == true || response['data'] != null)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Materi berhasil diunggah!')),
          );
          Navigator.pop(context, true); // Kembali & trigger refresh data
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response?['message'] ?? 'Gagal menyimpan materi ke server')),
          );
        }
      }
    } catch (e) {
      debugPrint("❌ Error Save Materi: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header dengan background biru tua
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back Button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Row(
                        children: [
                          Icon(Icons.arrow_back, color: Colors.white, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Kembali',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Title Header
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Pertemuan ${widget.pertemuanKe}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.className,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                  const Center(
                    child: Text(
                      'Tambah Materi',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Judul Materi
                  const Text(
                    'Judul Materi:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _judulController,
                      decoration: const InputDecoration(
                        hintText: 'Masukkan Judul Materi',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Deskripsi
                  const Text(
                    'Deskripsi:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _deskripsiController,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        hintText: 'Masukkan Deskripsi Secara Lengkap',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tambah Lampiran Section
                  const Text(
                    'Tambah Lampiran:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // List File yang Dipilih
                  if (_selectedFiles.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _selectedFiles.length,
                        itemBuilder: (context, index) {
                          final file = _selectedFiles[index];
                          IconData icon;
                          Color iconColor;

                          switch (file['type']) {
                            case 'pdf':
                              icon = Icons.picture_as_pdf;
                              iconColor = Colors.red;
                              break;
                            case 'ppt':
                            case 'pptx':
                              icon = Icons.slideshow;
                              iconColor = Colors.orange;
                              break;
                            case 'image':
                              icon = Icons.image;
                              iconColor = Colors.blue;
                              break;
                            default:
                              icon = Icons.insert_drive_file;
                              iconColor = Colors.grey;
                          }

                          return ListTile(
                            leading: Icon(icon, color: iconColor),
                            title: Text(
                              file['name'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _selectedFiles.removeAt(index);
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),

                  // Tombol Masukkan File
                  GestureDetector(
                    onTap: () async {
                      final source = await FileSourceDialog.show(context);
                      if (source == null) return;

                      if (source == 'camera') {
                        await _pickImage(ImageSource.camera);
                      } else if (source == 'gallery') {
                        await _pickImage(ImageSource.gallery);
                      } else if (source == 'file_manager' || source == 'download') {
                        await _pickFile();
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: Color(0xFF1A237E), size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Masukkan File',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A237E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // Bottom Button "Simpan"
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveMateri,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        'Simpan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}