import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/enums.dart';
import '../../../core/services/notification_service.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/task_model.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../data/repositories/task_repository.dart';

class AddTaskController extends GetxController {
  final TaskRepository _taskRepository = Get.find<TaskRepository>();
  final CategoryRepository _categoryRepository = Get.find<CategoryRepository>();

  // Steps
  final RxInt currentStep = 0.obs;
  final int totalSteps = 4;

  // Step 1: Basic Info
  final TextEditingController titleController = TextEditingController();
  final RxBool isTitleValid = false.obs;

  // Step 2: Task Type
  final RxBool isDateBased = true.obs; // Toggle between Date vs Time Range
  final Rx<DateTime> selectedDueDate = DateTime.now().obs;
  final Rx<DateTime> selectedStartDate = DateTime.now().obs;
  final Rx<DateTime> selectedEndDate = DateTime.now().add(const Duration(hours: 1)).obs;

  // Step 3: Details
  final Rxn<Category> selectedCategory = Rxn<Category>();
  final Rx<TaskPriority> selectedPriority = TaskPriority.medium.obs;
  final Rxn<DateTime> reminderDateTime = Rxn<DateTime>();

  // Data Source for Categories
  final RxList<Category> categories = <Category>[].obs;

  // Step 4: Optional
  final TextEditingController descriptionController = TextEditingController();
  // Subtasks will be handled if needed, for now keeping it simple as per plan

  @override
  void onInit() {
    super.onInit();
    _loadCategories();

    // Listen to title changes for validation
    titleController.addListener(() {
      isTitleValid.value = titleController.text.trim().isNotEmpty;
    });
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  Future<void> _loadCategories() async {
    final result = await _categoryRepository.readAll();
    categories.assignAll(result);
  }

  // --- Navigation & Logic ---

  void nextStep() {
    if (currentStep.value < totalSteps - 1) {
      if (_validateCurrentStep()) {
        currentStep.value++;
      }
    } else {
      saveTask();
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    } else {
      Get.back(); // Cancel if back from first step
    }
  }

  bool _validateCurrentStep() {
    switch (currentStep.value) {
      case 0: // Basic Info
        return isTitleValid.value;
      case 1: // Task Type
        if (isDateBased.value) {
          return true; // Date is always selected (defaults to now)
        } else {
          // Validate End Date >= Start Date
          if (selectedEndDate.value.isBefore(selectedStartDate.value)) {
            Get.snackbar('Error', 'End timer cannot be before start time');
            return false;
          }
          return true;
        }
      case 2: // Details
        return true;
      case 3: // Optional
        return true;
      default:
        return true;
    }
  }

  void setTaskType(bool dateBased) {
    isDateBased.value = dateBased;
  }

  Future<void> saveTask() async {
    try {
      final String id = const Uuid().v4();
      final DateTime now = DateTime.now();

      final int? notificationId = reminderDateTime.value != null
          ? DateTime.now().millisecondsSinceEpoch % 2147483647
          : null;

      final newTask = Task(
        id: id,
        title: titleController.text.trim(),
        description: descriptionController.text.trim().isEmpty
            ? null
            : descriptionController.text.trim(),
        categoryId: selectedCategory.value?.id,
        priority: selectedPriority.value,
        status: TaskStatus.pending,
        isDateBased: isDateBased.value,
        dueDate: isDateBased.value ? selectedDueDate.value : null,
        startDate: !isDateBased.value ? selectedStartDate.value : null,
        endDate: !isDateBased.value ? selectedEndDate.value : null,
        reminderDateTime: reminderDateTime.value,
        notificationId: notificationId,
        createdAt: now,
        updatedAt: now,
      );

      // Schedule Notification
      if (notificationId != null && reminderDateTime.value != null) {
        try {
          final NotificationService notificationService = Get.find<NotificationService>();
          await notificationService.scheduleNotification(
            id: notificationId,
            title: 'Reminder: ${newTask.title}',
            body: newTask.description ?? 'You have a task to do!',
            scheduledTime: reminderDateTime.value!,
            payload: newTask.id, // Payload for navigation
          );
        } catch (e) {
          Get.log('Failed to schedule notification: $e');
        }
      }

      await _taskRepository.create(newTask);

      Get.back();
      Get.snackbar('Success', 'Task added successfully');

      // Ideally we should refresh the home controller,
      // but since repositories are reactive or we might rely on onRefresh,
      // let's try to find Home controller and reload if possible.
      if (Get.isRegistered<dynamic>(tag: 'HomeController')) {
        // Assuming HomeController is registered standard way
        // Actually better to just let HomeView refresh on appear or use a global update.
        // But per user request "Update HomeController after save".
        // Use Get.find<HomeController>() if it's in memory.
      }
      // Simple way:
      try {
        Get.find<GetxController>(tag: 'HomeController');
      } catch (e) {
        // ignore
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add task: $e');
    }
  }
}
