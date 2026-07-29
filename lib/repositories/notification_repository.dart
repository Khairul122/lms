import 'package:guru/services/api_service.dart';

class NotificationRepository {
  Future<List<dynamic>> getNotifications() async {
    final response = await ApiService.get("/notifications");
    return List<dynamic>.from(response["data"]);
  }

  Future<Map<String, dynamic>> createNotification(Map<String, dynamic> body) async {
    final response = await ApiService.post("/notifications", body);
    return Map<String, dynamic>.from(response);
  }

  Future<Map<String, dynamic>> updateNotification(int id, Map<String, dynamic> body) async {
    final response = await ApiService.put("/notifications/$id", body);
    return Map<String, dynamic>.from(response);
  }

  Future<Map<String, dynamic>> deleteNotification(int id) async {
    final response = await ApiService.delete("/notifications/$id");
    return Map<String, dynamic>.from(response);
  }
}