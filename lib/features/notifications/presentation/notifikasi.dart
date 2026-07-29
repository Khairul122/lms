import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotifikasiScreen extends StatelessWidget {
  const NotifikasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
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

          SizedBox(height: 20),

          // Title with Back Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 28,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 28),
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
              ],
            ),
          ),

          SizedBox(height: 20),

          // Content - List of Notifications
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              // Stream pertama: Ambil daftar kelas yang diikuti siswa
              stream: FirebaseFirestore.instance
                  .collection('classes')
                  .where('students', arrayContains: FirebaseAuth.instance.currentUser?.uid)
                  .snapshots(),
              builder: (context, classSnapshot) {
                if (classSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!classSnapshot.hasData || classSnapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('Kamu belum bergabung dengan kelas apapun.'),
                  );
                }

                // Ambil semua class_code dari kelas yang diikuti
                final joinedClassCodes = classSnapshot.data!.docs
                    .map((doc) => doc['class_code'] as String)
                    .toList();

                // Stream kedua: Ambil notifikasi dari Firestore
                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('notifications')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, notifSnapshot) {
                    if (notifSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!notifSnapshot.hasData || notifSnapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('Belum ada notifikasi.'),
                      );
                    }

                    // Filter notifikasi: 
                    // Tampilkan jika class_id ada di kelas yang diikuti ATAU receiver_id adalah ID Siswa ini
                    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
                    final notifications = notifSnapshot.data!.docs.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final classId = data['class_id'] as String?;
                      final receiverId = data['receiver_id'] as String?;
                      
                      bool isFromJoinedClass = classId != null && joinedClassCodes.contains(classId);
                      bool isForMe = receiverId != null && receiverId == currentUserId;
                      
                      return isFromJoinedClass || isForMe;
                    }).toList();

                    if (notifications.isEmpty) {
                      return const Center(
                        child: Text('Belum ada notifikasi.'),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: notifications.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 15),
                      itemBuilder: (context, index) {
                        final data = notifications[index].data() as Map<String, dynamic>;
                        
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
                    );
                  },
                );
              },
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
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: Offset(0, 2),
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
          SizedBox(width: 12),
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
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 6),
                // Message
                Text(
                  message,
                  style: TextStyle(
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

