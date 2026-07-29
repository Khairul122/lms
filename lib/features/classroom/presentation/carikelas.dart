import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lms/services/api_service.dart'; // Pastikan path ApiService benar
import 'package:lms/features/classroom/presentation/detail_kelas.dart';
import 'package:lms/features/notifications/presentation/notifikasi.dart';

class CariKelasScreen extends StatefulWidget {
  const CariKelasScreen({super.key});

  @override
  State<CariKelasScreen> createState() => _CariKelasScreenState();
}

class _CariKelasScreenState extends State<CariKelasScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _siswaNama = "Siswa";
  List<dynamic> _allClasses = [];
  List<dynamic> _filteredClasses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileAndClasses();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Mengambil nama dari SharedPreferences dan daftar kelas dari API Laravel
  Future<void> _loadProfileAndClasses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _siswaNama = prefs.getString("name") ?? "Siswa";
      });

      // Mengambil data kelas dari endpoint GET /api/classes
      final response = await ApiService.get("/classes");
      if (response != null && response['success'] == true) {
        setState(() {
          _allClasses = response['data'] ?? [];
          _filteredClasses = _allClasses;
        });
      }
    } catch (e) {
      debugPrint("Gagal mengambil data kelas: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _filterClasses(String query) {
    setState(() {
      _searchQuery = query.toLowerCase().trim();
      if (_searchQuery.isEmpty) {
        _filteredClasses = _allClasses;
      } else {
        _filteredClasses = _allClasses.where((classData) {
          final className = (classData['class_name'] ?? '').toString().toLowerCase();
          final classCode = (classData['class_code'] ?? '').toString().toLowerCase();
          final subject = (classData['subject'] ?? '').toString().toLowerCase();

          return className.contains(_searchQuery) ||
              classCode.contains(_searchQuery) ||
              subject.contains(_searchQuery);
        }).toList();
      }
    });
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
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                            ),
                            Text(
                              'Hi, $_siswaNama',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.notifications_none, color: Colors.white, size: 28),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const NotifikasiScreen()));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Search Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _filterClasses,
                        decoration: InputDecoration(
                          hintText: 'Cari berdasarkan Nama atau Kode Kelas...',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          border: InputBorder.none,
                          icon: const Icon(Icons.search, color: Color(0xFF38B0FE)),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    _filterClasses("");
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Search Results
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredClasses.isEmpty
                    ? _buildEmptyState("Tidak ada kelas yang ditemukan")
                    : ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: _filteredClasses.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 15),
                        itemBuilder: (context, index) {
                          final data = _filteredClasses[index] as Map<String, dynamic>;
                          return _buildSearchResultCard(context, data);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 10),
          Text(message, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600], fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildSearchResultCard(BuildContext context, Map<String, dynamic> data) {
    final String subject = data['subject'] ?? 'Pelajaran';
    final String className = data['class_name'] ?? 'Kelas';
    final String classCode = data['class_code'] ?? '';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailKelasScreen(
              classCode: classCode,
              className: className,
              subject: subject,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: const Color(0xFF38B0FE).withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF38B0FE).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.class_outlined, color: Color(0xFF38B0FE)),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(subject, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text(className, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}