import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lms/fcm_service.dart';

class DetailTugasScreen extends StatefulWidget {
  final String title;
  final String description;
  final String deadline;
  final String? taskId;
  final String? className;
  final int? pertemuan;
  final String? fileUrl;

  const DetailTugasScreen({
    super.key,
    required this.title,
    required this.description,
    required this.deadline,
    this.taskId,
    this.className,
    this.pertemuan,
    this.fileUrl,
  });

  @override
  State<DetailTugasScreen> createState() => _DetailTugasScreenState();
}

class _DetailTugasScreenState extends State<DetailTugasScreen> {
  final List<Map<String, dynamic>> _uploadedFiles = [];
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    _checkSubmissionStatus();
  }

  Future<void> _checkSubmissionStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || widget.taskId == null) return;

    setState(() => _isLoading = true);

    try {
      final doc = await FirebaseFirestore.instance
          .collection('submissions')
          .doc('${user.uid}_${widget.taskId}')
          .get();

      if (doc.exists) {
        setState(() {
          _isSubmitted = true;
          final data = doc.data() as Map<String, dynamic>;
          if (data['files'] != null) {
            _uploadedFiles.clear();
            _uploadedFiles.addAll(List<Map<String, dynamic>>.from(data['files']));
          }
        });
      }
    } catch (e) {
      debugPrint('Error checking submission status: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitTask() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || widget.taskId == null) return;

    setState(() => _isLoading = true);

    try {
      // --- AMBIL NAMA SISWA TERLEBIH DAHULU ---
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final studentName = userDoc.data()?['nama'] ?? 'Siswa';

      await FirebaseFirestore.instance
          .collection('submissions')
          .doc('${user.uid}_${widget.taskId}')
          .set({
        'student_id': user.uid,
        'student_name': studentName, // 🔥 SIMPAN NAMA DISINI
        'task_id': widget.taskId,
        'files': _uploadedFiles,
        'submitted_at': FieldValue.serverTimestamp(),
        'status': 'submitted',
      });

      // --- KIRIM NOTIFIKASI KE GURU ---
      try {
        final taskDoc = await FirebaseFirestore.instance.collection('tasks').doc(widget.taskId).get();
        final taskData = taskDoc.data();
        final classId = taskData?['class_id'];
        final taskTitle = taskData?['title'];

        if (classId != null) {
          debugPrint('🔍 Mencari Guru untuk Class ID: $classId');
          // 2. Cari data kelas untuk mendapatkan teacher_id
          // Coba cari berdasarkan class_code
          var classSnapshot = await FirebaseFirestore.instance
              .collection('classes')
              .where('class_code', isEqualTo: classId)
              .get();
          
          String? teacherId;
          
          if (classSnapshot.docs.isNotEmpty) {
            teacherId = classSnapshot.docs.first.data()['teacher_id'];
            debugPrint('✅ Guru ditemukan via class_code: $teacherId');
          } else {
            // Jika tidak ketemu, coba cari berdasarkan Document ID
            try {
              var classDoc = await FirebaseFirestore.instance.collection('classes').doc(classId).get();
              if (classDoc.exists) {
                teacherId = classDoc.data()?['teacher_id'];
                debugPrint('✅ Guru ditemukan via Doc ID: $teacherId');
              }
            } catch (e) {
              debugPrint('⚠️ Gagal mencari via Doc ID: $e');
            }
          }

          if (teacherId != null) {
            await _sendNotification(teacherId, user, taskTitle, classId);
          } else {
            debugPrint('❌ Guru TIDAK ditemukan. Notifikasi tidak dikirim.');
          }
        }
      } catch (notifError) {
        debugPrint('Gagal mengirim notifikasi ke guru: $notifError');
      }
      // ---------------------------------

      setState(() {
        _isSubmitted = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tugas berhasil dikirim!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim tugas: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _sendNotification(String teacherId, User user, String? taskTitle, String classId) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final studentName = userDoc.data()?['nama'] ?? user.email ?? 'Siswa';

    await FirebaseFirestore.instance.collection('notifications').add({
      'receiver_id': teacherId,
      'email': user.email,
      'title': 'Tugas Baru Dikirim',
      'message': '$studentName telah mengumpulkan tugas "$taskTitle" di kelas ${widget.className}',
      'timestamp': FieldValue.serverTimestamp(),
      'type': 'submission',
      'class_id': classId,
      'student_name': studentName,
    });

    await FCMService.sendNotificationToTeacher(
      teacherId: teacherId,
      studentName: studentName,
      taskTitle: taskTitle ?? 'Tugas',
    );
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );

    if (result != null) {
      setState(() {
        for (var file in result.files) {
          _uploadedFiles.add({
            'name': file.name,
            'type': file.extension?.toLowerCase() == 'pdf' ? 'pdf' : 'file',
          });
        }
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _uploadedFiles.add({
          'name': image.name,
          'type': 'image',
        });
      });
    }
  }

  void _showUploadOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 32),
                    const Text(
                      'Ambil Dari',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 28, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.1,
                  children: [
                    _buildOptionItem(Icons.folder_open, 'File Manager', const Color(0xFF42A5F5), () async {
                      Navigator.pop(context);
                      await _pickFile();
                    }),
                    _buildOptionItem(Icons.camera_alt_outlined, 'Kamera', const Color(0xFF42A5F5), () async {
                      Navigator.pop(context);
                      await _pickImage(ImageSource.camera);
                    }),
                    _buildOptionItem(Icons.file_upload_outlined, 'Download', const Color(0xFF42A5F5), () async {
                      Navigator.pop(context);
                      await _pickFile();
                    }),
                    _buildOptionItem(Icons.image_outlined, 'Gallery', const Color(0xFF42A5F5), () async {
                      Navigator.pop(context);
                      await _pickImage(ImageSource.gallery);
                    }),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionItem(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('EduSmart', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF42A5F5),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: RepaintBoundary(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF42A5F5),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'TUGAS',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF42A5F5),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
                  ),
                  child: Column(
                    children: [
                      Text('Pertemuan ${widget.pertemuan ?? 1}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(widget.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Deadline : ${widget.deadline}', style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w400)),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                        child: Text(widget.description.isEmpty ? 'Tidak ada deskripsi.' : widget.description, style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.6)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              // 🔥 TAMPILAN NILAI (JIKA ADA)
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('submissions')
                    .doc('${FirebaseAuth.instance.currentUser?.uid}_${widget.taskId}')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.exists) {
                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    if (data.containsKey('grade')) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.amber[100],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.amber, width: 2),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 30),
                              const SizedBox(width: 12),
                              Column(
                                children: [
                                  const Text('NILAI ANDA', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.amber)),
                                  Text(
                                    data['grade'] ?? '0',
                                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              const Icon(Icons.star, color: Colors.amber, size: 30),
                            ],
                          ),
                        ),
                      );
                    }
                  }
                  return const SizedBox.shrink();
                },
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF42A5F5),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('File Anda', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                        child: _uploadedFiles.isEmpty 
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30),
                              child: Column(
                                children: [
                                  const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 48),
                                  const SizedBox(height: 12),
                                  const Text('Belum Mengirim Tugas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                                ],
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _uploadedFiles.length,
                              itemBuilder: (context, index) {
                                final file = _uploadedFiles[index];
                                return ListTile(
                                  leading: Icon(
                                    file['type'] == 'pdf' ? Icons.picture_as_pdf : 
                                    file['type'] == 'image' ? Icons.image : Icons.insert_drive_file,
                                    color: const Color(0xFF42A5F5),
                                  ),
                                  title: Text(file['name'] ?? 'File'),
                                  trailing: _isSubmitted ? null : IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => setState(() => _uploadedFiles.removeAt(index)),
                                  ),
                                );
                              },
                            ),
                      ),
                      if (!_isSubmitted) ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _showUploadOptions,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade200,
                              foregroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('+ Tambah File', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              if (!_isSubmitted)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _uploadedFiles.isEmpty ? null : _submitTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF42A5F5),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 3,
                      ),
                      child: const Text('KIRIM TUGAS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
