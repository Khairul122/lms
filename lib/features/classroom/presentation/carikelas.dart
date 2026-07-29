import 'package:flutter/material.dart';
import 'package:guru/core/widgets/app_dialog.dart';
import 'package:guru/features/classroom/data/class_repository.dart';
import 'package:guru/features/classroom/presentation/detail_pertemuan.dart';
import 'package:guru/features/classroom/presentation/daftarmurid.dart';

class CariKelas extends StatefulWidget {
  const CariKelas({super.key});

  @override
  State<CariKelas> createState() => _CariKelasState();
}

class _CariKelasState extends State<CariKelas> {
  final ClassRepository _classRepository = ClassRepository();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<dynamic> _allClasses = [];
  List<dynamic> _filteredClasses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchClasses();
    _searchController.addListener(() {
      _filterClasses();
    });
  }

  Future<void> _fetchClasses() async {
    try {
      final data = await _classRepository.getClasses();
      if (mounted) {
        setState(() {
          _allClasses = data;
          _filteredClasses = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        AppDialog.showError(context, "Gagal memuat kelas: $e");
      }
    }
  }

  void _filterClasses() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _filteredClasses = _allClasses.where((kelas) {
        final subject = (kelas['subject'] ?? '').toString().toLowerCase();
        final className = (kelas['class_name'] ?? '').toString().toLowerCase();
        return subject.contains(_searchQuery) || className.contains(_searchQuery);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SizedBox(
                height: 100,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 28,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Cari Kelas',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A237E),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Temukan kelas Anda di sini',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: const Center(
                        child: Text(
                          'EduSmart',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A237E),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Color(0xFF1A237E)),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A237E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Cari mata pelajaran atau kelas...',
                    hintStyle: TextStyle(color: Colors.grey.shade300, fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade300),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Search Results
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredClasses.isEmpty
                      ? _buildNoResult(_allClasses.isEmpty
                          ? 'Belum ada kelas yang dibuat'
                          : 'Kelas Tidak Ditemukan')
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          itemCount: _filteredClasses.length,
                          itemBuilder: (context, index) {
                            final data = _filteredClasses[index] as Map<String, dynamic>;
                            return _buildClassCard(context, data);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResult(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close, color: Colors.white, size: 50),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A237E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassCard(BuildContext context, Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPertemuan(
              classCode: data['class_code'] ?? '',
              className: '${data['subject'] ?? ''} - ${data['class_name'] ?? ''}',
              pertemuanKe: 1,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFE3F2FD),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['subject'] ?? 'Pelajaran',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data['class_name'] ?? 'Kelas',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A237E),
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DaftarMurid(classCode: data['class_code'] ?? ''),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A237E),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Daftar Murid',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Center(
                child: Image.asset(
                  'assets/kelas.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}