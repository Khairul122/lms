import 'package:flutter/material.dart';
import 'package:lms/services/api_service.dart';
import 'package:lms/features/tasks/presentation/detail_tugas.dart';
import 'package:lms/core/widgets/bottom_nav_bar.dart';
import 'package:lms/app_navigation.dart';

class DaftarTugasScreen extends StatefulWidget {
  final String? classCode; // 💡 Menampung kode kelas jika dibuka dari Detail Kelas

  const DaftarTugasScreen({super.key, this.classCode});

  @override
  State<DaftarTugasScreen> createState() => _DaftarTugasScreenState();
}

class _DaftarTugasScreenState extends State<DaftarTugasScreen> {
  List<dynamic> _unsubmittedTasks = [];
  List<dynamic> _submittedTasks = [];
  final Map<String, dynamic> _submissionData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTasksAndSubmissions();
  }

  Future<void> _fetchTasksAndSubmissions() async {
    try {
      setState(() => _isLoading = true);

      // 🔥 1. Kirim class_code ke API jika parameter classCode tersedia
      String taskUrl = "/tasks";
      if (widget.classCode != null && widget.classCode!.trim().isNotEmpty) {
        taskUrl = "/tasks?class_code=${widget.classCode!.trim()}";
      }

      final taskResponse = await ApiService.get(taskUrl);
      final subResponse = await ApiService.get("/submissions");

      if (taskResponse != null && (taskResponse['success'] == true || taskResponse['status'] == 'success')) {
        final List<dynamic> fetchedTasks = taskResponse['data'] ?? [];
        final List<String> submittedTaskIds = [];

        if (subResponse != null && (subResponse['success'] == true || subResponse['status'] == 'success')) {
          final List<dynamic> allSubs = subResponse['data'] ?? [];
          
          // Petakan submission berdasarkan task_id
          for (var sub in allSubs) {
            final String taskIdStr = sub['task_id'].toString();
            submittedTaskIds.add(taskIdStr);
            _submissionData[taskIdStr] = sub;
          }
        }

        // 🔥 2. Filter Lanjutan Client-Side Presisi (Exact Match)
        List<dynamic> classFilteredTasks = fetchedTasks;
        if (widget.classCode != null && widget.classCode!.trim().isNotEmpty) {
          final String targetCode = widget.classCode!.toLowerCase().trim();

          classFilteredTasks = fetchedTasks.where((task) {
            final String taskClassCode = (task['class_code'] ?? '').toString().toLowerCase().trim();
            
            // Relasi classroom
            String relCode = '';
            if (task['classroom'] != null && task['classroom'] is Map) {
              relCode = (task['classroom']['class_code'] ?? '').toString().toLowerCase().trim();
            }

            if (taskClassCode.isNotEmpty) return taskClassCode == targetCode;
            if (relCode.isNotEmpty) return relCode == targetCode;
            
            return true; // Jika dari backend sudah difilter presisi
          }).toList();
        }

        // 3. Pisahkan tugas berdasarkan status pengerjaan
        if (mounted) {
          setState(() {
            _unsubmittedTasks = classFilteredTasks.where((task) {
              return !submittedTaskIds.contains(task['id'].toString());
            }).toList();

            _submittedTasks = classFilteredTasks.where((task) {
              return submittedTaskIds.contains(task['id'].toString());
            }).toList();
          });
        }
      }
    } catch (e) {
      debugPrint("Gagal memuat modul tugas Laravel: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getTimeRemaining(String? deadlineStr) {
    try {
      if (deadlineStr == null || deadlineStr == "-" || deadlineStr.isEmpty) return "";
      
      DateTime deadlineDate;
      if (deadlineStr.contains('-') && !deadlineStr.contains(' ')) {
        deadlineDate = DateTime.parse(deadlineStr);
      } else {
        final months = {
          'Januari': 1, 'Februari': 2, 'Maret': 3, 'April': 4, 'Mei': 5, 'Juni': 6,
          'Juli': 7, 'Agustus': 8, 'September': 9, 'Oktober': 10, 'November': 11, 'Desember': 12
        };
        final parts = deadlineStr.split(' ');
        if (parts.length == 3) {
          int day = int.parse(parts[0]);
          int month = months[parts[1]] ?? 1;
          int year = int.parse(parts[2]);
          deadlineDate = DateTime(year, month, day);
        } else {
          return "";
        }
      }

      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      Duration difference = deadlineDate.difference(today);
      int daysLeft = difference.inDays;

      if (daysLeft < 0) return "Sudah Lewat";
      if (daysLeft == 0) return "Hari Ini";
      return "$daysLeft Hari Lagi";
    } catch (e) {
      return "";
    }
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
            'Daftar Tugas',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 20),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _fetchTasksAndSubmissions,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        if (_unsubmittedTasks.isNotEmpty) ...[
                          _buildSectionTitle('Tugas Yang Belum Diserahkan'),
                          ..._unsubmittedTasks.map((task) {
                            final data = task as Map<String, dynamic>;
                            final String taskIdStr = data['id'].toString();
                            final String className = data['classroom'] != null ? (data['classroom']['subject'] ?? 'Pelajaran') : 'Pelajaran';
                            return _buildUnsubmittedCard(
                              context,
                              taskIdStr,
                              data['title'] ?? data['nama_tugas'] ?? 'Tugas',
                              className,
                              data['deadline'] ?? '-',
                              data,
                            );
                          }),
                          const SizedBox(height: 20),
                        ],
                        
                        if (_submittedTasks.isNotEmpty) ...[
                          _buildSectionTitle('Tugas Yang Telah Diserahkan'),
                          ..._submittedTasks.map((task) {
                            final data = task as Map<String, dynamic>;
                            final String taskIdStr = data['id'].toString();
                            final sub = _submissionData[taskIdStr];
                            final String className = data['classroom'] != null ? (data['classroom']['subject'] ?? 'Pelajaran') : 'Pelajaran';
                            return _buildSubmittedCard(
                              taskIdStr,
                              data['title'] ?? data['nama_tugas'] ?? 'Tugas',
                              className,
                              data['deadline'] ?? '-',
                              sub?['grade']?.toString(),
                            );
                          }),
                        ],
                        if (_unsubmittedTasks.isEmpty && _submittedTasks.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 50),
                              child: Text(
                                'Belum ada tugas tersedia untuk kelas Anda.',
                                style: TextStyle(fontSize: 15, color: Colors.grey),
                              ),
                            ),
                          ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 2,
        onTabSelected: (index) => AppNavigation.goToTab(context, index),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget _buildUnsubmittedCard(BuildContext context, String taskId, String title, String subject, String deadline, Map<String, dynamic> taskData) {
    final String timeRemaining = _getTimeRemaining(deadline);
    final bool isUrgent = timeRemaining.contains("Hari Lagi") || timeRemaining == "Hari Ini";

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(subject, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (timeRemaining.isNotEmpty)
                Flexible(
                  flex: 2,
                  child: Row(
                    children: [
                      Icon(
                        isUrgent ? Icons.warning_amber_rounded : Icons.info_outline,
                        color: isUrgent ? Colors.red : Colors.blue,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          timeRemaining,
                          style: TextStyle(color: isUrgent ? Colors.red : Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(Icons.calendar_month_outlined, size: 20),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tenggat : $deadline', style: const TextStyle(fontSize: 9), overflow: TextOverflow.ellipsis),
                          if (timeRemaining.isNotEmpty)
                            Text('Sisa : $timeRemaining', style: const TextStyle(fontSize: 9), overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 15),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailTugasScreen(
                      title: title,
                      description: taskData['description'] ?? '',
                      deadline: deadline,
                      className: subject,
                      taskId: taskId,
                      fileUrl: taskData['file_url'],
                      pertemuan: taskData['pertemuan'],
                    ),
                  ),
                ).then((_) => _fetchTasksAndSubmissions());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4FC3F7),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 4,
              ),
              child: const Text('Mulai Mengerjakan', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSubmittedCard(String taskId, String title, String subject, String date, String? grade) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(subject, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          Text(date, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          const SizedBox(height: 10),
          if (grade != null && grade != "null") ...[
            Align(
              alignment: Alignment.centerRight,
              child: Text('$grade/100', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
            ),
          ] else ...[
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(color: const Color(0xFFFFF176), borderRadius: BorderRadius.circular(10)),
                child: const Text('Menunggu Nilai', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF43A047),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ]
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, color: Colors.white),
                SizedBox(width: 8),
                Text('Telah Diserahkan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
    );
  }

}