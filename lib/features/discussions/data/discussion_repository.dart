import 'package:guru/services/api_service.dart';

class DiscussionRepository {
  Future<List<dynamic>> getDiscussions(String classCode) async {
    final response = await ApiService.get(
      "/discussions?class_code=$classCode",
    );
    return List<dynamic>.from(response["data"]);
  }

  Future<void> sendDiscussion({
    required String classCode,
    required String message,
  }) async {
    await ApiService.post(
      "/discussions",
      {
        "class_code": classCode,
        "message": message,
      },
    );
  }
}