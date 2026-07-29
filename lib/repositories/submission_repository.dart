import 'package:guru/services/api_service.dart';

class SubmissionRepository {
  Future<List<dynamic>> getSubmissions() async {
    final response = await ApiService.get("/submissions");
    return List<dynamic>.from(response["data"]);
  }

  Future<Map<String, dynamic>> createSubmission(Map<String, dynamic> body) async {
    return await ApiService.post("/submissions", body);
  }
}

