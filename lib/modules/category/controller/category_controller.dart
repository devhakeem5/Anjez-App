import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../data/models/category_model.dart';
import '../../../data/repositories/category_repository.dart';

class CategoryController extends GetxController {
  final CategoryRepository _categoryRepository = Get.find<CategoryRepository>();

  final RxList<Category> categories = <Category>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    isLoading.value = true;
    try {
      final result = await _categoryRepository.readAll();
      categories.assignAll(result);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load categories');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addCategory(String name, int colorValue) async {
    if (name.trim().isEmpty) {
      Get.snackbar('Error', 'Category name cannot be empty');
      return false;
    }

    if (categories.any((c) => c.name.toLowerCase() == name.trim().toLowerCase())) {
      Get.snackbar('Error', 'Category already exists');
      return false;
    }

    try {
      final newCategory = Category(
        id: const Uuid().v4(),
        name: name.trim(),
        color: colorValue,
        createdAt: DateTime.now(),
      );

      await _categoryRepository.create(newCategory);
      categories.add(newCategory); // Optimistic update
      categories.refresh(); // Ensure UI updates
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to add category');
      return false;
    }
  }

  Future<bool> editCategory(String id, String name, int colorValue) async {
    final index = categories.indexWhere((c) => c.id == id);
    if (index == -1) return false;

    // Check duplicate name ONLY if name changed
    if (categories[index].name.toLowerCase() != name.trim().toLowerCase()) {
      if (categories.any((c) => c.id != id && c.name.toLowerCase() == name.trim().toLowerCase())) {
        Get.snackbar('Error', 'Category name already exists');
        return false;
      }
    }

    try {
      final updatedCategory = categories[index].copyWith(name: name.trim(), color: colorValue);

      await _categoryRepository.update(updatedCategory);
      categories[index] = updatedCategory;
      categories.refresh();
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update category');
      return false;
    }
  }

  Future<void> toggleCategoryStatus(Category category) async {
    try {
      final updatedCategory = category.copyWith(isActive: !category.isActive);
      await _categoryRepository.update(updatedCategory);

      final index = categories.indexWhere((c) => c.id == category.id);
      if (index != -1) {
        categories[index] = updatedCategory;
        categories.refresh();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update status');
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      await _categoryRepository.delete(id);
      categories.removeWhere((c) => c.id == id);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete category');
    }
  }
}
