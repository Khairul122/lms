import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lms/services/api_service.dart';

class DetailTugasScreen extends StatefulWidget {
  final String title;
  final String description;
  final String deadline;
  final String? taskId;
  final String? className;
  final int? pertemuan;
  final String? fileUrl;

  const DetailTugasScreen({
    super.key,
    required this.title,
    required this.description,
    required this.deadline,
    this.taskId,
    this.className,
    this.pertemuan,
    this.fileUrl,
  });

  @override
  State<DetailTugasScreen> createState() => _DetailTugasScreenState();
}

class _DetailTugasScreenState extends State<DetailTugasScreen> {
  final List<Map<String, dynamic>> _uploadedFiles = [];
  final TextEditingController _noteController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  bool _isSubmitting = false;
  bool _isSubmitted = false;
  String? _existingFilePath;
  String? _score;
  String? _teacherNote;

  @override
  void initState() {
    super.initState();
    _checkSubmissionStatus();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _checkSubmissionStatus() async {
    if (widget.taskId == null) return;

    setState(() => _isLoading = true);

    try {
      final response = await ApiService.get('/submissions');
      if (response is Map && response['success'] == true) {
        final List<dynamic> allSubs = response['data'] is List ? response['data'] : [];
        final match = allSubs.firstWhere(
          (sub) => sub is Map && sub['task_id'].toString() == widget.taskId.toString(),
          orElse: () => null,
        );

        if (match != null) {
          setState(() {
            _isSubmitted = true;
            _existingFilePath = match['file_path']?.toString();
            _score = match['score']?.toString();
            _teacherNote = match['teacher_note']?.toString();
            if (match['note'] != null) {
              _noteController.text = match['note'].toString();
            }
          });
        }
      }
    } catch (e) {
      debugPrint('Error checking submission status: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _submitTask() async {
    if (widget.taskId == null) return;

    setState(() => _isSubmitting = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload();
      final token = prefs.getString('token');

      final uri = Uri.parse('${ApiService.baseUrl}/submissions');
      final request = http.MultipartRequest('POST', uri);

      request.headers['Accept'] = 'application/json';
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      request.fields['task_id'] = widget.taskId!;
      request.fields['note'] = _noteController.text.trim();

      if (_uploadedFiles.isNotEmpty && _uploadedFiles.first['path'] != null) {
        final path = _uploadedFiles.first['path'] as String;
        request.files.add(await http.MultipartFile.fromPath('file', path));
      }

      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();

      dynamic decoded;
      try {
        decoded = jsonDecode(responseBody);
      } catch (_) {
        decoded = null;
      }

      final bool success = streamedResponse.statusCode >= 200 &&
          streamedResponse.statusCode < 300 &&
          (decoded is Map ? decoded['success'] != false : true);

      if (success) {
        setState(() => _isSubmitted = true);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tugas berhasil dikirim!'), backgroundColor: Colors.green),
          );
        }
        await _checkSubmissionStatus();
      } else {
        final message = (decoded is Map ? decoded['message'] : null) ?? 'Gagal mengirim tugas (${streamedResponse.statusCode})';
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.toString()), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim tugas: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      setState(() {
        _uploadedFiles
          ..clear()
          ..add({
            'name': file.name,
            'type': file.extension?.toLowerCase() == 'pdf' ? 'pdf' : 'file',
            'path': file.path,
          });
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _uploadedFiles
          ..clear()
          ..add({
            'name': image.name,
            'type': 'image',
            'path': image.path,
          });
      });
    }
  }

  void _showUploadOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 32),
                    const Text(
                      'Ambil Dari',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 28, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.1,
                  children: [
                    _buildOptionItem(Icons.folder_open, 'File Manager', const Color(0xFF42A5F5), () async {
                      Navigator.pop(context);
                      await _pickFile();
                    }),
                    _buildOptionItem(Icons.camera_alt_outlined, 'Kamera', const Color(0xFF42A5F5), () async {
                      Navigator.pop(context);
                      await _pickImage(ImageSource.camera);
                    }),
                    _buildOptionItem(Icons.file_upload_outlined, 'Download', const Color(0xFF42A5F5), () async {
                      Navigator.pop(context);
                      await _pickFile();
                    }),
                    _buildOptionItem(Icons.image_outlined, 'Gallery', const Color(0xFF42A5F5), () async {
                      Navigator.pop(context);
                      await _pickImage(ImageSource.gallery);
                    }),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionItem(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('EduSmart', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF42A5F5),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _checkSubmissionStatus,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: RepaintBoundary(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF42A5F5),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'TUGAS',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF42A5F5),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
                  ),
                  child: Column(
                    children: [
                      Text('Pertemuan ${widget.pertemuan ?? 1}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(widget.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Deadline : ${widget.deadline}', style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w400)),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                        child: Text(widget.description.isEmpty ? 'Tidak ada deskripsi.' : widget.description, style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.6)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // 🔥 TAMPILAN NILAI (JIKA ADA)
              if (_score != null && _score != 'null')
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.amber, width: 2),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 30),
                            const SizedBox(width: 12),
                            Column(
                              children: [
                                const Text('NILAI ANDA', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.amber)),
                                Text(
                                  _score ?? '0',
                                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            const Icon(Icons.star, color: Colors.amber, size: 30),
                          ],
                        ),
                        if (_teacherNote != null && _teacherNote!.trim().isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(
                            'Catatan Guru: $_teacherNote',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 13, color: Colors.black87),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF42A5F5),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('File Anda', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                        child: _uploadedFiles.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.symmetric(vertical: 30),
                                child: Column(
                                  children: [
                                    Icon(
                                      _isSubmitted ? Icons.check_circle_outline : Icons.warning_amber_rounded,
                                      color: _isSubmitted ? Colors.green : Colors.red,
                                      size: 48,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      _isSubmitted
                                          ? (_existingFilePath ?? 'Tugas sudah dikumpulkan')
                                          : 'Belum Mengirim Tugas',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _uploadedFiles.length,
                                itemBuilder: (context, index) {
                                  final file = _uploadedFiles[index];
                                  return ListTile(
                                    leading: Icon(
                                      file['type'] == 'pdf'
                                          ? Icons.picture_as_pdf
                                          : file['type'] == 'image'
                                              ? Icons.image
                                              : Icons.insert_drive_file,
                                      color: const Color(0xFF42A5F5),
                                    ),
                                    title: Text(file['name'] ?? 'File'),
                                    trailing: _isSubmitted
                                        ? null
                                        : IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.red),
                                            onPressed: () => setState(() => _uploadedFiles.removeAt(index)),
                                          ),
                                  );
                                },
                              ),
                      ),
                      if (!_isSubmitted) ...[
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                          child: TextField(
                            controller: _noteController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              hintText: 'Catatan untuk guru (opsional)',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _showUploadOptions,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade200,
                              foregroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('+ Tambah File', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              if (!_isSubmitted)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: (_uploadedFiles.isEmpty || _isSubmitting) ? null : _submitTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF42A5F5),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 3,
                      ),
                      child: _isSubmitting
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('KIRIM TUGAS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
