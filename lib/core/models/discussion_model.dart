class DiscussionModel {
  final int id;
  final String? classCode;
  final String? className;
  final String? userName;
  final String message;
  final String? createdAt;

  DiscussionModel({
    required this.id,
    this.classCode,
    this.className,
    this.userName,
    required this.message,
    this.createdAt,
  });

  factory DiscussionModel.fromJson(Map<String, dynamic> json) {
    return DiscussionModel(
      id: json["id"] ?? 0,
      classCode: json["class_code"],
      className: json["class_name"],
      userName: json["user_name"],
      message: json["message"] ?? "",
      createdAt: json["created_at"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "class_code": classCode,
        "class_name": className,
        "user_name": userName,
        "message": message,
        "created_at": createdAt,
      };
}
