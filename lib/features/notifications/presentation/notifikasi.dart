import 'package:flutter/material.dart';
import 'package:lms/services/api_service.dart';
import 'package:lms/core/services/notification_watcher.dart';
import 'package:lms/features/classroom/presentation/daftar_pertemuan.dart';
import 'package:lms/features/discussions/presentation/diskusi_kelas.dart';
import 'package:lms/features/tasks/presentation/daftar_tugas.dart';

class NotifikasiScreen extends StatefulWidget {
  const NotifikasiScreen({super.key});

  @override
  State<NotifikasiScreen> createState() => _NotifikasiScreenState();
}

class _NotifikasiScreenState extends State<NotifikasiScreen> {
  List<dynamic> _notifications = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await ApiService.get('/notifications');
      if (response is Map && response['success'] == true) {
        setState(() {
          _notifications = response['data'] is List ? List.from(response['data']) : [];
        });
      } else {
        final message = (response is Map ? response['message'] : null) ?? 'Gagal memuat notifikasi';
        setState(() => _errorMessage = message.toString());
      }
    } catch (e) {
      setState(() => _errorMessage = 'Gagal memuat notifikasi: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _onNotificationTap(Map<String, dynamic> data) async {
    final bool alreadyRead = data['is_read'] == true;
    final dynamic rawId = data['id'];
    final int? id = rawId is int ? rawId : int.tryParse(rawId?.toString() ?? '');

    if (!alreadyRead && id != null) {
      setState(() => data['is_read'] = true);
      try {
        await ApiService.put('/notifications/$id', {});
        NotificationWatcher.instance.refresh();
      } catch (e) {
        // Biarkan tampil sebagai sudah dibaca secara lokal walau request gagal;
        // refresh berikutnya akan menyinkronkan ulang dari server.
      }
    }

    if (!mounted) return;
    _navigateForNotification(data);
  }

  void _navigateForNotification(Map<String, dynamic> data) {
    final String type = (data['type'] ?? '').toString();
    final String classCode = (data['class_code'] ?? '').toString();
    final String className = (data['class'] ?? 'Kelas').toString();

    if (classCode.isEmpty) return;

    switch (type) {
      case 'task':
      case 'grade':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DaftarTugasScreen(classCode: classCode)),
        );
        break;
      case 'material':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DaftarPertemuanScreen(classCode: classCode, className: className),
          ),
        );
        break;
      case 'discussion':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DiskusiKelasScreen(classCode: classCode, className: className),
          ),
        );
        break;
      default:
        // Tipe lain (mis. pengumuman umum) tidak punya tujuan spesifik, cukup ditandai dibaca.
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Header
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF42A5F5),
                  Color(0xFF64B5F6),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'EduSmart',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Title with Back Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 28,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(right: 28),
                      child: Text(
                        'Notifikasi',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _isLoading ? null : _fetchNotifications,
                  icon: const Icon(Icons.refresh, color: Colors.black, size: 26),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Content - List of Notifications
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Text(_errorMessage!, textAlign: TextAlign.center),
                        ),
                      )
                    : _notifications.isEmpty
                        ? const Center(child: Text('Belum ada notifikasi.'))
                        : RefreshIndicator(
                            onRefresh: _fetchNotifications,
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              itemCount: _notifications.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 15),
                              itemBuilder: (context, index) {
                                final data = _notifications[index] as Map<String, dynamic>;

                                // Menentukan icon berdasarkan tipe notifikasi
                                IconData icon;
                                Color iconColor;
                                switch (data['type']) {
                                  case 'task':
                                    icon = Icons.assignment;
                                    iconColor = Colors.orange;
                                    break;
                                  case 'material':
                                    icon = Icons.book;
                                    iconColor = Colors.blue;
                                    break;
                                  case 'grade':
                                    icon = Icons.star;
                                    iconColor = Colors.amber;
                                    break;
                                  case 'discussion':
                                    icon = Icons.forum;
                                    iconColor = Colors.purple;
                                    break;
                                  case 'submission':
                                    icon = Icons.upload_file;
                                    iconColor = Colors.teal;
                                    break;
                                  default:
                                    icon = Icons.notifications;
                                    iconColor = Colors.green;
                                }

                                return _buildNotificationCard(
                                  icon: icon,
                                  iconColor: iconColor,
                                  title: data['title'] ?? 'Notifikasi',
                                  message: data['message'] ?? '',
                                  isRead: data['is_read'] == true,
                                  onTap: () => _onNotificationTap(data),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String message,
    required bool isRead,
    required VoidCallback onTap,
  }) {
    return Material(
      color: isRead ? Colors.grey[100] : const Color(0xFFE3F2FD),
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isRead ? FontWeight.w600 : FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Message
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isRead)
                Container(
                  margin: const EdgeInsets.only(left: 8, top: 4),
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
