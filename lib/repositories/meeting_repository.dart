import 'package:flutter/material.dart';
import 'package:guru/services/api_service.dart';

class MeetingRepository {
  /// 1. Ambil daftar pertemuan dari Laravel REST API
  /// Opsional: Bisa dipanggil polosan getMeetings() atau dengan filter getMeetings(classCode: 'HX9E4S')
  Future<List<dynamic>> getMeetings({String? classCode}) async {
    try {
      final String endpoint = (classCode != null && classCode.isNotEmpty)
          ? "/meetings?class_code=$classCode"
          : "/meetings";

      debugPrint("FETCHING MEETINGS FROM: $endpoint");

      final response = await ApiService.get(endpoint);

      if (response != null) {
        if (response is Map && response['data'] != null && response['data'] is List) {
          return List<dynamic>.from(response['data']);
        } else if (response is List) {
          return List<dynamic>.from(response);
        }
      }

      debugPrint("MEETING REPO: Data pertemuan kosong atau response null");
      return [];
    } catch (e) {
      debugPrint("MEETING REPO GET MEETINGS EXCEPTION: $e");
      return [];
    }
  }

  /// 2. Tambah pertemuan baru
  Future<bool> createMeeting({
    required String classCode,
    required String namaPertemuan,
    required String temaPertemuan,
  }) async {
    try {
      final response = await ApiService.post("/meetings", {
        'class_code': classCode,
        'nama_pertemuan': namaPertemuan,
        'tema_pertemuan': temaPertemuan,
      });

      if (response != null && (response['success'] == true || response['status'] == 'success')) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("CREATE MEETING EXCEPTION: $e");
      return false;
    }
  }

  /// 3. Hapus pertemuan berdasarkan ID
  Future<bool> deleteMeeting(dynamic meetingId) async {
    try {
      final response = await ApiService.delete("/meetings/$meetingId");

      if (response != null && (response['success'] == true || response['status'] == 'success')) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("DELETE MEETING EXCEPTION: $e");
      return false;
    }
  }
}