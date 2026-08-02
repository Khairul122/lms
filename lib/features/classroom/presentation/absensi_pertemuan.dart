import 'package:flutter/material.dart';
import 'package:guru/services/api_service.dart';

class AbsensiPertemuan extends StatefulWidget {
  final String classCode;
  final String className;
  final int pertemuanKe;

  const AbsensiPertemuan({
    super.key,
    required this.classCode,
    required this.className,
    required this.pertemuanKe,
  });

  @override
  State<AbsensiPertemuan> createState() => _AbsensiPertemuanState();
}

const _statusOptions = ['hadir', 'izin', 'sakit', 'alpa'];

class _AbsensiPertemuanState extends State<AbsensiPertemuan> {
  List<dynamic> _students = [];
  final Map<int, String?> _selectedStatus = {};
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);

    try {
      final res = await ApiService.get(
        "/attendances?class_code=${widget.classCode}&pertemuan=${widget.pertemuanKe}",
      );

      if (res is Map && res['success'] == true && res['data'] is List) {
        _students = res['data'];
        _selectedStatus.clear();
        for (final s in _students) {
          _selectedStatus[s['user_id']] = s['status'];
        }
      } else {
        _students = [];
      }
    } catch (e) {
      debugPrint("FETCH ABSENSI ERROR: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveAttendance() async {
    setState(() => _isSaving = true);

    try {
      final records = _selectedStatus.entries
          .where((e) => e.value != null)
          .map((e) => {'user_id': e.key, 'status': e.value})
          .toList();

      final res = await ApiService.post('/attendances', {
        'class_code': widget.classCode,
        'pertemuan': widget.pertemuanKe,
        'records': records,
      });

      if (!mounted) return;

      if (res is Map && res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Absensi berhasil disimpan')),
        );
      } else {
        final msg = (res is Map ? res['message'] : null) ?? 'Gagal menyimpan absensi';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Absensi', style: TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: const Color(0xFF1A237E),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchData,
              child: _students.isEmpty
                  ? ListView(
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(32),
                          child: Text(
                            'Belum ada siswa yang bergabung di kelas ini.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _students.length,
                      itemBuilder: (context, index) {
                        final s = _students[index];
                        final userId = s['user_id'] as int;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F2FD),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  s['student_name'] ?? 'Siswa',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A237E),
                                  ),
                                ),
                              ),
                              DropdownButton<String>(
                                value: _selectedStatus[userId],
                                hint: const Text('Pilih'),
                                items: _statusOptions
                                    .map((status) => DropdownMenuItem(
                                          value: status,
                                          child: Text(status),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() => _selectedStatus[userId] = value);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
      bottomNavigationBar: _students.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveAttendance,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : const Text('Simpan Absensi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
    );
  }
}
