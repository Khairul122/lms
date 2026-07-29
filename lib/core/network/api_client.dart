import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:guru/core/config/api_config.dart';

/// Pure HTTP wrapper - no domain logic. Feature repositories build on top of this.
class ApiClient {
  static Future<Map<String, String>> _buildHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();

    final token = prefs.getString("token");

    final Map<String, String> header = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "ngrok-skip-browser-warning": "true",
      "localtonet-skip-warning": "true",
    };

    if (token != null && token.isNotEmpty) {
      header["Authorization"] = "Bearer $token";
    }

    return header;
  }

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

  static Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
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

  static Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
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

  static dynamic _handleResponse(http.Response response) {
    dynamic json;
    try {
      json = jsonDecode(response.body);
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
