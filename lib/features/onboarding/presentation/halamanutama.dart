import 'package:flutter/material.dart';
import 'package:guru/features/auth/data/auth_repository.dart';
import 'package:guru/features/classroom/data/class_repository.dart';
import 'package:guru/features/classroom/data/meeting_repository.dart';
import 'dart:async';
import 'package:guru/features/classroom/presentation/daftarkelas.dart';
import 'package:guru/core/widgets/bottom_nav_bar.dart';
import 'package:guru/core/services/notification_watcher.dart';
import 'package:guru/core/widgets/notification_bell.dart';
import 'package:guru/app_navigation.dart';
import 'package:guru/features/classroom/presentation/daftarmurid.dart';
import 'package:guru/features/classroom/presentation/carikelas.dart';
import 'package:guru/features/classroom/presentation/tambah_pertemuan.dart';

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  final AuthRepository _authRepository = AuthRepository();
  final ClassRepository _classRepository = ClassRepository();
  final MeetingRepository _meetingRepository = MeetingRepository();
  
  String _userName = "...";
  int _totalMurid = 0;
  int _totalPertemuan = 0;
  List<Map<String, dynamic>> _allClasses = [];
  bool _isLoading = true;
  
  // Carousel logic
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadAllData();
    _startAutoScroll();
    NotificationWatcher.instance.start();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  /// 🔥 MOUNTED-SAFE DATA LOADER & COUNTER FIX
  Future<void> _loadAllData() async {
    String userName = "Guru";
    List<Map<String, dynamic>> parsedClasses = [];
    int muridCount = 0;
    int meetingCount = 0;

    // 1. Fetch Profile Guru
    try {
      final dynamic profile = await _authRepository.profile();
      if (profile is Map) {
        final Map<String, dynamic> pMap = Map<String, dynamic>.from(profile);
        final dynamic dataObj = pMap['data'] ?? pMap;
        if (dataObj is Map && dataObj['name'] != null) {
          userName = dataObj['name'].toString();
        }
      }
    } catch (e) {
      debugPrint("ERROR PROFILE IN HOME: $e");
    }

    // 2. Fetch Classes & Hitung Total Murid
    try {
      final dynamic classesRes = await _classRepository.getClasses();
      List classesRaw = [];

      if (classesRes is Map) {
        final Map<String, dynamic> cMap = Map<String, dynamic>.from(classesRes);
        if (cMap['data'] is List) {
          classesRaw = cMap['data'] as List;
        }
      } else if (classesRes is List) {
        classesRaw = classesRes;
      }

      for (final item in classesRaw) {
        if (item != null) {
          Map<String, dynamic> kelasMap = {};
          
          if (item is Map) {
            kelasMap = Map<String, dynamic>.from(item);
          } else {
            try {
              kelasMap = {
                'id': (item as dynamic).id,
                'class_code': (item as dynamic).classCode ?? '',
                'class_name': (item as dynamic).className ?? '',
                'subject': (item as dynamic).subject ?? '',
                'description': (item as dynamic).description ?? '',
                'students': (item as dynamic).students ?? [],
              };
            } catch (_) {}
          }

          // Hitung murid jika dikirim relasi 'students' atau 'students_count'
          if (kelasMap['students'] != null && kelasMap['students'] is List) {
            muridCount += (kelasMap['students'] as List).length;
          } else if (kelasMap['students_count'] != null) {
            muridCount += int.tryParse(kelasMap['students_count'].toString()) ?? 0;
          } else if (kelasMap['total_students'] != null) {
            muridCount += int.tryParse(kelasMap['total_students'].toString()) ?? 0;
          }

          parsedClasses.add(kelasMap);
        }
      }
    } catch (e) {
      debugPrint("ERROR CLASSES IN HOME: $e");
    }

    // 3. Fetch Meetings & Hitung Total Pertemuan
    try {
      final dynamic meetingsRes = await _meetingRepository.getMeetings();
      List meetingsList = [];

      if (meetingsRes is Map) {
        final Map<String, dynamic> mMap = Map<String, dynamic>.from(meetingsRes);
        if (mMap['data'] is List) {
          meetingsList = mMap['data'] as List;
        }
      } else if (meetingsRes is List) {
        meetingsList = meetingsRes;
      }

      meetingCount = meetingsList.length;
    } catch (e) {
      debugPrint("ERROR MEETINGS IN HOME: $e");
    }

    // Update State
    if (mounted) {
      setState(() {
        _userName = userName;
        _allClasses = parsedClasses;
        _totalMurid = muridCount;
        _totalPertemuan = meetingCount;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'EduSmart', 
          style: TextStyle(color: Color(0xFF1A237E), fontWeight: FontWeight.bold, fontSize: 24)
        ),
        actions: [
          const NotificationBell(),
          const SizedBox(width: 10),
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _loadAllData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text('Hai $_userName!', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const Text('Selamat Pagi', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  
                  const SizedBox(height: 20),
                  // Search Bar
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CariKelas())),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A237E),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search, color: Colors.white),
                          SizedBox(width: 10),
                          Text('Cari Disini', style: TextStyle(color: Colors.white70, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 25),
                  // Welcome Banner (Auto Carousel)
                  SizedBox(
                    height: 140,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      children: [
                        _buildBannerCard('Selamat Datang!', 'Tetap semangat dalam bekerja', 'assets/beranda.png'),
                        _buildBannerCard('EduSmart Guru', 'Kelola kelas dengan lebih mudah', 'assets/beranda.png'),
                        _buildBannerCard('Mulai Mengajar', 'Siapkan materi terbaik Anda hari ini', 'assets/beranda.png'),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 15),
                  // Pagination dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: index == _currentPage ? 12 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: index == _currentPage ? const Color(0xFF1A237E) : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )),
                  ),

                  const SizedBox(height: 25),
                  const Text('Ringkasan Cepat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 15),
                  
                  // Summary Cards
                  Row(
                    children: [
                      _buildSummaryCard(
                        '$_totalMurid Murid', 
                        Icons.school_outlined, 
                        () async {
                          await Navigator.push(context, MaterialPageRoute(builder: (context) => const DaftarKelas()));
                          _loadAllData();
                        }
                      ),
                      const SizedBox(width: 15),
                      _buildSummaryCard(
                        '$_totalPertemuan Pertemuan', 
                        Icons.bookmark_outline, 
                        () async {
                          await Navigator.push(context, MaterialPageRoute(builder: (context) => const DaftarKelas()));
                          _loadAllData();
                        }
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 30),
                  const Text('Kelas Anda', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 15),
                  
                  // Horizontal Scrollable Class Cards
                  if (_allClasses.isNotEmpty)
                    SizedBox(
                      height: 165,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _allClasses.length,
                        itemBuilder: (context, index) {
                          final classData = _allClasses[index];
                          return Container(
                            width: 240,
                            margin: const EdgeInsets.only(right: 15),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE3F2FD),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TambahPertemuan(
                                        classCode: classData['class_code']?.toString() ?? '',
                                        className: '${classData['subject'] ?? ''} - ${classData['class_name'] ?? ''}',
                                      ),
                                    ),
                                  );
                                  _loadAllData();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              classData['subject']?.toString() ?? 'Pelajaran', 
                                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
                                              maxLines: 1, 
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              classData['class_name']?.toString() ?? 'Kelas', 
                                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
                                            ),
                                            const Spacer(),
                                            ElevatedButton(
                                              onPressed: () async {
                                                await Navigator.push(
                                                  context, 
                                                  MaterialPageRoute(
                                                    builder: (context) => DaftarMurid(classCode: classData['class_code']?.toString() ?? ''),
                                                  ),
                                                );
                                                _loadAllData();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xFF1A237E),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                              ),
                                              child: const Text('Daftar Murid', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Image.asset(
                                        'assets/kelas.png', 
                                        width: 75, 
                                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.menu_book, size: 60, color: Color(0xFF1A237E)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  else
                    const Text("Belum ada kelas.", style: TextStyle(color: Colors.grey)),
                    
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 0,
        onTabSelected: (index) => AppNavigation.goToTab(context, index),
        onCenterTap: () => AppNavigation.openTambahKelas(context),
      ),
    );
  }

  Widget _buildSummaryCard(String text, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF1A237E),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white, size: 28),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    text, 
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13), 
                    maxLines: 1, 
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 32,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1A237E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  elevation: 0,
                ),
                child: const Text('Lihat', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerCard(String title, String subtitle, String assetPath) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                const SizedBox(height: 8),
                Text(subtitle, style: const TextStyle(fontSize: 14, color: Color(0xFF1A237E), fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Image.asset(
              assetPath, 
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.laptop_chromebook, size: 80, color: Color(0xFF1A237E)),
            ),
          ),
        ],
      ),
    );
  }
}