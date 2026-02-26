import 'package:flutter/material.dart';
import 'package:fresher_demo_2/category/entities/category.dart';
import 'package:fresher_demo_2/category/repositories/category_repository.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  final CategoryRepository _repo;
  CategoryController(this._repo);

  final nameController = TextEditingController();

  Category? editingCategory;

  var categories = <Category>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();

    if (Get.arguments != null && Get.arguments is Category) {
      editingCategory = Get.arguments;
      nameController.text = editingCategory?.name ?? "";
    }
  }

  void fetchCategories() async {
    isLoading.value = true;
    try {
      var result = await _repo.getCategories();
      categories.assignAll(result);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addCategory(String name) async {
    isLoading.value = true;
    try {
      bool success = await _repo.createCategory(name);
      if (success) {
        fetchCategories();
        Get.snackbar(
          "Thành công",
          "Đã thêm danh mục mới",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateCategory(int id, String name) async {
    isLoading.value = true;
    try {
      bool success = await _repo.updateCategory(id, name);
      if (success) {
        fetchCategories();
        Get.snackbar(
          "Thành công",
          "Đã cập nhật danh mục",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void confirmDelete(int id) {
    Get.defaultDialog(
      title: "Xác nhận xóa",
      middleText: "Bạn có chắc chắn muốn xóa danh mục này?",
      textConfirm: "Xóa",
      textCancel: "Hủy",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        bool success = await _repo.deleteCategory(id);
        if (success) {
          categories.removeWhere((c) => c.id == id);
          Get.snackbar("Thành công", "Đã xóa danh mục");
        }
      },
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}
