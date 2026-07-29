import 'package:flutter/material.dart';
import 'package:guru/features/classroom/data/class_repository.dart';
import 'package:guru/features/classroom/presentation/tambah_pertemuan.dart';
import 'package:guru/features/classroom/presentation/daftarmurid.dart';
import 'package:guru/features/classroom/presentation/buatkelas.dart';
import 'package:guru/widgets/bottom_nav_bar.dart';
import 'package:guru/features/discussions/presentation/tambahkomentar.dart';

class DaftarKelas extends StatefulWidget {
  const DaftarKelas({super.key});

  @override
  State<DaftarKelas> createState() => _DaftarKelasState();
}

class _DaftarKelasState extends State<DaftarKelas> {
  final ClassRepository _classRepository = ClassRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF1A237E),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header with dark blue background
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF1A237E),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title "Daftar Kelas"
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Daftar Kelas',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Heading "Kelas Anda"
                  const Text(
                    'Kelas Anda',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                  ),

                  // =========================
                  // Class List
                  // =========================
                  FutureBuilder<List<dynamic>>(
                    future: _classRepository.getClasses(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            snapshot.error.toString(),
                          ),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 100),
                          child: Center(
                            child: Text(
                              'Belum ada kelas yang dibuat',
                            ),
                          ),
                        );
                      }

                      final classes = snapshot.data!;

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: classes.length,
                        itemBuilder: (context, index) {
                          final data = classes[index];
                          return _buildClassCard(Map<String, dynamic>.from(data));
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        selectedIndex: 1,
      ),
    );
  }

  Widget _buildClassCard(Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TambahPertemuan(
              classCode: data['class_code'] ?? '',
              className: '${data['subject'] ?? 'Pelajaran'} - ${data['class_name'] ?? 'Kelas'}',
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFE3F2FD),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data['subject'] ?? 'Matematika',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data['class_name'] ?? 'Kelas XI IPA',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A237E),
                  ),
                ),
                const SizedBox(height: 12),
                // Daftar Murid button and Info icon
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DaftarMurid(classCode: data['class_code'] ?? ''),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A237E),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Daftar Murid',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TambahKomentar(
                              classCode: data['class_code'] ?? '',
                              className: data['subject'] ?? 'Pelajaran',
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Diskusi',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Info Icon
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BuatKelas(classCode: data['class_code'] ?? ''),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.info_outline,
                        color: Color(0xFF1A237E),
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Illustration di kanan
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Center(
                child: Image.asset(
                  'assets/kelas.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}