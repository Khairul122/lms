import 'package:flutter/material.dart';
import 'package:lms/core/widgets/app_dialog.dart';

class KomentarScreen extends StatefulWidget {
  const KomentarScreen({super.key});

  @override
  State<KomentarScreen> createState() => _KomentarScreenState();
}

class Comment {
  final String message;
  final bool isFromUser;
  final String initial;
  final Color avatarColor;

  Comment({
    required this.message,
    required this.isFromUser,
    required this.initial,
    required this.avatarColor,
  });
}

class _KomentarScreenState extends State<KomentarScreen> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  final List<Comment> _comments = [
    Comment(
      message: 'Terima kasih Pak, materinya sangat jelas dan mudah dipahami.',
      isFromUser: false,
      initial: 'A',
      avatarColor: Color(0xFF1E88E5),
    ),
    Comment(
      message:
          'Pak, boleh nanya, kalau nilai tugas dikumpulin telat dikurangin gak ya?',
      isFromUser: false,
      initial: 'B',
      avatarColor: Color(0xFF42A5F5),
    ),
    Comment(
      message:
          'Pak, yang tugas nomor 3 itu maksudnya gimana ya? Aku udah coba tapi masih belum paham',
      isFromUser: false,
      initial: 'C',
      avatarColor: Color(0xFF00ACC1),
    ),
  ];

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendComment() {
    if (_commentController.text.trim().isNotEmpty) {
      setState(() {
        _comments.add(
          Comment(
            message: _commentController.text.trim(),
            isFromUser: true,
            initial: 'E',
            avatarColor: Color(0xFF42A5F5),
          ),
        );
      });
      _commentController.clear();
      _focusNode.unfocus();

      // Auto scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
      AppDialog.showError(context, 'Komentar tidak boleh kosong!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header dengan biru muda
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF42A5F5),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 15),
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

          // Content
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title "Komentar Kelas"
                  Text(
                    'Komentar Kelas',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  SizedBox(height: 30),

                  // List Komentar
                  ..._comments.asMap().entries.map((entry) {
                    int index = entry.key;
                    Comment comment = entry.value;
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index < _comments.length - 1 ? 20 : 20,
                      ),
                      child: comment.isFromUser
                          ? _buildOutgoingComment(comment)
                          : _buildIncomingComment(comment),
                    );
                  }),

                  SizedBox(height: 20), // Space untuk bottom input
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Input Field
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  focusNode: _focusNode,
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendComment(),
                  decoration: InputDecoration(
                    hintText: 'Tulis komentar Anda di sini...',
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Color(0xFF42A5F5),
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Color(0xFF42A5F5),
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Color(0xFF42A5F5),
                        width: 2,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF42A5F5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: _sendComment,
                  icon: Icon(Icons.send, color: Colors.white, size: 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Incoming comment (from others) - left aligned
  Widget _buildIncomingComment(Comment comment) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: comment.avatarColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              comment.initial,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        // Message Bubble
        Expanded(
          child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Color(0xFF42A5F5),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              comment.message,
              style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  // Outgoing comment (from user) - right aligned
  Widget _buildOutgoingComment(Comment comment) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Message Bubble
        Expanded(
          child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Color(0xFF42A5F5),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              comment.message,
              style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
            ),
          ),
        ),
        SizedBox(width: 12),
        // Avatar
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: comment.avatarColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              comment.initial,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
