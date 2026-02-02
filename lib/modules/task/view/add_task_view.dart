import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/enums.dart';
import '../controller/add_task_controller.dart';

class AddTaskView extends GetView<AddTaskController> {
  const AddTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('New Task', style: Get.theme.appBarTheme.titleTextStyle),
        backgroundColor: Get.theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Get.theme.iconTheme.color),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // Progress Indicator
          Obx(
            () => LinearProgressIndicator(
              value: (controller.currentStep.value + 1) / controller.totalSteps,
              color: Get.theme.primaryColor,
              backgroundColor: Get.theme.dividerColor,
            ),
          ),

          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(), // Managed by controller
              // We'll use IndexedStack or just render current step for simplicity and performance
              children: [Obx(() => _buildCurrentStep(controller.currentStep.value))],
            ),
          ),

          // Bottom Actions
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildCurrentStep(int step) {
    switch (step) {
      case 0:
        return _buildStep1BasicInfo();
      case 1:
        return _buildStep2TaskType();
      case 2:
        return _buildStep3Details();
      case 3:
        return _buildStep4Optional();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStep1BasicInfo() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What needs to be done?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: controller.titleController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Enter task title',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Get.theme.primaryColor, width: 2),
              ),
            ),
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2TaskType() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'When do you want to do it?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // Toggle
          Row(
            children: [
              _buildTypeOption(label: 'Specific Date', isDate: true),
              const SizedBox(width: 16),
              _buildTypeOption(label: 'Time Period', isDate: false),
            ],
          ),

          const SizedBox(height: 32),

          // Date Picker / Time Range Picker
          if (controller.isDateBased.value)
            _buildDatePicker(
              label: 'Due Date',
              selectedDate: controller.selectedDueDate.value,
              onTap: () async {
                final picked = await showDatePicker(
                  context: Get.context!,
                  initialDate: controller.selectedDueDate.value,
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                );
                if (picked != null) controller.selectedDueDate.value = picked;
              },
            )
          else
            Column(
              children: [
                _buildDatePicker(
                  label: 'Start Date',
                  selectedDate: controller.selectedStartDate.value,
                  onTap: () async {
                    // Logic for picking start
                    final picked = await showDatePicker(
                      context: Get.context!,
                      initialDate: controller.selectedStartDate.value,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      controller.selectedStartDate.value = picked;
                      // Auto adjust end date if needed?
                    }
                  },
                ),
                const SizedBox(height: 16),
                _buildDatePicker(
                  label: 'End Date',
                  selectedDate: controller.selectedEndDate.value,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: Get.context!,
                      initialDate: controller.selectedEndDate.value,
                      firstDate: controller.selectedStartDate.value,
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) controller.selectedEndDate.value = picked;
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTypeOption({required String label, required bool isDate}) {
    final isSelected = controller.isDateBased.value == isDate;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.setTaskType(isDate),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? Get.theme.colorScheme.primary.withOpacity(0.1)
                : Get.theme.cardTheme.color,
            border: Border.all(
              color: isSelected ? Get.theme.colorScheme.primary : Get.theme.dividerColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(
                isDate ? Icons.calendar_today : Icons.schedule,
                color: isSelected ? Get.theme.colorScheme.primary : Get.theme.iconTheme.color,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Get.theme.colorScheme.primary : Get.theme.disabledColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime selectedDate,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Get.theme.dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_month, color: Get.theme.iconTheme.color),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Get.theme.disabledColor)),
                Text(
                  selectedDate.toString().split(' ')[0], // Simple format
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep3Details() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Details', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),

          // Priority
          const Text('Priority', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Obx(
            () => Row(
              // Priority Segmented Control
              children: [
                _buildPriorityChip('Low', Colors.green),
                const SizedBox(width: 12),
                _buildPriorityChip('Medium', Colors.amber),
                const SizedBox(width: 12),
                _buildPriorityChip('High', Colors.red),
              ],
            ),
          ),

          const Divider(height: 48),

          // Categories
          const Text('Category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          // Simple dropdown or list
          Obx(() {
            if (controller.categories.isEmpty) return const Text('No categories found.');
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.categories.map((cat) {
                final isSelected = controller.selectedCategory.value?.id == cat.id;
                return FilterChip(
                  label: Text(cat.name),
                  selected: isSelected,
                  onSelected: (val) {
                    controller.selectedCategory.value = val ? cat : null;
                  },
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPriorityChip(String label, Color color) {
    // Naive mapping from string to Enum for check
    // Assuming label matches enum values slightly or we hardcode logic
    // Low -> TaskPriority.low

    // Helper for comparison
    bool isSelected = false;
    if (label == 'Low' && controller.selectedPriority.value.toString().contains('low')) {
      isSelected = true;
    }
    if (label == 'Medium' && controller.selectedPriority.value.toString().contains('medium')) {
      isSelected = true;
    }
    if (label == 'High' && controller.selectedPriority.value.toString().contains('high')) {
      isSelected = true;
    }

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: color.withOpacity(0.2),
      labelStyle: TextStyle(color: isSelected ? color : Get.theme.textTheme.bodyLarge?.color),
      onSelected: (val) {
        if (val) {
          if (label == 'Low') {
            controller.selectedPriority.value = (TaskPriority.values.firstWhere(
              (e) => e.toString().contains('low'),
            ));
          }
          if (label == 'Medium') {
            controller.selectedPriority.value = (TaskPriority.values.firstWhere(
              (e) => e.toString().contains('medium'),
            ));
          }
          if (label == 'High') {
            controller.selectedPriority.value = (TaskPriority.values.firstWhere(
              (e) => e.toString().contains('high'),
            ));
          }
          // Fix: TaskPriority is imported, but we need exact enum.
          // Ideally we use Enum values directly.
          // Let's assume the Enum import is visible.
          // TaskPriority.low, TaskPriority.medium, TaskPriority.high are likely available.
          if (label == 'Low') controller.selectedPriority.value = (TaskPriority.low);
          if (label == 'Medium') controller.selectedPriority.value = (TaskPriority.medium);
          if (label == 'High') controller.selectedPriority.value = (TaskPriority.high);
        }
      },
    );
  }

  Widget _buildStep4Optional() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Anything else?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),

          TextField(
            controller: controller.descriptionController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Add a description...',
              border: OutlineInputBorder(),
            ),
          ),

          // Subtasks placeholder
          // const SizedBox(height: 24),
          // const Text('Subtasks (Coming Soon)', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Get.theme.shadowColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          TextButton(
            onPressed: controller.currentStep.value == 0
                ? null
                : controller
                      .previousStep, // Disable on step 0 or hide? Controller handles navigation.
            child: const Text('Back'),
          ),

          // Next/Save Button
          Obx(
            () => ElevatedButton(
              onPressed: controller.currentStep.value == 0 && !controller.isTitleValid.value
                  ? null
                  : controller.nextStep,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                controller.currentStep.value == controller.totalSteps - 1 ? 'Save Task' : 'Next',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
