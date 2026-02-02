import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/core/constants/enums.dart';

import '../../../data/models/task_model.dart';
import '../../category/controller/category_controller.dart';

class TaskItemWidget extends StatelessWidget {
  final Task task;
  final Function(String)? onTap;

  const TaskItemWidget({super.key, required this.task, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Lookup category color
    Color categoryColor = Colors.transparent;
    try {
      if (task.categoryId != null) {
        final categoryController = Get.find<CategoryController>();
        // Note: Accessing controller inside a list item might be slightly inefficient if list is huge,
        // but okay for now. Better approach: Pass color as argument or use a Map in HomeController.
        final category = categoryController.categories.firstWhereOrNull(
          (c) => c.id == task.categoryId,
        );
        if (category != null) {
          categoryColor = Color(category.color);
        }
      }
    } catch (e) {
      // Controller not found or other error
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () => onTap?.call(task.id),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Category Indicator (Dot)
              if (task.categoryId != null) ...[
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(color: categoryColor, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
              ],

              // Priority/Status Indicator
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: _getPriorityColor(task.priority),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: task.status == TaskStatus.completed
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.status == TaskStatus.completed ? Colors.grey : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (task.dueDate != null)
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('hh:mm a').format(task.dueDate!),
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              // Checkbox (Visual only for now)
              Icon(
                task.status == TaskStatus.completed
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: task.status == TaskStatus.completed ? Colors.green : Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.green;
    }
  }
}
