import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/category_model.dart';
import '../controller/category_controller.dart';

class AddEditCategoryView extends GetView<CategoryController> {
  final Category? category; // If null, we are adding new

  AddEditCategoryView({super.key, this.category});

  final TextEditingController nameController = TextEditingController();
  final RxInt selectedColor = Colors.blue.value.obs;

  // Predefined colors
  final List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.deepPurple,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
    Colors.brown,
  ];

  @override
  Widget build(BuildContext context) {
    // Initialize if editing
    if (category != null) {
      nameController.text = category!.name;
      selectedColor.value = category!.color;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          category == null ? 'New Category' : 'Edit Category',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name Field
            const Text(
              'Category Name',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'e.g., Work, Personal',
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Color Picker
            const Text(
              'Category Color',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Obx(
              () => Wrap(
                spacing: 12,
                runSpacing: 12,
                children: colors.map((color) {
                  final isSelected = selectedColor.value == color.value;
                  return GestureDetector(
                    onTap: () {
                      selectedColor.value = color.value;
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected ? Border.all(color: Colors.black, width: 3) : null,
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: isSelected ? const Icon(Icons.check, color: Colors.white) : null,
                    ),
                  );
                }).toList(),
              ),
            ),

            const Spacer(),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () async {
                  if (category == null) {
                    final success = await controller.addCategory(
                      nameController.text,
                      selectedColor.value,
                    );
                    if (success) Get.back();
                  } else {
                    final success = await controller.editCategory(
                      category!.id,
                      nameController.text,
                      selectedColor.value,
                    );
                    if (success) Get.back();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                ),
                child: Text(
                  category == null ? 'Create Category' : 'Save Changes',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
