import 'package:flutter/material.dart';
import 'package:lms/core/widgets/app_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lms/features/tasks/presentation/kirimtugas3.dart';

class UploadTugas5Screen extends StatefulWidget {
  final String taskId;
  final String title;
  final String description;
  final String deadline;
  final String className;
  final String? pertemuan;

  const UploadTugas5Screen({
    super.key,
    required this.taskId,
    required this.title,
    required this.description,
    required this.deadline,
    required this.className,
    this.pertemuan,
  });

  @override
  State<UploadTugas5Screen> createState() => _UploadTugas5ScreenState();
}

class _UploadTugas5ScreenState extends State<UploadTugas5Screen> {
  String _siswaNama = "Memuat nama...";

  @override
  void initState() {
    super.initState();
    _loadStudentName();
  }

  // Mengambil nama siswa secara real-time dari memori lokal SharedPreferences
  Future<void> _loadStudentName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _siswaNama = prefs.getString("name") ?? "Siswa EduSmart";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header with blue background
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10,
              bottom: 20,
              left: 20,
              right: 20,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF34B3F7),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 15),
                const Text(
                  'EduSmart',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Title TUGAS
                  const Text(
                    'TUGAS',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 1,
                    ),
                  ),
                  
                  const SizedBox(height: 25),
                  
                  // Card Tugas Dinamis dari Laravel Backend
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF34B3F7),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF34B3F7).withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Nama Pertemuan secara dinamis
                        Text(
                          widget.pertemuan ?? 'Pertemuan Umum',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 5),
                        
                        // Judul Tugas / Nama Pelajaran
                        Text(
                          widget.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Deadline Dinamis
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Deadline : ${widget.deadline}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // White box berisi deskripsi atau petunjuk soal asli dari Laravel
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.description.isNotEmpty 
                                  ? widget.description 
                                  : 'Tidak ada deskripsi atau petunjuk tambahan untuk tugas ini.',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // File Anda title
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        'File Anda',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 15),
                  
                  // Card File Jawaban Siswa
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nama Profil Siswa Hasil Sinkronisasi SharedPreferences
                        Text(
                          _siswaNama,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        
                        const SizedBox(height: 15),
                        
                        Divider(
                          height: 1,
                          color: Colors.grey[300],
                          thickness: 1,
                        ),
                        
                        const SizedBox(height: 15),
                        
                        // Lampiran Berkas Pengumpulan Jawaban
                        Row(
                          children: [
                            const Icon(
                              Icons.picture_as_pdf,
                              color: Colors.red,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Jawaban - ${widget.title}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          
          // Submit Button Section di bagian bawah layar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                // 🔥 Hubungkan ke komponen konfirmasi dialog di kirimtugas3.dart
                KirimTugas3.show(
                  context, 
                  taskId: widget.taskId, 
                  onSuccess: () async {
                    if (mounted) {
                      await AppDialog.showSuccess(context, 'Tugas berhasil diserahkan ke sistem!');
                      if (mounted) Navigator.pop(context);
                    }
                  }
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF34B3F7),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Kirim Tugas',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}