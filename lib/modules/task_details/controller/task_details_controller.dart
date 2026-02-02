import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/enums.dart';
import '../../../core/services/notification_service.dart';
import '../../../data/models/subtask_model.dart';
import '../../../data/models/task_model.dart';
import '../../../data/repositories/subtask_repository.dart';
import '../../../data/repositories/task_repository.dart';

class TaskDetailsController extends GetxController {
  final TaskRepository _taskRepository = Get.find<TaskRepository>();
  final SubTaskRepository _subTaskRepository = Get.find<SubTaskRepository>();
  final NotificationService _notificationService = Get.find<NotificationService>();

  final Rxn<Task> task = Rxn<Task>();
  final RxList<Subtask> subtasks = <Subtask>[].obs;
  final RxBool isLoading = true.obs;

  final TextEditingController notesController = TextEditingController();
  final TextEditingController subtaskController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final String? taskId = Get.arguments as String?;
    if (taskId != null) {
      loadTask(taskId);
    } else {
      Get.back();
      Get.snackbar('Error', 'Task ID not provided');
    }
  }

  @override
  void onClose() {
    notesController.dispose();
    subtaskController.dispose();
    super.onClose();
  }

  Future<void> loadTask(String id) async {
    isLoading.value = true;
    try {
      final loadedTask = await _taskRepository.read(id);
      if (loadedTask != null) {
        task.value = loadedTask;
        notesController.text = loadedTask.description ?? '';

        // Load subtasks
        final loadedSubtasks = await _subTaskRepository.readByTaskId(id);
        subtasks.assignAll(loadedSubtasks);
      } else {
        Get.back();
        Get.snackbar('Error', 'Task not found');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load task: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateStatus(TaskStatus status) async {
    if (task.value == null) return;

    final updatedTask = task.value!.copyWith(status: status);
    task.value = updatedTask; // update UI immediately

    await _taskRepository.update(updatedTask);

    // If completed, cancel notification
    if (status == TaskStatus.completed && updatedTask.notificationId != null) {
      await _notificationService.cancelNotification(updatedTask.notificationId!);
    }

    _refreshHome();
  }

  Future<void> updatePriority(TaskPriority priority) async {
    if (task.value == null) return;

    final updatedTask = task.value!.copyWith(priority: priority);
    task.value = updatedTask;

    await _taskRepository.update(updatedTask);
    _refreshHome();
  }

  Future<void> saveNotes() async {
    if (task.value == null) return;

    // Only update if changed
    if (notesController.text.trim() == (task.value!.description ?? '')) return;

    final updatedTask = task.value!.copyWith(description: notesController.text.trim());
    task.value = updatedTask;

    await _taskRepository.update(updatedTask);
    Get.snackbar('Success', 'Notes saved');
    _refreshHome();
  }

  // --- SubTasks ---

  Future<void> addSubTask() async {
    if (task.value == null) return;
    if (subtaskController.text.trim().isEmpty) return;

    final newSubtask = Subtask(
      id: const Uuid().v4(),
      taskId: task.value!.id,
      title: subtaskController.text.trim(),
    );

    subtasks.add(newSubtask);
    subtaskController.clear();

    await _subTaskRepository.create(newSubtask);
  }

  Future<void> toggleSubTask(Subtask subtask) async {
    final updatedSubtask = subtask.copyWith(isCompleted: !subtask.isCompleted);

    // Update local list
    final index = subtasks.indexWhere((e) => e.id == subtask.id);
    if (index != -1) {
      subtasks[index] = updatedSubtask;
    }

    await _subTaskRepository.update(updatedSubtask);
  }

  Future<void> deleteSubTask(String id) async {
    subtasks.removeWhere((e) => e.id == id);
    await _subTaskRepository.delete(id);
  }

  void _refreshHome() {
    try {
      if (Get.isRegistered<dynamic>(tag: 'HomeController')) {
        // Optionally find controller and call refresh if exposed
      }
      // Relying on onRefresh or GetX reactivity if structured correctly.
      // For now, this is enough as Home will reload when we go back if we trigger it.
    } catch (_) {}
  }
}
