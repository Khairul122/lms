import 'package:flutter/material.dart';
import 'package:guru/features/classroom/data/class_repository.dart';

class DaftarMurid extends StatefulWidget {
  final String classCode;

  const DaftarMurid({super.key, required this.classCode});

  @override
  State<DaftarMurid> createState() => _DaftarMuridState();
}

class _DaftarMuridState extends State<DaftarMurid> {
  final ClassRepository _classRepository = ClassRepository();
  bool _isLoading = true;
  Map<String, dynamic>? _classDetail;
  String _teacherName = 'Guru';
  List<dynamic> _students = [];

  @override
  void initState() {
    super.initState();
    _fetchClassDetails();
  }

  Future<void> _fetchClassDetails() async {
    try {
      final classes = await _classRepository.getClasses();
      
      Map<String, dynamic>? targetClass;
      for (var element in classes) {
        if (element is Map && element['class_code'] == widget.classCode) {
          targetClass = Map<String, dynamic>.from(element);
          break;
        }
      }

      if (targetClass != null) {
        final classId = int.tryParse(targetClass['id'].toString());
        Map<String, dynamic> fullDetail = targetClass;
        
        if (classId != null) {
          final detailRes = await _classRepository.getClass(classId);
          if (detailRes.isNotEmpty) {
            fullDetail = detailRes;
          }
        }

        if (mounted) {
          setState(() {
            _classDetail = fullDetail;
            
            // Penanganan teacher secara aman baik berupa String maupun Map/Object
            final teacherVal = fullDetail['teacher_detail'] ?? fullDetail['teacher'];
            if (teacherVal is Map) {
              _teacherName = (teacherVal['name'] ?? 'Guru').toString();
            } else if (teacherVal != null) {
              _teacherName = teacherVal.toString();
            } else {
              _teacherName = 'Guru';
            }

            if (fullDetail['students'] is List) {
              _students = List<dynamic>.from(fullDetail['students']);
            } else {
              _students = [];
            }

            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memuat data anggota: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header with dark blue background
          Container(
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Daftar Anggota',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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

          // Main Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _classDetail == null
                    ? const Center(child: Text('Data kelas tidak ditemukan.'))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Guru Section
                            const Text(
                              'Guru',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A237E),
                              ),
                            ),
                            const SizedBox(height: 12),
                            
                            // Teacher Card
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE3F2FD),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.shade300,
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      size: 40,
                                      color: Color(0xFF1A237E),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _teacherName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1A237E),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Pengajar',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Murid Section
                            const Text(
                              'Murid',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A237E),
                              ),
                            ),
                            const SizedBox(height: 12),
                            
                            // Student List
                            if (_students.isEmpty)
                              const Padding(
                                padding: EdgeInsets.all(16),
                                child: Text('Belum ada murid yang bergabung.'),
                              )
                            else
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _students.length,
                                itemBuilder: (context, index) {
                                  final studentData = _students[index] as Map<String, dynamic>;
                                  final studentName = studentData['name'] ?? 'Siswa';
                                  final className = _classDetail != null ? (_classDetail!['class_name'] ?? 'Kelas') : 'Kelas';
                                  
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE3F2FD),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.05),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey.shade300,
                                          ),
                                          child: const Icon(
                                            Icons.person_outline,
                                            size: 40,
                                            color: Color(0xFF1A237E),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                studentName,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF1A237E),
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                className,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
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