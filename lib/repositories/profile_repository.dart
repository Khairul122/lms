import 'package:guru/services/api_service.dart';

class ProfileRepository {
  Future<Map<String, dynamic>> getProfile() async {
    final response = await ApiService.get("/profile");
    return Map<String, dynamic>.from(response);
  }

  Future<Map<String, dynamic>> updateProfile(
    Map<String, dynamic> body,
  ) async {
    final response = await ApiService.put(
      "/profile",
      body,
    );
    return Map<String, dynamic>.from(response);
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