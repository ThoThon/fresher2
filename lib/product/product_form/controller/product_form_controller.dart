import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../category/entities/category.dart';
import '../../models/product_model.dart';
import '../repositories/product_form_repository.dart';

class ProductFormController extends GetxController {
  final ProductFormRepository _repository;
  final ProductModel? initialProduct;
  final List<Category> categories;

  ProductFormController(this._repository,
      {this.initialProduct, required this.categories});

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final codeController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final descController = TextEditingController();
  final selectedFormCategoryId = RxnInt();

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (initialProduct != null) {
      _prepareForm(initialProduct!);
    }
  }

  void _prepareForm(ProductModel product) {
    nameController.text = product.name;
    codeController.text = product.code;
    priceController.text = product.price.toString();
    stockController.text = product.stock.toString();
    descController.text = product.description;
    selectedFormCategoryId.value = product.category?.id;
  }

  Map<String, dynamic> _getFormData() {
    return {
      "name": nameController.text.trim(),
      "code": codeController.text.trim(),
      "price": double.tryParse(priceController.text) ?? 0.0,
      "stock": int.tryParse(stockController.text) ?? 0,
      "description": descController.text.trim(),
      "category_id": selectedFormCategoryId.value,
      "image": "https://example.com/new-image.png",
    };
  }

  Future<void> submitForm() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      bool success;
      if (initialProduct != null) {
        success =
            await _repository.updateProduct(initialProduct!.id, _getFormData());
      } else {
        success = await _repository.createProduct(_getFormData());
      }

      if (success) {
        Get.back(result: true);
        Get.snackbar(
          "Thành công",
          initialProduct != null
              ? "Đã cập nhật sản phẩm"
              : "Đã thêm sản phẩm mới",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Thao tác thất bại");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    codeController.dispose();
    priceController.dispose();
    stockController.dispose();
    descController.dispose();
    super.onClose();
  }
}
