class ClassModel {
  final int id;
  final String classCode;
  final String className;
  final String subject;
  final String teacher; // ganti String? jika ingin nullable
  final String description;
  final bool isActive;

  ClassModel({
    required this.id,
    required this.classCode,
    required this.className,
    required this.subject,
    required this.teacher,
    required this.description,
    required this.isActive,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    String parseTeacher(dynamic teacherData) {
      if (teacherData == null) return "Belum ada guru";
      if (teacherData is String) return teacherData;
      if (teacherData is Map) {
        return teacherData['name'] ?? "Guru Tidak Dikenal";
      }
      return "";
    }

    return ClassModel(
      id: json["id"] ?? 0,
      classCode: json["class_code"]?.toString() ?? "",
      className: json["class_name"]?.toString() ?? "",
      subject: json["subject"]?.toString() ?? "",
      teacher: parseTeacher(json["teacher"]),
      description: json["description"]?.toString() ?? "",
      isActive: json["is_active"] == 1 || json["is_active"] == true,
    );
  }
}