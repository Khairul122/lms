import 'package:flutter/material.dart';
import 'package:lms/services/api_service.dart';
import 'package:lms/features/tasks/daftar_tugas.dart';
import 'package:lms/features/profile/profil.dart';
import 'package:lms/features/classroom/detail_kelas.dart';
import 'package:lms/features/onboarding/homepage.dart';

class DaftarKelasScreen extends StatefulWidget {
  const DaftarKelasScreen({super.key});

  @override
  State<DaftarKelasScreen> createState() => _DaftarKelasScreenState();
}

class _DaftarKelasScreenState extends State<DaftarKelasScreen> {
  Future<List<dynamic>> _fetchClasses() async {
    final response = await ApiService.get("/classes");
    if (response != null && response['success'] == true) {
      return response['data'] ?? [];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF38B0FE),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'EduSmart',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),  
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            'Daftar Kelas',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),

          // List of Classes dari API Laravel
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _fetchClasses(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Belum ada kelas yang diikuti'));
                }

                final classes = snapshot.data!;

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  itemCount: classes.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    final data = classes[index] as Map<String, dynamic>;
                    
                    final imageNumber = (index % 4) + 1;
                    final imagePath = 'assets/images/gambar$imageNumber.png';
                    
                    final bgColors = [
                      const Color(0xFF5A8F9E),
                      const Color(0xFFE8A87C),
                      const Color(0xFF6B8E9E),
                      const Color(0xFF7B1FA2),
                    ];
                    
                    return _buildKelasCard(
                      context,
                      data['subject']?.toUpperCase() ?? 'PELAJARAN',
                      data['class_name'] ?? 'Kelas',
                      bgColors[index % bgColors.length],
                      imagePath,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailKelasScreen(
                              classCode: data['class_code'] ?? '',
                              className: data['class_name'] ?? 'Kelas',
                              subject: data['subject']?.toUpperCase() ?? 'PELAJARAN',
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildKelasCard(BuildContext context, String subject, String className, Color bgColor, String imagePath, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    // 🔥 Perbaikan: Menggunakan nama properti berhuruf kecil
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          className,
                          style: TextStyle(fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        subject,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  color: bgColor,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.class_outlined, size: 60, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF38B0FE),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home_outlined, color: Colors.white, size: 28),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const homepage())),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.co_present, color: Color(0xFF38B0FE), size: 24),
                SizedBox(width: 8),
                Text(
                  'Kelas',
                  style: TextStyle(
                    color: Color(0xFF38B0FE),
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.pending_actions_outlined, color: Colors.white, size: 28),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DaftarTugasScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white, size: 28),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfilScreen())),
          ),
        ],
      ),
    );
  }
}