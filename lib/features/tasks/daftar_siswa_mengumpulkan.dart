import 'package:flutter/material.dart';
import 'package:guru/services/api_service.dart';
import 'package:guru/features/tasks/lampirantgs_penilian.dart';

class DaftarSiswaMengumpulkan extends StatefulWidget {
  final String classCode;
  final int pertemuanKe;
  final String taskId;
  final String taskTitle;

  const DaftarSiswaMengumpulkan({
    super.key,
    required this.classCode,
    required this.pertemuanKe,
    required this.taskId,
    required this.taskTitle,
  });

  @override
  State<DaftarSiswaMengumpulkan> createState() => _DaftarSiswaMengumpulkanState();
}

class _DaftarSiswaMengumpulkanState extends State<DaftarSiswaMengumpulkan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Kembali', style: TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: const Color(0xFF1A237E),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header
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
              child: const Center(
                child: Text(
                  'Daftar Pengumpulan',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.taskTitle,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Pilih siswa untuk melihat tugas dan memberi nilai',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: FutureBuilder<dynamic>(
                    future: ApiService.get('/submissions'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final response = snapshot.data;
                      final List<dynamic> rawSubmissions = (response != null && response['success'] == true)
                          ? (response['data'] ?? [])
                          : [];

                      final submissions = rawSubmissions.where((sub) {
                        final tId = sub['task_id'] ?? (sub['task'] != null ? sub['task']['id'] : null);
                        return tId.toString() == widget.taskId.toString();
                      }).toList();

                      if (submissions.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.people_outline, size: 80, color: Colors.grey.shade300),
                              const SizedBox(height: 16),
                              const Text(
                                'Belum ada siswa yang mengumpulkan',
                                style: TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: submissions.length,
                        itemBuilder: (context, index) {
                          final data = submissions[index] as Map<String, dynamic>;
                          final studentId = (data['user_id'] ?? data['student_id'] ?? 1).toString();
                          final studentName = data['student'] ?? data['student_name'] ?? 'Siswa';

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LampiranTgsPenilian(
                                    classCode: widget.classCode,
                                    pertemuanKe: widget.pertemuanKe,
                                    taskId: widget.taskId,
                                    taskTitle: widget.taskTitle,
                                    studentId: studentId,
                                    studentName: studentName,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE3F2FD),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: const Color(0xFF1A237E),
                                    child: Text(
                                      studentName.isNotEmpty ? studentName[0].toUpperCase() : 'S',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      studentName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1A237E),
                                      ),
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right, color: Color(0xFF1A237E)),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
