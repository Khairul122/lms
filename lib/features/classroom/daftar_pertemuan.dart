import 'package:flutter/material.dart';
import 'package:lms/services/api_service.dart';
import 'package:lms/features/classroom/detail_pertemuan.dart';

class DaftarPertemuanScreen extends StatelessWidget {
  final String classCode;
  final String className;

  const DaftarPertemuanScreen({
    super.key,
    required this.classCode,
    required this.className,
  });

  // 🔥 Fungsi mengambil data pertemuan yang SUDAH DIFILTER dari Backend Laravel
  Future<List<dynamic>> _fetchMeetings() async {
    try {
      // 1. Panggil API dengan Query Parameter ?class_code=...
      final response = await ApiService.get("/meetings?class_code=${classCode.trim()}");
      
      if (response != null && response['success'] == true) {
        final List<dynamic> fetchedMeetings = response['data'] ?? [];
        
        // 2. Failsafe Filter Presisi (Hanya mencocokkan kode/nama kelas secara persis/EXACT MATCH)
        final targetCode = classCode.toLowerCase().trim();

        final filtered = fetchedMeetings.where((m) {
          final String mClassCode = (m['class_code'] ?? '').toString().toLowerCase().trim();
          final String mClassId = (m['class_id'] ?? '').toString().toLowerCase().trim();

          // Ambil dari objek relasi jika ada
          String relCode = '';
          if (m['classroom'] != null && m['classroom'] is Map) {
            relCode = (m['classroom']['class_code'] ?? '').toString().toLowerCase().trim();
          } else if (m['kelas'] != null && m['kelas'] is Map) {
            relCode = (m['kelas']['class_code'] ?? '').toString().toLowerCase().trim();
          }

          // Cek kesamaan persis (Exact Match), Hapus 'contains()' agar data tidak bocor
          if (mClassCode.isNotEmpty) {
            return mClassCode == targetCode;
          }
          if (relCode.isNotEmpty) {
            return relCode == targetCode;
          }

          return mClassId == targetCode;
        }).toList();

        // Urutkan pertemuan berdasarkan ID / kolom pertemuan
        filtered.sort((a, b) => (a['pertemuan'] ?? a['id'] ?? 0).compareTo(b['pertemuan'] ?? b['id'] ?? 0));
        return filtered;
      }
    } catch (e) {
      debugPrint("Gagal memuat pertemuan dari server: $e");
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Gradasi Elegan EduSmart
          Container(
            width: double.infinity,
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
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'EduSmart',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Bagian Konten Utama Daftar Pertemuan
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _fetchMeetings(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error API Server: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final meetings = snapshot.data ?? [];
                if (meetings.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.event_busy, size: 70, color: Colors.grey[400]),
                          const SizedBox(height: 12),
                          const Text(
                            'Belum ada pertemuan di kelas ini.',
                            style: TextStyle(
                              fontSize: 16, 
                              color: Colors.grey, 
                              fontWeight: FontWeight.w500
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    children: [
                      const Text(
                        'Daftar Pertemuan',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: meetings.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 20),
                        itemBuilder: (context, index) {
                          final data = meetings[index] as Map<String, dynamic>;
                          final int pertemuanKe = data['pertemuan'] ?? (index + 1);
                          
                          // Mengambil judul nama pertemuan dinamis dari Web Admin Laravel
                          final nama = data['nama_pertemuan'] ?? 'Pertemuan $pertemuanKe';
                          final tema = data['tema_pertemuan'] ?? 'Materi dan Tugas';

                          return _buildPertemuanCard(
                            context,
                            nama,
                            tema,
                            pertemuanKe,
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPertemuanCard(BuildContext context, String title, String subtitle, int pertemuanKe) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF42A5F5),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailPertemuan(
                  classCode: classCode,
                  className: className,
                  pertemuanKe: pertemuanKe,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Lihat Pertemuan',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}