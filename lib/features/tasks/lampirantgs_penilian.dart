import 'package:flutter/material.dart';
import 'package:guru/services/api_service.dart';
import 'package:guru/features/tasks/kasih_peniliaian.dart';

class LampiranTgsPenilian extends StatefulWidget {
  final String classCode;
  final int pertemuanKe;
  final String taskId;
  final String taskTitle;
  final String studentId;
  final String studentName;

  const LampiranTgsPenilian({
    super.key,
    required this.classCode,
    required this.pertemuanKe,
    required this.taskId,
    required this.taskTitle,
    required this.studentId,
    required this.studentName,
  });

  @override
  State<LampiranTgsPenilian> createState() => _LampiranTgsPenilianState();
}

class _LampiranTgsPenilianState extends State<LampiranTgsPenilian> {
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
                  'Penilaian Siswa',
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.studentName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tugas: ${widget.taskTitle}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
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
                        final tId = (sub['task_id'] ?? (sub['task'] != null ? sub['task']['id'] : null)).toString();
                        final sId = (sub['user_id'] ?? sub['student_id'] ?? '').toString();
                        return tId == widget.taskId.toString() && (sId == widget.studentId.toString() || sId.isEmpty);
                      }).toList();

                      if (submissions.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.file_copy_outlined, size: 80, color: Colors.grey.shade300),
                              const SizedBox(height: 16),
                              const Text(
                                'Tidak ada file lampiran',
                                style: TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                            ],
                          ),
                        );
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: submissions.length,
                        itemBuilder: (context, index) {
                          final data = submissions[index] as Map<String, dynamic>;
                          return _buildFileCard(data);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Bottom Button
          Padding(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder<dynamic>(
              future: ApiService.get('/submissions'),
              builder: (context, submissionSnapshot) {
                String buttonText = 'Beri Nilai';
                if (submissionSnapshot.hasData) {
                  final response = submissionSnapshot.data;
                  if (response != null && response['success'] == true) {
                    final List<dynamic> subs = response['data'] ?? [];
                    for (var s in subs) {
                      final tId = (s['task_id'] ?? (s['task'] != null ? s['task']['id'] : null)).toString();
                      if (tId == widget.taskId.toString() && s['score'] != null) {
                        buttonText = 'Ganti Nilai (${s['score']})';
                        break;
                      }
                    }
                  }
                }

                return SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      KasihPeniliaian.show(
                        context: context,
                        taskId: widget.taskId,
                        studentId: widget.studentId,
                        taskTitle: widget.taskTitle,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A237E),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileCard(Map<String, dynamic> data) {
    final String fileName = data['file_name'] ?? 'Tugas_Siswa';
    final String fileType = data['file_type'] ?? 'image';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF1A237E).withOpacity(0.1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: fileType == 'pdf'
                  ? const Center(child: Icon(Icons.picture_as_pdf, size: 50, color: Colors.red))
                  : (data['file_url'] != null
                      ? Image.network(
                          data['file_url'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(child: Icon(Icons.image, size: 50, color: Color(0xFF1A237E)));
                          },
                        )
                      : const Center(child: Icon(Icons.image, size: 50, color: Color(0xFF1A237E)))),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          fileName,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
