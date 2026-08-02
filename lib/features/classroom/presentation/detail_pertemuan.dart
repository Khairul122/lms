import 'package:flutter/material.dart';
import 'package:guru/services/api_service.dart';
import 'package:guru/features/materials/presentation/tambah_materi_dinamis.dart';
import 'package:guru/features/tasks/presentation/tambah_tugas_dinamis.dart';
import 'package:guru/features/materials/presentation/materi_detail_dinamis.dart';
import 'package:guru/features/tasks/presentation/tugas_detail_dinamis.dart';
import 'package:guru/features/classroom/presentation/absensi_pertemuan.dart';

class DetailPertemuan extends StatefulWidget {
  final String classCode;
  final String className;
  final int pertemuanKe;
  final String? namaPertemuan; // Parameter tambahan agar sinkron dengan Web Admin

  const DetailPertemuan({
    super.key,
    required this.classCode,
    required this.className,
    required this.pertemuanKe,
    this.namaPertemuan,
  });

  @override
  State<DetailPertemuan> createState() => _DetailPertemuanState();
}

class _DetailPertemuanState extends State<DetailPertemuan> {
  List<dynamic> listMateri = [];
  List<dynamic> listTugas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  /// Ambil data materi dan tugas langsung dari Laravel REST API
  Future<void> _fetchData() async {
    setState(() => isLoading = true);

    try {
      // 1. Ambil Materi dari Laravel API
      final resMateri = await ApiService.get(
        "/materials?class_code=${widget.classCode}&pertemuan=${widget.pertemuanKe}",
      );
      if (resMateri != null && resMateri['data'] != null) {
        listMateri = resMateri['data'];
      } else if (resMateri is List) {
        listMateri = resMateri;
      }

      // 2. Ambil Tugas dari Laravel API
      final resTugas = await ApiService.get(
        "/tasks?class_code=${widget.classCode}&pertemuan=${widget.pertemuanKe}",
      );
      if (resTugas != null && resTugas['data'] != null) {
        listTugas = resTugas['data'];
      } else if (resTugas is List) {
        listTugas = resTugas;
      }
    } catch (e) {
      debugPrint("FETCH DETAIL PERTEMUAN ERROR: $e");
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  /// Hapus Materi via REST API
  Future<void> _deleteMateri(dynamic id) async {
    final res = await ApiService.delete("/materials/$id");
    if (res != null) {
      _fetchData(); // Refresh data
    }
  }

  /// Hapus Tugas via REST API
  Future<void> _deleteTugas(dynamic id) async {
    final res = await ApiService.delete("/tasks/$id");
    if (res != null) {
      _fetchData(); // Refresh data
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
        title: const Text('Kembali', style: TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: const Color(0xFF1A237E),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchData,
        child: Column(
          children: [
            // Header dengan background biru tua
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.namaPertemuan ?? 'Pertemuan ${widget.pertemuanKe}',
                      style: const TextStyle(
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
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Main Content Area
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              'Materi Dan Tugas',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A237E),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // ================= MATERI SECTION =================
                          const Text(
                            'Materi Pertemuan :',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A237E),
                            ),
                          ),
                          const SizedBox(height: 20),

                          if (listMateri.isEmpty)
                            _buildEmptyState(
                              'Anda Belum Menambahkan Materi',
                              'Tambah Materi',
                              () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TambahMateriDinamis(
                                      classCode: widget.classCode,
                                      className: widget.className,
                                      pertemuanKe: widget.pertemuanKe,
                                    ),
                                  ),
                                );
                                _fetchData();
                              },
                            )
                          else
                            ...listMateri.map((data) => _buildItemCard(
                                  title: data['title'] ?? 'Materi',
                                  description: data['description'] ?? '',
                                  onLihat: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MateriDetailDinamis(
                                          title: data['title'] ?? 'Materi',
                                          description: data['description'] ?? '',
                                          className: widget.className,
                                          pertemuanKe: widget.pertemuanKe,
                                          files: List<Map<String, dynamic>>.from(data['files'] ?? []),
                                        ),
                                      ),
                                    );
                                  },
                                  onDelete: () => _deleteMateri(data['id']),
                                )),

                          const SizedBox(height: 32),

                          // ================= TUGAS SECTION =================
                          const Text(
                            'Tugas Pertemuan :',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A237E),
                            ),
                          ),
                          const SizedBox(height: 20),

                          if (listTugas.isEmpty)
                            _buildEmptyState(
                              'Anda Belum Menambahkan Tugas',
                              'Tambah Tugas',
                              () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TambahTugasDinamis(
                                      classCode: widget.classCode,
                                      className: widget.className,
                                      pertemuanKe: widget.pertemuanKe,
                                    ),
                                  ),
                                );
                                _fetchData();
                              },
                            )
                          else
                            ...listTugas.map((data) => _buildItemCard(
                                  title: data['title'] ?? 'Tugas',
                                  description: data['description'] ?? '',
                                  onLihat: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TugasDetailDinamis(
                                          title: data['title'] ?? 'Tugas',
                                          description: data['description'] ?? '',
                                          className: widget.className,
                                          pertemuanKe: widget.pertemuanKe,
                                        ),
                                      ),
                                    );
                                  },
                                  onDelete: () => _deleteTugas(data['id']),
                                )),

                          const SizedBox(height: 32),

                          // ================= ABSENSI SECTION =================
                          const Text(
                            'Absensi Pertemuan :',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A237E),
                            ),
                          ),
                          const SizedBox(height: 20),

                          _buildAddButton('Isi Absensi', () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AbsensiPertemuan(
                                  classCode: widget.classCode,
                                  className: widget.className,
                                  pertemuanKe: widget.pertemuanKe,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget Tampilan Jika Data Kosong
  Widget _buildEmptyState(String message, String buttonText, VoidCallback onPressed) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E),
                ),
              ),
            ],
          ),
        ),
        _buildAddButton(buttonText, onPressed),
      ],
    );
  }

  /// Widget Card Item Materi / Tugas
  Widget _buildItemCard({
    required String title,
    required String description,
    required VoidCallback onLihat,
    required VoidCallback onDelete,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(color: Color(0xFF1A237E), fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            height: 32,
            child: ElevatedButton(
              onPressed: onLihat,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A237E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
              child: const Text('Lihat', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }

  /// Widget Tombol Tambah
  Widget _buildAddButton(String text, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A237E),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, color: Colors.white, size: 22),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}