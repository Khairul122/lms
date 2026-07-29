import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:guru/fcm_service.dart';
import 'package:guru/repositories/auth_repository.dart';
import 'package:guru/repositories/discussion_repository.dart';

class TambahKomentar extends StatefulWidget {
  final String classCode;
  final String className;

  const TambahKomentar({
    super.key,
    required this.classCode,
    required this.className,
  });

  @override
  State<TambahKomentar> createState() => _TambahKomentarState();
}

class _TambahKomentarState extends State<TambahKomentar> {
  final TextEditingController _commentController = TextEditingController();
  final AuthRepository _authRepository = AuthRepository();
  final DiscussionRepository _discussionRepository = DiscussionRepository();
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _subscribeToTopic();
  }

  void _subscribeToTopic() async {
    await FirebaseMessaging.instance.subscribeToTopic('chat_${widget.classCode}');
  }

  Future<void> _loadUserName() async {
    try {
      final profile = await _authRepository.profile();
      if (mounted) {
        setState(() {
          _userName = profile['name'] ?? 'Guru';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _userName = 'Guru';
        });
      }
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _sendComment() async {
    if (_commentController.text.trim().isEmpty) return;

    final String message = _commentController.text.trim();
    final String senderName = _userName ?? 'Guru';

    try {
      await _discussionRepository.sendDiscussion(
        classCode: widget.classCode,
        message: message,
      );

      await FCMService.sendChatNotification(
        classCode: widget.classCode,
        className: widget.className,
        senderName: senderName,
        message: message,
      );

      _commentController.clear();

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header with dark blue background
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Diskusi Kelas',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
          ),

          // Discussion Area
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _discussionRepository.getDiscussions(widget.classCode),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum ada diskusi di kelas ini.',
                    ),
                  );
                }

                final messages = snapshot.data!;

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(20),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msgData = messages[index] as Map<String, dynamic>;
                    const bool isTeacher = true;
                    const bool isMe = false;

                    return _buildCommentItem(
                      msgData,
                      isMe,
                      isTeacher,
                    );
                  },
                );
              },
            ),
          ),

          // Bottom Input Field
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: 'Tulis pesan diskusi...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      maxLines: null,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A237E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: _sendComment,
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Map<String, dynamic> data, bool isMe, bool isTeacher) {
    DateTime? timestamp;

    if (data['created_at'] != null) {
      timestamp = DateTime.tryParse(data['created_at']);
    }

    final String timeStr = timestamp != null
        ? DateFormat('HH:mm').format(timestamp.toLocal())
        : '--:--';

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 4),
                child: Text(
                  "${data['user_name'] ?? 'Guru'} ${isTeacher ? '(Guru)' : ''}",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isTeacher ? Colors.blue[900] : Colors.blueGrey,
                  ),
                ),
              ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFF1A237E) : (isTeacher ? Colors.blue[50] : const Color(0xFFE3F2FD)),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(15),
                  topRight: const Radius.circular(15),
                  bottomLeft: Radius.circular(isMe ? 15 : 0),
                  bottomRight: Radius.circular(isMe ? 0 : 15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['message'] ?? '',
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timeStr,
                    style: TextStyle(
                      color: isMe ? Colors.white70 : Colors.black54,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}