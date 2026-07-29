import 'package:flutter/material.dart';
import 'package:guru/services/api_service.dart';
import 'package:guru/core/services/fcm_service.dart';
import 'package:guru/features/tasks/presentation/berhasil_beri_nilai.dart';

class KasihPeniliaian {
  static void show({
    required BuildContext context,
    required String taskId,
    required String studentId,
    required String taskTitle,
  }) {
    final TextEditingController nilaiController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder( // Gunakan StatefulBuilder untuk menangani loading
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kasih Penilaian',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: nilaiController,
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        enabled: !isLoading,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF1A237E),
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Masukkan nilai (0-100)',
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Masukkan Nilai sesuai Kemampuan Siswa',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : () async {
                          final String grade = nilaiController.text.trim();
                          if (grade.isEmpty) return;

                          setState(() => isLoading = true);

                          try {
                            // 1. Simpan Nilai ke Backend Laravel MySQL via REST API
                            final res = await ApiService.put(
                              '/submissions/${studentId}_$taskId',
                              {
                                'score': grade,
                                'grade': grade,
                                'student_id': studentId,
                                'task_id': taskId,
                                'teacher_note': 'Nilai diberikan oleh Guru',
                              },
                            );

                            if (res != null && res['success'] == true) {
                              // 2. Kirim Notifikasi FCM (Failsafe)
                              try {
                                await FCMService.sendNotificationToStudent(
                                  studentId: studentId,
                                  taskTitle: taskTitle,
                                  grade: grade,
                                );
                              } catch (_) {}

                              if (dialogContext.mounted) {
                                Navigator.of(dialogContext).pop();
                                BerhasilBeriNilai.show(context);
                              }
                            } else {
                              final msg = res?['message'] ?? 'Gagal menyimpan nilai.';
                              if (dialogContext.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(msg)),
                                );
                              }
                            }
                          } catch (e) {
                            debugPrint('❌ Gagal memberi nilai: $e');
                            if (dialogContext.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Gagal menyimpan nilai: $e')),
                              );
                            }
                          } finally {
                            if (dialogContext.mounted) setState(() => isLoading = false);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A237E),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text(
                              'Kirim',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }
}
