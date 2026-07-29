import 'package:flutter/material.dart';
import 'package:guru/features/tasks/data/task_repository.dart';

class TambahTugasDinamis extends StatefulWidget {
  final String classCode;
  final String className;
  final int pertemuanKe;

  const TambahTugasDinamis({
    super.key,
    required this.classCode,
    required this.className,
    required this.pertemuanKe,
  });

  @override
  State<TambahTugasDinamis> createState() => _TambahTugasDinamisState();
}

class _TambahTugasDinamisState extends State<TambahTugasDinamis> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();

  final TaskRepository _repository = TaskRepository();
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _deadlineController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _saveTugas() async {
    if (_judulController.text.isEmpty || _deadlineController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi judul dan deadline tugas')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final payload = {
        'class_code': widget.classCode,
        'meeting_number': widget.pertemuanKe,
        'title': _judulController.text.trim(),
        'description': _deskripsiController.text.trim(),
        'deadline': _deadlineController.text,
      };

      debugPrint("Sending Payload to Laravel: $payload");

      // 1. Simpan Ke Laravel API
      final response = await _repository.createTask(payload);
      debugPrint("Response Laravel: $response");

      if (!mounted) return;

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tugas berhasil disimpan')),
      );
    } catch (e) {
      debugPrint("Error POST Task: $e");
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    _deadlineController.dispose();
    super.dispose();
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
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Row(
                        children: [
                          Icon(Icons.arrow_back, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Kembali',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Tambah Tugas - P${widget.pertemuanKe}',
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    Text(widget.className,
                        style: const TextStyle(
                            fontSize: 16, color: Colors.white70)),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Judul Tugas'),
                  _buildTextField(_judulController, 'Masukkan Judul Tugas'),
                  const SizedBox(height: 20),
                  _buildLabel('Batas Waktu (Deadline)'),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: _buildTextField(
                        _deadlineController,
                        'Pilih Tanggal Batas Waktu',
                        icon: Icons.calendar_today,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildLabel('Deskripsi'),
                  _buildTextField(
                    _deskripsiController,
                    'Masukkan Deskripsi Lengkap',
                    maxLines: 5,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveTugas,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Simpan Tugas',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(label,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A237E))),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {IconData? icon, int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon:
              icon != null ? Icon(icon, color: const Color(0xFF1A237E)) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
} 