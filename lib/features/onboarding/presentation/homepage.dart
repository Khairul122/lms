import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lms/services/api_service.dart';
import 'package:lms/features/classroom/presentation/dftr_kelas.dart';
import 'package:lms/features/tasks/presentation/daftar_tugas.dart';
import 'package:lms/features/profile/presentation/profil.dart';
import 'package:lms/features/notifications/presentation/notifikasi.dart';
import 'package:lms/features/classroom/presentation/detail_kelas.dart';
import 'package:lms/features/classroom/presentation/carikelas.dart';
import 'package:lms/core/services/notification_service.dart';
import 'dart:convert';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  String _siswaNama = 'Siswa';
  List<dynamic> _joinedClasses = [];
  bool _isLoadingClasses = true;
  Map<String, dynamic>? _recentClass;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    NotificationService.syncTopics();
  }

  Future<void> _loadInitialData() async {
    await _loadProfileAndRecent();
    await _fetchClassesFromApi();
  }

  // Load profil dan riwayat kelas lokal
  Future<void> _loadProfileAndRecent() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _siswaNama = prefs.getString("name") ?? "Siswa";
      String? recentJson = prefs.getString("recently_viewed");
      if (recentJson != null) {
        _recentClass = Map<String, dynamic>.from(jsonDecode(recentJson));
      }
    });
  }

  // Mengambil kelas siswa dari API Laravel
  Future<void> _fetchClassesFromApi() async {
    try {
      debugPrint("🔄 [FETCH] Mengambil daftar kelas dari /api/classes...");
      final response = await ApiService.get("/classes");
      debugPrint("📦 [FETCH RESPONSE]: $response");

      if (!mounted) return;

      if (response != null && (response['success'] == true || response['status'] == 'success')) {
        setState(() {
          // Flexible parsing untuk berbagai format JSON dari Laravel
          if (response['data'] != null && response['data'] is List) {
            _joinedClasses = List.from(response['data']);
          } else if (response['classes'] != null && response['classes'] is List) {
            _joinedClasses = List.from(response['classes']);
          } else {
            _joinedClasses = [];
          }
        });
        debugPrint("✅ [FETCH SUCCESS] Jumlah kelas ditemukan: ${_joinedClasses.length}");
      }
    } catch (e) {
      debugPrint("❌ [FETCH ERROR] Gagal mengambil data kelas: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoadingClasses = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, size),
                const SizedBox(height: 25),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Kelas yang Diikuti', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
                const SizedBox(height: 12),
                _buildKelasHorizontalList(size),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20, top: 8),
                    child: InkWell(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DaftarKelasScreen())).then((_) => _loadInitialData()),
                      child: const Row(mainAxisSize: MainAxisSize.min, children: [Text('Selengkapnya', style: TextStyle(color: Color(0xFF38B0FE), fontWeight: FontWeight.w500, fontSize: 14)), SizedBox(width: 4), Icon(Icons.arrow_circle_right_outlined, color: Color(0xFF38B0FE), size: 18)]),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Pengingat Batas Waktu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
                const SizedBox(height: 12),
                _buildStaticDeadlineCard('Fitur pengingat tugas terintegrasi'),
                const SizedBox(height: 25),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Baru Saja Dilihat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
                const SizedBox(height: 12),
                _buildLocalRecentlyViewedSection(),
                const SizedBox(height: 120),
              ],
            ),
          ),
          Positioned(bottom: 100, right: 20, child: _buildFloatingAddButton(context)),
          Positioned(bottom: 15, left: 15, right: 15, child: _buildBottomNav(context)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Size size) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
      decoration: const BoxDecoration(
        color: Color(0xFF38B0FE), 
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text('Hi, $_siswaNama', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
              ),
              IconButton(icon: const Icon(Icons.notifications_none, color: Colors.white, size: 28), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotifikasiScreen()))),
            ],
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CariKelasScreen())).then((_) => _loadInitialData()),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Row(children: [const Icon(Icons.search, color: Color(0xFF38B0FE), size: 24), const SizedBox(width: 12), Text('Cari Kelas Disini', style: TextStyle(color: Colors.grey[400], fontSize: 16))]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKelasHorizontalList(Size size) {
    if (_isLoadingClasses) return const SizedBox(height: 160, child: Center(child: CircularProgressIndicator()));
    if (_joinedClasses.isEmpty) return const SizedBox(height: 160, child: Center(child: Text('Belum ada kelas yang diikuti')));

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _joinedClasses.length,
        itemBuilder: (context, index) {
          final data = _joinedClasses[index] as Map<String, dynamic>;
          final gradients = [const [Color(0xFF00B4DB), Color(0xFF0083B0)], const [Color(0xFF007991), Color(0xFF78ffd6)]];
          return _buildKelasCard(
            data['subject'] ?? data['title'] ?? 'Pelajaran', 
            data['class_name'] ?? data['name'] ?? 'Kelas', 
            gradients[index % gradients.length], 
            'assets/images/kelas.png', 
            onTap: () => Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => DetailKelasScreen(
                  classCode: data['class_code'] ?? data['code'] ?? '', 
                  className: data['class_name'] ?? data['name'] ?? 'Kelas', 
                  subject: data['subject'] ?? data['title'] ?? 'Pelajaran'
                )
              )
            ).then((_) => _loadProfileAndRecent())
          );
        },
      ),
    );
  }

  Widget _buildKelasCard(String title, String subtitle, List<Color> gradientColors, String imagePath, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(gradient: LinearGradient(colors: gradientColors, begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(20)),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Text(subtitle, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Positioned(
              right: 15, bottom: 15,
              child: Image.asset(imagePath, width: 80, height: 80, fit: BoxFit.contain, errorBuilder: (context, error, stackTrace) => Icon(Icons.school, size: 80, color: Colors.white.withOpacity(0.3))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocalRecentlyViewedSection() {
    if (_recentClass == null) {
      return const _BaseRecentCard(title: 'Belum ada riwayat', subtitle: 'Silahkan buka kelas');
    }
    return _BaseRecentCard(
      title: _recentClass!['subject'] ?? 'Pelajaran',
      subtitle: _recentClass!['class_name'] ?? 'Kelas',
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailKelasScreen(
            classCode: _recentClass!['class_code'] ?? '',
            className: _recentClass!['class_name'] ?? 'Kelas',
            subject: _recentClass!['subject'] ?? 'Pelajaran',
          ),
        ),
      ).then((_) => _loadProfileAndRecent()),
    );
  }

  Widget _buildStaticDeadlineCard(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFFF4F6F8), borderRadius: BorderRadius.circular(20)),
        child: Row(children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFFFFF0D4), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.access_time_filled, color: Color(0xFFF9A825), size: 28)),
          const SizedBox(width: 16),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))
        ])
      )
    );
  }

  Widget _buildFloatingAddButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAddClassDialog(context),
      child: Container(
        width: 60, height: 60,
        decoration: BoxDecoration(color: const Color(0xFF38B0FE), shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))]),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(color: const Color(0xFF38B0FE), borderRadius: BorderRadius.circular(30), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5))]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home, 'Beranda', true, () {}),
          _navItem(Icons.co_present_outlined, '', false, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DaftarKelasScreen())).then((_) => _loadInitialData())),
          _navItem(Icons.pending_actions_outlined, '', false, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DaftarTugasScreen()))),
          _navItem(Icons.person_outline, '', false, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilScreen()))),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool isActive, VoidCallback onTap) {
    if (isActive) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Row(children: [Icon(icon, color: const Color(0xFF38B0FE), size: 24), if (label.isNotEmpty) const SizedBox(width: 8), if (label.isNotEmpty) Text(label, style: const TextStyle(color: Color(0xFF38B0FE), fontWeight: FontWeight.bold))]),
      );
    }
    return IconButton(icon: Icon(icon, color: Colors.white, size: 26), onPressed: onTap);
  }

  void _showAddClassDialog(BuildContext context) {
    final TextEditingController _tokenController = TextEditingController();
    bool _isDialogLoading = false;
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 30, 24, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Silahkan Masukkan\nKode Kelas', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _tokenController,
                    textCapitalization: TextCapitalization.characters,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24, letterSpacing: 4, color: Colors.white, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(filled: true, fillColor: const Color(0xFF00A8E8), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(vertical: 20))
                  ),
                  const SizedBox(height: 10),
                  const Text('Note : Mintalah Kode Kelas\nKepada Pengajar', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.black87)),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: _isDialogLoading ? null : () async {
                        final token = _tokenController.text.trim();
                        if (token.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Masukkan kode kelas terlebih dahulu!'), backgroundColor: Colors.orange)
                          );
                          return;
                        }

                        setDialogState(() => _isDialogLoading = true);

                        try {
                          final response = await ApiService.post("/classes/join", {"class_code": token});
                          debugPrint("📌 [JOIN RESPONSE]: $response");
                          
                          if (!mounted) return;

                          if (response is Map && (response['success'] == true || response['status'] == 'success')) {
                            // 1. Fetch ulang data kelas dari backend
                            await _fetchClassesFromApi();

                            if (!mounted) return;

                            // 2. Tutup dialog input
                            if (Navigator.canPop(dialogContext)) {
                              Navigator.pop(dialogContext);
                            }

                            // 3. Tampilkan dialog sukses
                            _showSuccessDialog(context);
                          } else {
                            final String msg = (response is Map && response.containsKey('message')) 
                                ? response['message'] 
                                : 'Gagal bergabung ke kelas';
                                
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(msg), backgroundColor: Colors.red)
                            );
                          }
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Terjadi kesalahan: $e'), backgroundColor: Colors.red)
                          );
                        } finally {
                          setDialogState(() => _isDialogLoading = false);
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF38B0FE), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                      child: _isDialogLoading 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                        : const Text('Tambah', style: TextStyle(fontWeight: FontWeight.bold))
                    )
                  )
                ]
              )
            )
          );
        });
      }
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40), child: Column(mainAxisSize: MainAxisSize.min, children: [const Text('Berhasil !', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), const SizedBox(height: 25), Container(width: 80, height: 80, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFF00FF00), width: 6)), child: const Center(child: Icon(Icons.check, color: Color(0xFF00FF00), size: 50))), const SizedBox(height: 25), const Text('Anda Berhasil Menambahkan\nKelas Baru', textAlign: TextAlign.center), const SizedBox(height: 30), ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF38B0FE), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12)), child: const Text('Kembali'))]))));
  }
}

class _BaseRecentCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onPressed;
  const _BaseRecentCard({required this.title, required this.subtitle, this.onPressed});
  @override Widget build(BuildContext context) { return Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFF4F6F8), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]), child: Row(children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFFE1F5FE), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.description, color: Color(0xFF38B0FE), size: 28)), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis), Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 13))])), if (onPressed != null) ElevatedButton(onPressed: onPressed, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF38B0FE), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap), child: const Row(mainAxisSize: MainAxisSize.min, children: [Text('Buka', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)), SizedBox(width: 4), Icon(Icons.arrow_forward, size: 14)]))]))); }
}