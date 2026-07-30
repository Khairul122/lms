import 'package:flutter/material.dart';
import 'package:guru/features/notifications/data/notification_repository.dart';
import 'package:guru/core/services/notification_watcher.dart';
import 'package:guru/features/discussions/presentation/tambahkomentar.dart';

class Notifikasi extends StatefulWidget {
  const Notifikasi({super.key});

  @override
  State<Notifikasi> createState() => _NotifikasiState();
}

class _NotifikasiState extends State<Notifikasi> {
  final NotificationRepository _notificationRepository = NotificationRepository();

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
      final data = await _notificationRepository.getNotifications();
      if (!mounted) return;
      setState(() => _notifications = data);
    } catch (e) {
      if (!mounted) return;
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
        await _notificationRepository.updateNotification(id, {});
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

    if (type == 'discussion') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TambahKomentar(classCode: classCode, className: className),
        ),
      );
    }
    // Tipe lain (mis. tugas dikumpulkan) belum punya halaman detail yang bisa
    // dituju langsung dari notifikasi, jadi cukup ditandai terbaca di atas.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header with dark blue background
          Container(
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    // Back button
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    // Title "Notifikasi"
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Notifikasi',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: _isLoading ? null : _fetchNotifications,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(child: Text(_errorMessage!))
                    : RefreshIndicator(
                        onRefresh: _fetchNotifications,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Notifikasi Anda',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A237E),
                                ),
                              ),
                              const SizedBox(height: 20),

                              if (_notifications.isEmpty)
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 100),
                                    child: Text('Belum ada notifikasi baru.'),
                                  ),
                                )
                              else
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _notifications.length,
                                  itemBuilder: (context, index) {
                                    final data = _notifications[index] as Map<String, dynamic>;

                                    return _buildNotificationCard(
                                      title: (data['title'] ?? 'Notifikasi').toString(),
                                      message: (data['message'] ?? '').toString(),
                                      isRead: data['is_read'] == true,
                                      icon: _iconForType(data['type']),
                                      onTap: () => _onNotificationTap(data),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  IconData _iconForType(dynamic type) {
    switch (type) {
      case 'discussion':
        return Icons.forum;
      case 'submission':
        return Icons.upload_file;
      case 'task':
        return Icons.assignment;
      case 'material':
        return Icons.book;
      default:
        return Icons.assignment_turned_in;
    }
  }

  Widget _buildNotificationCard({
    required String title,
    required String message,
    required bool isRead,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isRead ? const Color(0xFFF2F4F7) : const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF1A237E),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isRead ? FontWeight.w600 : FontWeight.bold,
                        color: const Color(0xFF1A237E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1A237E),
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
