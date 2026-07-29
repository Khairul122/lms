class SubmissionModel {
  final int id;
  final int? taskId;
  final String? task;
  final String? student;
  final String? filePath;
  final String? note;
  final num? score;
  final String? teacherNote;
  final String? submittedAt;

  SubmissionModel({
    required this.id,
    this.taskId,
    this.task,
    this.student,
    this.filePath,
    this.note,
    this.score,
    this.teacherNote,
    this.submittedAt,
  });

  factory SubmissionModel.fromJson(Map<String, dynamic> json) {
    return SubmissionModel(
      id: json["id"] ?? 0,
      taskId: json["task_id"],
      task: json["task"]?.toString(),
      student: json["student"]?.toString(),
      filePath: json["file_path"],
      note: json["note"],
      score: json["score"],
      teacherNote: json["teacher_note"],
      submittedAt: json["submitted_at"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "task_id": taskId,
        "task": task,
        "student": student,
        "file_path": filePath,
        "note": note,
        "score": score,
        "teacher_note": teacherNote,
        "submitted_at": submittedAt,
      };
}
