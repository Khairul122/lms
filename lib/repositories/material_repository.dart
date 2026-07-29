import 'package:guru/services/api_service.dart';

class MaterialRepository {
  /// 1. Ambil seluruh daftar materi (atau difilter berdasarkan meeting_id)
  Future<List<dynamic>> getMaterials({int? meetingId}) async {
    final String endpoint = meetingId != null 
        ? "/materials?meeting_id=$meetingId" 
        : "/materials";

    final response = await ApiService.get(endpoint);
    return List<dynamic>.from(response["data"] ?? []);
  }

  /// 2. Simpan materi baru ke Laravel REST API
  Future<Map<String, dynamic>> saveMaterial({
    required int meetingId,
    required String judulMateri,
    required String deskripsi,
    String? fileUrl,
  }) async {
    final response = await ApiService.post(
      "/materials",
      {
        "meeting_id": meetingId,
        "judul_materi": judulMateri,
        "deskripsi": deskripsi,
        "file_url": fileUrl ?? "",
      },
    );

    return response;
  }

  /// 3. Hapus materi berdasarkan ID
  Future<void> deleteMaterial(int materialId) async {
    await ApiService.delete("/materials/$materialId");
  }
}