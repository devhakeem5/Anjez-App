import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/enums.dart';
import '../controller/task_details_controller.dart';

class TaskDetailsView extends GetView<TaskDetailsController> {
  const TaskDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Trigger home refresh on back if needed or just back
            Get.back(result: true);
          },
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final task = controller.task.value;
        if (task == null) {
          return const Center(child: Text('Task not found'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Title & Status
              _buildHeader(context, task),
              const SizedBox(height: 24),

              // Task Info Card
              _buildTaskInfo(context, task),
              const SizedBox(height: 24),

              // Subtasks Section
              _buildSubtasksSection(context),
              const SizedBox(height: 24),

              // Notes Section
              _buildNotesSection(context),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                task.title,
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            _buildStatusChip(context, task.status),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusChip(BuildContext context, TaskStatus currentStatus) {
    return PopupMenuButton<TaskStatus>(
      initialValue: currentStatus,
      onSelected: (TaskStatus status) {
        controller.updateStatus(status);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<TaskStatus>>[
        const PopupMenuItem<TaskStatus>(value: TaskStatus.pending, child: Text('Pending')),
        const PopupMenuItem<TaskStatus>(value: TaskStatus.inProgress, child: Text('In Progress')),
        const PopupMenuItem<TaskStatus>(value: TaskStatus.completed, child: Text('Completed')),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _getStatusColor(currentStatus).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _getStatusColor(currentStatus)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currentStatus.name.capitalizeFirst!,
              style: TextStyle(color: _getStatusColor(currentStatus), fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 4),
            Icon(Icons.arrow_drop_down, size: 18, color: _getStatusColor(currentStatus)),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Colors.orange;
      case TaskStatus.inProgress:
        return Colors.blue;
      case TaskStatus.completed:
        return Colors.green;
      case TaskStatus.overdue:
        return Colors.red;
    }
  }

  Widget _buildTaskInfo(BuildContext context, dynamic task) {
    final theme = Theme.of(context);
    String dateText = '';
    if (task.isDateBased && task.dueDate != null) {
      dateText = DateFormat('EEE, MMM d, y').format(task.dueDate!);
    } else if (!task.isDateBased && task.startDate != null) {
      dateText =
          '${DateFormat('MMM d').format(task.startDate!)} - ${DateFormat('MMM d').format(task.endDate ?? task.startDate!)}';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Date Row
            Row(
              children: [
                Icon(
                  task.isDateBased ? Icons.calendar_today : Icons.date_range,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(dateText, style: theme.textTheme.bodyLarge),
              ],
            ),
            const Divider(height: 24),
            // Priority Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.flag, color: theme.colorScheme.primary),
                    const SizedBox(width: 12),
                    Text('Priority', style: theme.textTheme.bodyLarge),
                  ],
                ),
                SegmentedButton<TaskPriority>(
                  segments: const [
                    ButtonSegment(
                      value: TaskPriority.low,
                      label: Text('Low'),
                      icon: Icon(Icons.low_priority),
                    ),
                    ButtonSegment(
                      value: TaskPriority.medium,
                      label: Text('Med'),
                      icon: Icon(Icons.playlist_play),
                    ),
                    ButtonSegment(
                      value: TaskPriority.high,
                      label: Text('High'),
                      icon: Icon(Icons.priority_high),
                    ),
                  ],
                  selected: {task.priority},
                  onSelectionChanged: (Set<TaskPriority> newSelection) {
                    controller.updatePriority(newSelection.first);
                  },
                  style: ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                  ),
                  showSelectedIcon: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubtasksSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Subtasks', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Obx(
          () => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.subtasks.length,
            itemBuilder: (context, index) {
              final subtask = controller.subtasks[index];
              return Dismissible(
                key: Key(subtask.id),
                onDismissed: (_) {
                  controller.deleteSubTask(subtask.id);
                },
                background: Container(color: Colors.red),
                child: CheckboxListTile(
                  title: Text(
                    subtask.title,
                    style: TextStyle(
                      decoration: subtask.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  value: subtask.isCompleted,
                  onChanged: (bool? value) {
                    controller.toggleSubTask(subtask);
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
              );
            },
          ),
        ),
        // Add Subtask Row
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.subtaskController,
                decoration: const InputDecoration(
                  hintText: 'Add a subtask...',
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => controller.addSubTask(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.blue),
              onPressed: () => controller.addSubTask(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Notes', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        TextField(
          controller: controller.notesController,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Add notes here...',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) {
            // Debounce or save on button? Requirement: "Save directly"
            // For better UX, let's add a save button or rely on back.
            // But user asked for "Quick edit and save".
            // Let's add a small save action or save on un-focus.
            // For now, let's just leave it and have a "Save Notes" button or auto-save.
          },
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              controller.saveNotes();
            },
            child: const Text('Save Notes'),
          ),
        ),
      ],
    );
  }
}
