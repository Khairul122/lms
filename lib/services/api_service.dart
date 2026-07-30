import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lms/core/config/api_config.dart';

class ApiService {
  static String customBaseUrl = '';

  static String get baseUrl {
    if (customBaseUrl.isNotEmpty) return customBaseUrl;
    return ApiConfig.baseUrl;
  }

  // Helper jika butuh URL domain saja (tanpa /api)
  static String get rootUrl => baseUrl.replaceAll('/api', '');

  /// Helper untuk membangun Header secara dinamis termasuk Authorization Bearer Token
  static Future<Map<String, String>> _buildHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload(); // Memaksa sinkronisasi data terbaru dari disk storage

    final token = prefs.getString("token");

    final Map<String, String> header = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "ngrok-skip-browser-warning": "true",
      "localtonet-skip-warning": "true",
    };

    // Jika token Sanctum tersedia, langsung suntikkan ke header
    if (token != null && token.isNotEmpty) {
      header["Authorization"] = "Bearer $token";
    }

    return header;
  }

  /// ==========================================================
  /// METHOD HTTP REQUEST (GET, POST, PUT, DELETE)
  /// ==========================================================

  static Future<dynamic> get(String endpoint) async {
    try {
      final h = await _buildHeaders();
      final response = await http.get(Uri.parse("$baseUrl$endpoint"), headers: h);
      return _handleResponse(response);
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal terhubung ke server. Periksa koneksi internet/IP Backend.',
      };
    }
  }

  static Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final h = await _buildHeaders();
      final response = await http.post(
        Uri.parse("$baseUrl$endpoint"),
        headers: h,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal terhubung ke server. Periksa koneksi internet/IP Backend.',
      };
    }
  }

  static Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    try {
      final h = await _buildHeaders();
      final response = await http.put(
        Uri.parse("$baseUrl$endpoint"),
        headers: h,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal terhubung ke server. Periksa koneksi internet/IP Backend.',
      };
    }
  }

  static Future<dynamic> delete(String endpoint) async {
    try {
      final h = await _buildHeaders();
      final response = await http.delete(Uri.parse("$baseUrl$endpoint"), headers: h);
      return _handleResponse(response);
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal terhubung ke server. Periksa koneksi internet/IP Backend.',
      };
    }
  }

  /// 🔥 Validator Response Anti-Crash & Anti-Infinite Loading
  static dynamic _handleResponse(http.Response response) {
    dynamic jsonBody;

    // 1. Coba decode response body menjadi JSON Map/List
    try {
      jsonBody = jsonDecode(response.body);
    } catch (e) {
      print("❌ GAGAL PARSE JSON (${response.statusCode}):");
      print(response.body);
      return {
        'success': false,
        'message': 'Respon server bukan JSON valid (${response.statusCode}).',
      };
    }

    if (response.statusCode == 401) {
      SharedPreferences.getInstance().then((prefs) => prefs.remove("token"));
    }

    // 2. Jika HTTP Status Code 200 - 299 (Sukses)
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonBody;
    }

    // 3. Jika HTTP Status Error (400, 401, 404, 422, 500) tapi berupa Map JSON
    if (jsonBody is Map) {
      // Selalu pastikan ada key 'success' bernilai false agar mudah dibaca di UI
      return {
        'success': false,
        'message': jsonBody['message'] ?? 'Terjadi kesalahan (${response.statusCode})',
        'errors': jsonBody['errors'] ?? null,
      };
    }

    // Default Fallback
    return {
      'success': false,
      'message': 'Respon server tidak dikenali (${response.statusCode})',
    };
  }
}