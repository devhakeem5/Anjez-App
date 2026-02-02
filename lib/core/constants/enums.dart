enum TaskPriority {
  low,
  medium,
  high;

  String toStringValue() => name; // e.g., "low"

  static TaskPriority fromString(String value) {
    return TaskPriority.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TaskPriority.medium, // Default fallback
    );
  }
}

enum TaskStatus {
  pending,
  inProgress,
  completed,
  overdue;

  String toStringValue() => name;

  static TaskStatus fromString(String value) {
    return TaskStatus.values.firstWhere((e) => e.name == value, orElse: () => TaskStatus.pending);
  }
}
