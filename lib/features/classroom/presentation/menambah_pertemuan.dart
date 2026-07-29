import 'package:flutter/material.dart';

import 'package:guru/features/classroom/data/meeting_repository.dart';

class MenambahPertemuan extends StatefulWidget {
  final String classCode;
  final String className;
  const MenambahPertemuan({super.key, required this.classCode, required this.className});

  @override
  State<MenambahPertemuan> createState() => _MenambahPertemuanState();
}

class _MenambahPertemuanState extends State<MenambahPertemuan> {
  final MeetingRepository _meetingRepository = MeetingRepository();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _temaController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _namaController.dispose();
    _temaController.dispose();
    super.dispose();
  }

Future<void> _simpanPertemuan() async {

  if (_namaController.text.trim().isEmpty ||
      _temaController.text.trim().isEmpty) {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Semua kolom harus diisi"),
      ),
    );

    return;
  }

  setState(() {
    _isLoading = true;
  });

  try {

    await _meetingRepository.createMeeting(

      classCode: widget.classCode,

      namaPertemuan: _namaController.text.trim(),

      temaPertemuan: _temaController.text.trim(),

    );

    if (mounted) {

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(

          content: Text("Pertemuan berhasil ditambahkan"),

        ),

      );

      Navigator.pop(context);

    }

  } catch (e) {

    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(

        content: Text(e.toString()),

      ),

    );

  }

  setState(() {

    _isLoading = false;

  });

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Kembali', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A237E),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header Background (Curved)
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
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                child: Column(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            'Tambah Pertemuan',
                            style: TextStyle(
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
                              fontWeight: FontWeight.bold,
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
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nama Pertemuan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _namaController,
                    decoration: InputDecoration(
                      hintText: 'Contoh: Pertemuan 1',
                      filled: true,
                      fillColor: const Color(0xFFE3F2FD),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Tema Pertemuan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _temaController,
                    decoration: InputDecoration(
                      hintText: 'Contoh: Bilangan dan Operasinya',
                      filled: true,
                      fillColor: const Color(0xFFE3F2FD),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _simpanPertemuan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A237E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading 
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Simpan Pertemuan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
