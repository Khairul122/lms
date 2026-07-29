import 'package:flutter/material.dart';
import 'package:guru/repositories/class_repository.dart';
import 'package:guru/widgets/bottom_nav_bar.dart';
import 'package:guru/features/tasks/daftar_pertemuan_penilaian.dart';

class Penilaian extends StatefulWidget {
  const Penilaian({super.key});

  @override
  State<Penilaian> createState() => _PenilaianState();
}

class _PenilaianState extends State<Penilaian> {
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
            child: const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: Center(
                child: Text(
                  'Penilaian',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          // Main Content Area
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // "Pilih Kelas" Title
                  const Text(
                    'Pilih Kelas',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  FutureBuilder<List<dynamic>>(
                    future: _classRepository.getClasses(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('Belum ada kelas yang dibuat'));
                      }

                      final classes = snapshot.data!;

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: classes.length,
                        itemBuilder: (context, index) {
                          final data = classes[index] as Map<String, dynamic>;
                          return _buildClassCard(context, data);
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
      bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 2),
    );
  }

  Widget _buildClassCard(BuildContext context, Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DaftarPertemuanPenilaian(
              classCode: data['class_code'] ?? '',
              className: '${data['subject'] ?? 'Pelajaran'} - ${data['class_name'] ?? 'Kelas'}',
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A237E),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Text Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['subject'] ?? 'Matematika',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data['class_name'] ?? 'Kelas XI IPA',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Illustration
            Image.asset(
              'assets/kelas.png',
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}