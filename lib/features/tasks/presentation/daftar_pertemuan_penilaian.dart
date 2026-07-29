import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guru/features/tasks/presentation/daftar_tugas_penilaian.dart';

class DaftarPertemuanPenilaian extends StatefulWidget {
  final String classCode;
  final String className;

  const DaftarPertemuanPenilaian({
    super.key,
    required this.classCode,
    required this.className,
  });

  @override
  State<DaftarPertemuanPenilaian> createState() => _DaftarPertemuanPenilaianState();
}

class _DaftarPertemuanPenilaianState extends State<DaftarPertemuanPenilaian> {

  late Stream<QuerySnapshot> _meetingsStream;

  @override
  void initState() {
    super.initState();
    _meetingsStream = FirebaseFirestore.instance
        .collection('meetings')
        .where('class_id', isEqualTo: widget.classCode)
        .snapshots();
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
                            'Penilaian',
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

          // Main Content Area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pilih Pertemuan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  StreamBuilder<QuerySnapshot>(
                    stream: _meetingsStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('Belum ada pertemuan ditambahkan.'));
                      }

                      final meetings = snapshot.data!.docs.toList();
                      meetings.sort((a, b) {
                        final dataA = a.data() as Map<String, dynamic>;
                        final dataB = b.data() as Map<String, dynamic>;
                        final timeA = dataA['created_at'] as Timestamp?;
                        final timeB = dataB['created_at'] as Timestamp?;
                        if (timeA == null && timeB == null) return 0;
                        if (timeA == null) return 1;
                        if (timeB == null) return -1;
                        return timeA.compareTo(timeB);
                      });

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: meetings.length,
                        itemBuilder: (context, index) {
                          final data = meetings[index].data() as Map<String, dynamic>;
                          final pertemuanKe = index + 1;
                          final meetingId = meetings[index].id;
                          
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DaftarTugasPenilaian(
                                    classCode: widget.classCode,
                                    className: widget.className,
                                    pertemuanKe: pertemuanKe,
                                    meetingId: meetingId,
                                    meetingName: data['nama_pertemuan'] ?? 'Pertemuan $pertemuanKe',
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
                                      data['nama_pertemuan'] ?? 'Pertemuan $pertemuanKe',
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
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1A237E),
                                        ),
                                        textAlign: TextAlign.center,
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
