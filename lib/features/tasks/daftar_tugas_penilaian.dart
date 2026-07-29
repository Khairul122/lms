import 'package:flutter/material.dart';
import 'package:guru/services/api_service.dart';
import 'package:guru/features/tasks/daftar_siswa_mengumpulkan.dart';

class DaftarTugasPenilaian extends StatefulWidget {
  final String classCode;
  final String className;
  final int pertemuanKe;
  final String meetingId;
  final String meetingName;

  const DaftarTugasPenilaian({
    super.key,
    required this.classCode,
    required this.className,
    required this.pertemuanKe,
    required this.meetingId,
    required this.meetingName,
  });

  @override
  State<DaftarTugasPenilaian> createState() => _DaftarTugasPenilaianState();
}

class _DaftarTugasPenilaianState extends State<DaftarTugasPenilaian> {
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
                            'Penilaian',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.className} - ${widget.meetingName}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main Content Area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pilih Tugas untuk Dinilai',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  FutureBuilder<dynamic>(
                    future: ApiService.get('/tasks?class_code=${widget.classCode}'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final response = snapshot.data;
                      final List<dynamic> rawTasks = (response != null && response['success'] == true)
                          ? (response['data'] ?? [])
                          : [];

                      if (rawTasks.isEmpty) {
                        return const Center(child: Text('Belum ada tugas di pertemuan ini.'));
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: rawTasks.length,
                        itemBuilder: (context, index) {
                          final data = rawTasks[index] as Map<String, dynamic>;
                          final taskId = data['id'].toString();
                          final taskTitle = data['title'] ?? 'Tugas ${index + 1}';
                          
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DaftarSiswaMengumpulkan(
                                    classCode: widget.classCode,
                                    pertemuanKe: widget.pertemuanKe,
                                    taskId: taskId,
                                    taskTitle: taskTitle,
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
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      data['title'] ?? 'Tugas',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1A237E),
                                      ),
                                    ),
                                    if ((data['description'] ?? '').isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        data['description'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1A237E),
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
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
    );
  }
}
