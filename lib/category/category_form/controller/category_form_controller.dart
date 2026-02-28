import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../entities/category.dart';
import '../../models/category_request.dart';
import '../repositories/category_form_repository.dart';

class CategoryFormController extends GetxController {
  final CategoryFormRepository _repo;
  final Category? initialCategory;
  CategoryFormController(this._repo, {this.initialCategory});

  final nameController = TextEditingController();
  Category? editingCategory;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (initialCategory != null) {
      editingCategory = initialCategory;
      nameController.text = editingCategory?.name ?? "";
    }
  }

  Future<void> submitForm() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar("Lỗi", "Vui lòng nhập tên");
      return;
    }

    isLoading.value = true;
    try {
      bool success;
      if (editingCategory != null) {
        final request = CategoryRequest(id: editingCategory!.id, name: name);
        success = await _repo.updateCategory(request);
      } else {
        success = await _repo.createCategory(CategoryRequest(name: name));
      }

      if (success) {
        Get.back(result: true);
        Get.snackbar("Thành công",
            editingCategory != null ? "Đã cập nhật" : "Đã thêm mới",
            backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Thao tác thất bại. Vui lòng thử lại");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}
