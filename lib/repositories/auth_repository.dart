import 'package:guru/services/api_service.dart';

class AuthRepository {
  Future<Map<String, dynamic>> firebaseLogin({
    required String email,
  }) async {
    return await ApiService.post(
      "/firebase-login",
      {
        "email": email,
      },
    );
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String username,
    required String email,
    required String password,
    required String nip,
    required String phone,
  }) async {
    return await ApiService.post(
      "/register",
      {
        "name": name,
        "username": username,
        "email": email,
        "password": password,
        "password_confirmation": password,
        "role": "guru",
        "nip": nip,
        "phone": phone,
      },
    );
  }

  Future<Map<String, dynamic>> profile() async {
    final response = await ApiService.get("/profile");
    
    // Cek jika API mengembalikan key 'data' (standar Laravel)
    if (response["data"] != null && response["data"] is Map) {
      return Map<String, dynamic>.from(response["data"]);
    } 
    // Fallback jika API mengembalikan key 'user'
    else if (response["user"] != null && response["user"] is Map) {
      return Map<String, dynamic>.from(response["user"]);
    } 
    // Fallback jika response langsung berupa data Map profile
    else {
      return Map<String, dynamic>.from(response);
    }
  }
}