import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import '../controller/category_controller.dart';
import '../models/category_model.dart';

class CategoryFormScreen extends GetView<CategoryController> {
  final CategoryModel? category;
  const CategoryFormScreen({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    final isEdit = category != null;

    controller.setFields(category?.name);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Sửa danh mục" : "Thêm danh mục"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
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
                      : () async {
                          final name = controller.nameController.text.trim();
                          if (name.isEmpty) {
                            Get.snackbar("Lỗi", "Vui lòng nhập tên");
                            return;
                          }

                          bool success = isEdit
                              ? await controller.updateCategory(
                                  category!.id, name)
                              : await controller.addCategory(name);

                          if (success) {
                            Get.offAllNamed(
                              Routes.home,
                              arguments: {'initialTab': 1},
                            );
                          }
                        },
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(isEdit ? "CẬP NHẬT" : "LƯU DANH MỤC",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                )),
          ],
        ),
      ),
    );
  }
}
