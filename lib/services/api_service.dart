import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:guru/config/api_config.dart';

class ApiService {
  /// Header dasar untuk semua request API
/// Header dasar untuk semua request API
  static Future<Map<String, String>> _buildHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload(); // Memaksa reload data terbaru dari disk

    final token = prefs.getString("token");
    final allKeys = prefs.getKeys(); // Mengambil semua key yang ada di storage

    // 🔥 PRINT DEBUG UNTUK MELACAK ISI STORAGE
    print("=== DEBUG TOKEN ===");
    print("Key yang ada di SharedPreferences: $allKeys");
    print("Nilai dari key 'token': $token");
    if (prefs.containsKey("user")) print("Nilai dari key 'user': ${prefs.getString("user")}");
    print("====================");

    final Map<String, String> header = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "ngrok-skip-browser-warning": "true",
    };

    if (token != null && token.isNotEmpty) {
      header["Authorization"] = "Bearer $token";
    }

    return header;
  }

  /// =========================
  /// GET
  /// =========================
  static Future<dynamic> get(String endpoint) async {
    try {
      final h = await _buildHeaders();
      final response = await http.get(
        Uri.parse("${ApiConfig.baseUrl}$endpoint"),
        headers: h,
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Gagal terhubung ke server: $e'};
    }
  }

  /// =========================
  /// POST
  /// =========================
  static Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final h = await _buildHeaders();
      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}$endpoint"),
        headers: h,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Gagal terhubung ke server: $e'};
    }
  }

  /// =========================
  /// PUT
  /// =========================
  static Future<dynamic> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final h = await _buildHeaders();
      final response = await http.put(
        Uri.parse("${ApiConfig.baseUrl}$endpoint"),
        headers: h,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Gagal terhubung ke server: $e'};
    }
  }

  /// =========================
  /// DELETE
  /// =========================
  static Future<dynamic> delete(String endpoint) async {
    try {
      final h = await _buildHeaders();
      final response = await http.delete(
        Uri.parse("${ApiConfig.baseUrl}$endpoint"),
        headers: h,
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Gagal terhubung ke server: $e'};
    }
  }

  /// =========================
  /// HANDLE RESPONSE
  /// =========================
  static dynamic _handleResponse(http.Response response) {
    dynamic json;
    try {
      json = jsonDecode(response.body);
    } catch (_) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan internal server (${response.statusCode}).'
      };
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json;
    }

    if (json is Map) {
      return {
        'success': false,
        'message': json['message'] ?? 'Terjadi kesalahan (${response.statusCode})',
        'errors': json['errors'],
      };
    }

    return {
      'success': false,
      'message': 'Respon server tidak dikenali (${response.statusCode})',
    };
  }
}