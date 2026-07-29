import 'package:flutter/material.dart';
import 'package:lms/services/api_service.dart';

class LampiranMateri extends StatelessWidget {
  final String classCode;
  final int pertemuanKe;
  final String meetingName;
  final String meetingTopic;

  const LampiranMateri({
    super.key,
    required this.classCode,
    required this.pertemuanKe,
    required this.meetingName,
    required this.meetingTopic,
  });

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
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
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

          // Meeting Info area (White)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            color: Colors.white,
            child: Column(
              children: [
                Text(
                  meetingName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  meetingTopic,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1, thickness: 1, color: Colors.black26),

          // Content area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    'Lampiran',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Label "Pengenalan" (or Dynamic label from material title)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FutureBuilder<List<dynamic>>(
                      future: _fetchMaterials(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        final materials = snapshot.data ?? [];
                        if (materials.isEmpty) {
                          return const Text(
                            'Tidak ada lampiran',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: materials.map((item) {
                            final data = item as Map<String, dynamic>;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 32),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['title'] ?? 'Lampiran',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Center(
                                    child: Container(
                                      width: 260,
                                      height: 180,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE3F2FD),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: data['file_url'] != null
                                            ? Image.network(
                                                data['file_url'],
                                                headers: const {
                                                  'localtonet-skip-warning': 'true',
                                                  'ngrok-skip-browser-warning': 'true',
                                                },
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) => 
                                                  const Center(child: Icon(Icons.description, size: 50, color: Color(0xFF42A5F5))),
                                              )
                                            : const Center(child: Icon(Icons.picture_as_pdf, size: 50, color: Colors.red)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Button
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // Handle offline save
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF42A5F5),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'Simpan semua file secara offline',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<List<dynamic>> _fetchMaterials() async {
    try {
      final response = await ApiService.get('/materials?class_code=$classCode&pertemuan=$pertemuanKe');
      if (response is Map && response['success'] == true && response['data'] is List) {
        return List.from(response['data']);
      }
    } catch (e) {
      debugPrint('Gagal memuat materi: $e');
    }
    return [];
  }
}
