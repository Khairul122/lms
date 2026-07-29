class MeetingModel {
  final int id;
  final int classId;
  final String className;
  final int pertemuan;
  final String namaPertemuan;
  final String temaPertemuan;

  MeetingModel({
    required this.id,
    required this.classId,
    required this.className,
    required this.pertemuan,
    required this.namaPertemuan,
    required this.temaPertemuan,
  });

  factory MeetingModel.fromJson(Map<String, dynamic> json) {
    return MeetingModel(
      id: json["id"],
      classId: json["class_id"],
      className: json["class_name"] ?? "",
      pertemuan: json["pertemuan"] ?? 0,
      namaPertemuan: json["nama_pertemuan"] ?? "",
      temaPertemuan: json["tema_pertemuan"] ?? "",
    );
  }
}