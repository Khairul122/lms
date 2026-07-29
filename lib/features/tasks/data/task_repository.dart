import 'package:guru/services/api_service.dart';

class TaskRepository {
  /// Menyimpan tugas baru ke backend Laravel
  Future<Map<String, dynamic>> createTask(Map<String, dynamic> body) async {
    return await ApiService.post(
      "/tasks",
      body,
    );
  }
}