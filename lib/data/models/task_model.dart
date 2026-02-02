import '/core/constants/db_constants.dart';
import '/core/constants/enums.dart';

class Task {
  final String id;
  final String title;
  final String? description;
  final String? categoryId;
  final TaskPriority priority;
  final TaskStatus status;
  final bool isDateBased;
  final DateTime? dueDate;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isRecurring;
  final String? recurrenceRule;
  final DateTime? reminderDateTime;
  final int? notificationId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.categoryId,
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.pending,
    this.isDateBased = false,
    this.dueDate,
    this.startDate,
    this.endDate,
    this.isRecurring = false,
    this.recurrenceRule,
    this.reminderDateTime,
    this.notificationId,
    required this.createdAt,
    required this.updatedAt,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? categoryId,
    TaskPriority? priority,
    TaskStatus? status,
    bool? isDateBased,
    DateTime? dueDate,
    DateTime? startDate,
    DateTime? endDate,
    bool? isRecurring,
    String? recurrenceRule,
    DateTime? reminderDateTime,
    int? notificationId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      isDateBased: isDateBased ?? this.isDateBased,
      dueDate: dueDate ?? this.dueDate,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      reminderDateTime: reminderDateTime ?? this.reminderDateTime,
      notificationId: notificationId ?? this.notificationId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DbConstants.colId: id,
      DbConstants.colTitle: title,
      DbConstants.colDescription: description,
      DbConstants.colCategoryId: categoryId,
      DbConstants.colPriority: priority.toStringValue(),
      DbConstants.colStatus: status.toStringValue(),
      DbConstants.colIsDateBased: isDateBased ? 1 : 0,
      DbConstants.colDueDate: dueDate?.toIso8601String(),
      DbConstants.colStartDate: startDate?.toIso8601String(),
      DbConstants.colEndDate: endDate?.toIso8601String(),
      DbConstants.colIsRecurring: isRecurring ? 1 : 0,
      DbConstants.colRecurrenceRule: recurrenceRule,
      DbConstants.colReminderDateTime: reminderDateTime?.toIso8601String(),
      DbConstants.colNotificationId: notificationId,
      DbConstants.colCreatedAt: createdAt.toIso8601String(),
      DbConstants.colUpdatedAt: updatedAt.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map[DbConstants.colId],
      title: map[DbConstants.colTitle],
      description: map[DbConstants.colDescription],
      categoryId: map[DbConstants.colCategoryId],
      priority: TaskPriority.fromString(map[DbConstants.colPriority]),
      status: TaskStatus.fromString(map[DbConstants.colStatus]),
      isDateBased: map[DbConstants.colIsDateBased] == 1,
      dueDate: map[DbConstants.colDueDate] != null
          ? DateTime.parse(map[DbConstants.colDueDate])
          : null,
      startDate: map[DbConstants.colStartDate] != null
          ? DateTime.parse(map[DbConstants.colStartDate])
          : null,
      endDate: map[DbConstants.colEndDate] != null
          ? DateTime.parse(map[DbConstants.colEndDate])
          : null,
      isRecurring: map[DbConstants.colIsRecurring] == 1,
      recurrenceRule: map[DbConstants.colRecurrenceRule],
      reminderDateTime: map[DbConstants.colReminderDateTime] != null
          ? DateTime.parse(map[DbConstants.colReminderDateTime])
          : null,
      notificationId: map[DbConstants.colNotificationId],
      createdAt: DateTime.parse(map[DbConstants.colCreatedAt]),
      updatedAt: DateTime.parse(map[DbConstants.colUpdatedAt]),
    );
  }
}
