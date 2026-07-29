class TaskModel {
  final int id;
  final String title;
  final String description;
  final String deadline;
  final int maxScore;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.maxScore,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json["id"],
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      deadline: json["deadline"] ?? "",
      maxScore: json["max_score"] ?? 100,
    );
  }
}