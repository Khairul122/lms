import 'package:flutter/material.dart';
import 'package:guru/features/classroom/hapus_pertemuan.dart';
import 'package:guru/features/classroom/menambah_pertemuan.dart';
import 'package:guru/features/classroom/detail_pertemuan.dart';
import 'package:guru/repositories/meeting_repository.dart';

class TambahPertemuan extends StatefulWidget {
  final String classCode;
  final String className;

  const TambahPertemuan({
    super.key,
    required this.classCode,
    required this.className,
  });

  @override
  State<TambahPertemuan> createState() => _TambahPertemuanState();
}

class _TambahPertemuanState extends State<TambahPertemuan> {
  final MeetingRepository _meetingRepository = MeetingRepository();

  Future<void> _deleteMeeting(int meetingId) async {
    try {
      await _meetingRepository.deleteMeeting(meetingId);
      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pertemuan berhasil dihapus")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menghapus pertemuan: $e")),
        );
      }
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
                            'Daftar Pertemuan',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.className,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // "Tambah Pertemuan" Button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MenambahPertemuan(
                        classCode: widget.classCode,
                        className: widget.className,
                      ),
                    ),
                  );
                  if (result == true || result == null) {
                    setState(() {});
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Tambah Pertemuan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main Content Area - List of Meetings
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _meetingRepository.getMeetings(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum ada pertemuan ditambahkan.',
                    ),
                  );
                }

                final meetings = snapshot.data!
                    .where((meeting) => meeting['class_code'] == widget.classCode)
                    .toList();

                if (meetings.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum ada pertemuan ditambahkan.',
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: meetings.length,
                        itemBuilder: (context, index) {
                          final data = meetings[index];
                          final meetingId = data['id'];
                          final pertemuanKe = index + 1;

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
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailPertemuan(
                                        classCode: widget.classCode,
                                        className: widget.className,
                                        pertemuanKe: pertemuanKe,
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    // Meeting Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data['nama_pertemuan'] ?? 'Pertemuan',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1A237E),
                                            ),
                                          ),
                                          if ((data['tema_pertemuan'] ?? '').isNotEmpty) ...[
                                            const SizedBox(height: 4),
                                            Text(
                                              data['tema_pertemuan'] ?? '',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF1A237E),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    // Hapus Button
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        HapusPertemuanDialog.show(
                                          context,
                                          () {
                                            _deleteMeeting(meetingId);
                                          },
                                        );
                                      },
                                      child: SizedBox(
                                        height: 32,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            HapusPertemuanDialog.show(
                                              context,
                                              () {
                                                _deleteMeeting(meetingId);
                                              },
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF1A237E),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 8,
                                            ),
                                            elevation: 0,
                                          ),
                                          child: const Text(
                                            'Hapus',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}