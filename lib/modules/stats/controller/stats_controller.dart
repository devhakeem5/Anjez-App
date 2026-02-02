import 'package:get/get.dart';

import '../../../../data/repositories/category_repository.dart';
import '../../../../data/repositories/task_repository.dart';

class StatsController extends GetxController {
  final TaskRepository _taskRepository = Get.find<TaskRepository>();
  final CategoryRepository _categoryRepository = Get.find<CategoryRepository>();

  final RxInt completedToday = 0.obs;
  final RxInt completedThisWeek = 0.obs;
  final RxInt overdueCount = 0.obs;

  final RxString topCategoryName = '-'.obs;
  final RxInt topCategoryCount = 0.obs;

  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    refreshStats();
  }

  Future<void> refreshStats() async {
    isLoading.value = true;
    try {
      final now = DateTime.now();

      // 1. Completed Today
      completedToday.value = await _taskRepository.countCompleted(now);

      // 2. Completed This Week (Monday to Sunday, or last 7 days)
      // Implementation: Last 7 days rolling window for "This Week" feel
      final oneWeekAgo = now.subtract(const Duration(days: 7));
      completedThisWeek.value = await _taskRepository.countCompletedRange(oneWeekAgo, now);

      // 3. Overdue
      overdueCount.value = await _taskRepository.countOverdue();

      // 4. Top Category
      final topCatMap = await _taskRepository.getTopCategory();
      if (topCatMap.isNotEmpty) {
        final catId = topCatMap.keys.first;
        final count = topCatMap.values.first;

        final category = await _categoryRepository.read(catId);
        topCategoryName.value = category?.name ?? 'Unknown';
        topCategoryCount.value = count;
      } else {
        topCategoryName.value = 'None';
        topCategoryCount.value = 0;
      }
    } catch (e) {
      print('Error loading stats: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
