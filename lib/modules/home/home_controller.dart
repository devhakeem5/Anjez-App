import 'package:get/get.dart';

import '../../core/constants/enums.dart';
import '../../core/services/storage_service.dart';
import '../../data/models/category_model.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/repositories/task_repository.dart';

class HomeController extends GetxController {
  final TaskRepository _taskRepository = Get.find<TaskRepository>();
  final StorageService _storageService = Get.find<StorageService>();

  final RxString userName = ''.obs;
  final RxBool isLoading = true.obs;

  // Task Lists
  final RxList<Task> todayTasks = <Task>[].obs;
  final RxList<Task> ongoingTasks = <Task>[].obs;
  final RxList<Task> upcomingTasks = <Task>[].obs;

  // Filter State
  final RxString searchText = ''.obs;
  final RxBool isSearching = false.obs;
  final Rx<TaskStatus?> filterStatus = Rx<TaskStatus?>(null);
  final Rx<TaskPriority?> filterPriority = Rx<TaskPriority?>(null);
  final RxList<String> filterCategoryIds = <String>[].obs;
  final RxList<Category> availableCategories = <Category>[].obs;

  // Original Data (Cache for filtering)
  final List<Task> _originalTodayTasks = [];
  final List<Task> _originalOngoingTasks = [];
  final List<Task> _originalUpcomingTasks = [];

  // Repositories
  final CategoryRepository _categoryRepository = Get.find<CategoryRepository>();

  @override
  void onInit() {
    super.onInit();
    _loadUserName();
    loadCategories();
    loadTasks();
  }

  void _loadUserName() {
    userName.value = _storageService.read<String>(StorageKeys.userName) ?? 'Friend';
  }

  Future<void> loadCategories() async {
    try {
      final categories = await _categoryRepository.readAll();
      availableCategories.assignAll(categories);
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  Future<void> loadTasks() async {
    isLoading.value = true;
    try {
      final now = DateTime.now();

      // 1. Today's Date-Based Tasks
      final todayResult = await _taskRepository.getTasksByDate(now);
      _originalTodayTasks.assignAll(todayResult);

      // 2. Ongoing Tasks (Time-Based)
      final ongoingResult = await _taskRepository.getOngoingTasks(now);
      _originalOngoingTasks.assignAll(ongoingResult);

      // 3. Upcoming Tasks (Next 2 days)
      final tomorrow = now.add(const Duration(days: 1));
      final afterTomorrow = now.add(const Duration(days: 3));
      final upcomingResult = await _taskRepository.getUpcomingTasks(tomorrow, afterTomorrow);
      _originalUpcomingTasks.assignAll(upcomingResult);

      // Apply cached filters
      filterTasks();
    } catch (e) {
      print('Error loading tasks: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void filterTasks() {
    todayTasks.assignAll(_applyFilters(_originalTodayTasks));
    ongoingTasks.assignAll(_applyFilters(_originalOngoingTasks));
    upcomingTasks.assignAll(_applyFilters(_originalUpcomingTasks));
  }

  List<Task> _applyFilters(List<Task> tasks) {
    return tasks.where((task) {
      // 1. Search Text
      if (searchText.value.isNotEmpty) {
        final query = searchText.value.toLowerCase();
        final matchesTitle = task.title.toLowerCase().contains(query);
        final matchesDesc = task.description?.toLowerCase().contains(query) ?? false;
        if (!matchesTitle && !matchesDesc) return false;
      }

      // 2. Status
      if (filterStatus.value != null && task.status != filterStatus.value) {
        return false;
      }

      // 3. Priority
      if (filterPriority.value != null && task.priority != filterPriority.value) {
        return false;
      }

      // 4. Categories
      if (filterCategoryIds.isNotEmpty) {
        // If task has no category but we are filtering by category, exclude it?
        // Or strictly match. Assuming cached categories.
        if (task.categoryId == null || !filterCategoryIds.contains(task.categoryId)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  void setSearchText(String text) {
    searchText.value = text;
    filterTasks();
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      searchText.value = '';
      filterTasks();
    }
  }

  bool get hasActiveFilters =>
      filterStatus.value != null || filterPriority.value != null || filterCategoryIds.isNotEmpty;

  void setFilterStatus(TaskStatus? status) {
    filterStatus.value = status;
    filterTasks();
  }

  void setFilterPriority(TaskPriority? priority) {
    filterPriority.value = priority;
    filterTasks();
  }

  void toggleFilterCategory(String categoryId) {
    if (filterCategoryIds.contains(categoryId)) {
      filterCategoryIds.remove(categoryId);
    } else {
      filterCategoryIds.add(categoryId);
    }
    filterTasks();
  }

  void clearFilters() {
    searchText.value = '';
    filterStatus.value = null;
    filterPriority.value = null;
    filterCategoryIds.clear();
    filterTasks();
  }
}
