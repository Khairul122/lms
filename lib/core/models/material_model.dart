class MaterialModel {
  final int id;
  final int classId;
  final String className;
  final int? meetingId;
  final String meetingName;
  final int? pertemuan;
  final String title;
  final String description;
  final String? fileUrl;
  final String? youtubeUrl;

  MaterialModel({
    required this.id,
    required this.classId,
    required this.className,
    this.meetingId,
    required this.meetingName,
    this.pertemuan,
    required this.title,
    required this.description,
    this.fileUrl,
    this.youtubeUrl,
  });

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      id: json["id"] ?? 0,
      classId: json["class_id"] ?? 0,
      className: json["class_name"] ?? "",
      meetingId: json["meeting_id"],
      meetingName: json["meeting_name"] ?? "",
      pertemuan: json["pertemuan"],
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      fileUrl: json["file_url"],
      youtubeUrl: json["youtube_url"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "class_id": classId,
        "class_name": className,
        "meeting_id": meetingId,
        "meeting_name": meetingName,
        "pertemuan": pertemuan,
        "title": title,
        "description": description,
        "file_url": fileUrl,
        "youtube_url": youtubeUrl,
      };
}
