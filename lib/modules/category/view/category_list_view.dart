import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/category_controller.dart';
import 'add_edit_category_view.dart';

class CategoryListView extends GetView<CategoryController> {
  const CategoryListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Manage Categories',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.deepPurple),
            onPressed: () {
              Get.to(() => AddEditCategoryView());
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.categories.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.category_outlined, size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                Text(
                  'No categories yet',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                ),
                TextButton(
                  onPressed: () => Get.to(() => AddEditCategoryView()),
                  child: const Text('Add your first category'),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.categories.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                onTap: () {
                  Get.to(() => AddEditCategoryView(category: category));
                },
                leading: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Color(category.color).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Color(category.color),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  category.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: category.isActive ? Colors.black87 : Colors.grey,
                    decoration: !category.isActive ? TextDecoration.lineThrough : null,
                  ),
                ),
                trailing: Switch(
                  value: category.isActive,
                  activeThumbColor: Colors.deepPurple,
                  onChanged: (value) {
                    controller.toggleCategoryStatus(category);
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
