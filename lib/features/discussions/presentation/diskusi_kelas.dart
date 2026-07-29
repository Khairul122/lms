import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lms/services/api_service.dart';

class DiskusiKelasScreen extends StatefulWidget {
  final String classCode;
  final String className;

  const DiskusiKelasScreen({
    super.key,
    required this.classCode,
    required this.className,
  });

  @override
  State<DiskusiKelasScreen> createState() => _DiskusiKelasScreenState();
}

class _DiskusiKelasScreenState extends State<DiskusiKelasScreen> {
  final TextEditingController _messageController = TextEditingController();
  int _currentUserId = 0;
  List<dynamic> _messages = [];
  bool _isChatLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLocalUserData();
    _fetchDiscussions();
  }

  Future<void> _loadLocalUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUserId = prefs.getInt("user_id") ?? 0;
    });
  }

  Future<void> _fetchDiscussions() async {
    try {
      final response = await ApiService.get("/discussions");
      if (response != null && response['success'] == true) {
        final List<dynamic> allDiscussions = response['data'] ?? [];
        
        setState(() {
          _messages = allDiscussions.where((chat) {
            final cCode = chat['classroom'] != null ? chat['classroom']['class_code'] : chat['class_code'];
            return cCode.toString() == widget.classCode;
          }).toList();
        });
      }
    } catch (e) {
      debugPrint("Gagal mengambil diskusi: $e");
    } finally {
      setState(() => _isChatLoading = false);
    }
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final String message = _messageController.text.trim();
    _messageController.clear();

    try {
      final bodyPayload = {
        'class_code': widget.classCode,
        'message': message,
      };

      final response = await ApiService.post("/discussions", bodyPayload);

      if (response != null && response['success'] == true) {
        _fetchDiscussions();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim pesan ke server: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Diskusi Kelas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(widget.className, style: const TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
        backgroundColor: const Color(0xFF38B0FE),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchDiscussions,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isChatLoading
                ? const Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey),
                            SizedBox(height: 16),
                            Text('Belum ada diskusi di kelas ini.\nMulai percakapan sekarang!', 
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(15),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final msgData = _messages[index] as Map<String, dynamic>;
                          final int senderId = msgData['user_id'] ?? (msgData['user'] != null ? msgData['user']['id'] : 0);
                          final bool isMe = senderId == _currentUserId;
                          final String userRole = msgData['role'] ?? (msgData['user'] != null ? msgData['user']['role'] : 'student');
                          final bool isTeacher = userRole == 'teacher' || userRole == 'guru';
                          final String displaySenderName = msgData['sender_name'] ?? (msgData['user'] != null ? msgData['user']['name'] : 'User');

                          return _buildChatBubble(msgData, displaySenderName, isMe, isTeacher);
                        },
                      ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildChatBubble(Map<String, dynamic> data, String senderName, bool isMe, bool isTeacher) {
    String timeStr = '--:--';
    if (data['created_at'] != null) {
      try {
        final parsedDate = DateTime.parse(data['created_at']).toLocal();
        timeStr = "${parsedDate.hour.toString().padLeft(2, '0')}:${parsedDate.minute.toString().padLeft(2, '0')}";
      } catch (_) {}
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 4),
                child: Text(
                  "$senderName ${isTeacher ? '(Guru)' : ''}",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isTeacher ? Colors.orange[800] : Colors.blueGrey,
                  ),
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFF38B0FE) : (isTeacher ? Colors.orange[50] : Colors.grey[100]),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(15),
                  topRight: const Radius.circular(15),
                  bottomLeft: Radius.circular(isMe ? 15 : 0),
                  bottomRight: Radius.circular(isMe ? 0 : 15),
                ),
                border: isTeacher ? Border.all(color: Colors.orange.withValues(alpha: 0.3)) : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['message'] ?? '',
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black87,
                      fontSize: 15,
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

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Tulis pesan...',
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFF38B0FE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}