import 'package:flutter/material.dart';
import 'package:lms/services/api_service.dart';

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
                                if (data['type'] == 'task') {
                                  icon = Icons.assignment;
                                  iconColor = Colors.orange;
                                } else if (data['type'] == 'material') {
                                  icon = Icons.book;
                                  iconColor = Colors.blue;
                                } else if (data['type'] == 'grade') {
                                  icon = Icons.star; // Ikon bintang untuk nilai
                                  iconColor = Colors.amber;
                                } else {
                                  icon = Icons.notifications;
                                  iconColor = Colors.green;
                                }

                                return _buildNotificationCard(
                                  icon: icon,
                                  iconColor: iconColor,
                                  title: data['title'] ?? 'Notifikasi',
                                  message: data['message'] ?? '',
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
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
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
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
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
        ],
      ),
    );
  }
}
