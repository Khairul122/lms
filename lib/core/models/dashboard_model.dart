class DashboardModel {
  final int totalGuru;
  final int totalSiswa;
  final int totalKelas;
  final int totalPertemuan;
  final int totalMateri;
  final int totalTugas;
  final int totalSubmission;

  DashboardModel({
    required this.totalGuru,
    required this.totalSiswa,
    required this.totalKelas,
    required this.totalPertemuan,
    required this.totalMateri,
    required this.totalTugas,
    required this.totalSubmission,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    final stats = json["statistics"];

    return DashboardModel(
      totalGuru: stats["total_guru"] ?? 0,
      totalSiswa: stats["total_siswa"] ?? 0,
      totalKelas: stats["total_kelas"] ?? 0,
      totalPertemuan: stats["total_pertemuan"] ?? 0,
      totalMateri: stats["total_materi"] ?? 0,
      totalTugas: stats["total_tugas"] ?? 0,
      totalSubmission: stats["total_submission"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "statistics": {
          "total_guru": totalGuru,
          "total_siswa": totalSiswa,
          "total_kelas": totalKelas,
          "total_pertemuan": totalPertemuan,
          "total_materi": totalMateri,
          "total_tugas": totalTugas,
          "total_submission": totalSubmission,
        },
      };
}
