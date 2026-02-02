import '/core/constants/db_constants.dart';

class Subtask {
  final String id;
  final String taskId;
  final String title;
  final bool isCompleted;

  Subtask({required this.id, required this.taskId, required this.title, this.isCompleted = false});

  Subtask copyWith({String? id, String? taskId, String? title, bool? isCompleted}) {
    return Subtask(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DbConstants.colId: id,
      DbConstants.colTaskId: taskId,
      DbConstants.colTitle: title,
      DbConstants.colIsCompleted: isCompleted ? 1 : 0,
    };
  }

  factory Subtask.fromMap(Map<String, dynamic> map) {
    return Subtask(
      id: map[DbConstants.colId],
      taskId: map[DbConstants.colTaskId],
      title: map[DbConstants.colTitle],
      isCompleted: map[DbConstants.colIsCompleted] == 1,
    );
  }
}
