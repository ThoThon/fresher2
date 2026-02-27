import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../entities/category.dart';
import '../repositories/category_repository.dart';

class CategoryController extends GetxController {
  final CategoryRepository _repo;
  CategoryController(this._repo);

  var categories = <Category>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  void fetchCategories() async {
    isLoading.value = true;
    try {
      var result = await _repo.getCategories();
      categories.assignAll(result);
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể tải danh mục");
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
        try {
          bool success = await _repo.deleteCategory(id);
          if (success) {
            categories.removeWhere((c) => c.id == id);
            Get.snackbar("Thành công", "Đã xóa danh mục");
          }
        } catch (e) {
          Get.snackbar("Lỗi", "Không thể xóa danh mục");
        }
      },
    );
  }
}