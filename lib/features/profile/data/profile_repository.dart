import 'package:guru/services/api_service.dart';

class ProfileRepository {
  Future<Map<String, dynamic>> getProfile() async {
    final response = await ApiService.get("/profile");
    if (response != null && response is Map) {
      if (response["data"] != null && response["data"] is Map) {
        return Map<String, dynamic>.from(response["data"]);
      }
      return Map<String, dynamic>.from(response);
    }
    return {};
  }

  Future<Map<String, dynamic>> updateProfile(
    Map<String, dynamic> body,
  ) async {
    final response = await ApiService.put(
      "/profile",
      body,
    );
    if (response != null && response is Map) {
      if (response["user"] != null && response["user"] is Map) {
        return Map<String, dynamic>.from(response["user"]);
      }
      if (response["data"] != null && response["data"] is Map) {
        return Map<String, dynamic>.from(response["data"]);
      }
      return Map<String, dynamic>.from(response);
    }
    return {};
  }

  Future<void> updatePhoto(String photoUrl) async {
    await ApiService.put(
      "/profile",
      {
        "photo": photoUrl,
      },
    );
  }
}