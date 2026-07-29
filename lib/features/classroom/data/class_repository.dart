import 'package:flutter/material.dart';
import 'package:guru/services/api_service.dart';

class ClassRepository {
  /// 1. Ambil semua kelas milik guru
  Future<List<dynamic>> getClasses() async {
    try {
      final response = await ApiService.get("/classes");

      if (response != null && response is Map) {
        if (response["data"] != null && response["data"] is List) {
          return List<dynamic>.from(response["data"]);
        }
      } else if (response is List) {
        return List<dynamic>.from(response);
      }
      
      return [];
    } catch (e) {
      debugPrint("CLASS REPO GET CLASSES ERROR: $e");
      return [];
    }
  }
  

  /// 2. Ambil detail satu kelas berdasarkan ID
  Future<Map<String, dynamic>> getClass(int id) async {
    try {
      final response = await ApiService.get("/classes/$id");

      if (response != null && response is Map) {
        if (response["data"] != null && response["data"] is Map) {
          return Map<String, dynamic>.from(response["data"]);
        }
        return Map<String, dynamic>.from(response);
      }
      return {};
    } catch (e) {
      debugPrint("CLASS REPO GET CLASS DETAIL ERROR: $e");
      return {};
    }
  }

  /// 3. Buat kelas baru
  Future<Map<String, dynamic>> createClass(
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await ApiService.post("/classes", body);

      if (response != null && response is Map) {
        return Map<String, dynamic>.from(response);
      }
      return {};
    } catch (e) {
      debugPrint("CLASS REPO CREATE CLASS ERROR: $e");
      return {};
    }
  }

  /// 4. Update data kelas berdasarkan ID
  Future<Map<String, dynamic>> updateClass(
    int id,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await ApiService.put("/classes/$id", body);

      if (response != null && response is Map) {
        return Map<String, dynamic>.from(response);
      }
      return {};
    } catch (e) {
      debugPrint("CLASS REPO UPDATE CLASS ERROR: $e");
      return {};
    }
  }

  /// 5. Hapus kelas berdasarkan ID
  Future<Map<String, dynamic>> deleteClass(int id) async {
    try {
      final response = await ApiService.delete("/classes/$id");

      if (response != null && response is Map) {
        return Map<String, dynamic>.from(response);
      }
      return {};
    } catch (e) {
      debugPrint("CLASS REPO DELETE CLASS ERROR: $e");
      return {};
    }
  }
}