import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/category_form_controller.dart';

class CategoryFormScreen extends GetView<CategoryFormController> {
   const CategoryFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isEdit = controller.editingCategory != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Sửa danh mục" : "Thêm danh mục"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller.nameController,
              decoration: InputDecoration(
                labelText: "Tên danh mục",
                hintText: "Nhập tên danh mục...",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Obx(() => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFf24e1e),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.submitForm(),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          isEdit ? "CẬP NHẬT" : "LƯU DANH MỤC",
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                )),
          ],
        ),
      ),
    );
  }
}
