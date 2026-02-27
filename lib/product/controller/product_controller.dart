import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../category/category_list/controller/category_controller.dart';
import '../../category/entities/category.dart';
import '../../routes/app_routes.dart';
import '../models/product_model.dart';
import '../repositories/product_repository.dart';

class ProductController extends GetxController {
  final ProductRepository _repository = ProductRepository();
  CategoryController get categoryController => Get.find<CategoryController>();

  final nameController = TextEditingController();
  final codeController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final descController = TextEditingController();
  final selectedFormCategoryId = RxnInt();
  final formKey = GlobalKey<FormState>();

  var products = <ProductModel>[].obs;
  var isLoading = false.obs;
  var searchQuery = "".obs;
  var selectedCategoryId = Rxn<int>();
  var currentPage = 1.obs;

  List<Category> get categories => categoryController.categories;
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void prepareForm(ProductModel? product) {
    nameController.text = product?.name ?? '';
    codeController.text = product?.code ?? '';
    priceController.text = product?.price.toString() ?? '';
    stockController.text = product?.stock.toString() ?? '';
    descController.text = product?.description ?? '';
    selectedFormCategoryId.value = product?.category?.id;
  }

  Map<String, dynamic> getFormData() {
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

  Future<void> fetchProducts({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage.value = 1;
    }
    isLoading.value = true;
    try {
      var result = await _repository.getProducts(
        page: currentPage.value,
        keyword: searchQuery.value,
        categoryId: selectedCategoryId.value,
      );
      if (isRefresh) {
        products.assignAll(result);
      } else {
        products.addAll(result);
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể tải danh sách sản phẩm");
    } finally {
      isLoading.value = false;
    }
  }

  // Xử lý lọc theo danh mục
  void filterByCategory(int? categoryId) {
    selectedCategoryId.value = categoryId;
    fetchProducts(isRefresh: true);
  }

  // Xử lý Search với Debounce 300ms
  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      searchQuery.value = query;
      fetchProducts(isRefresh: true);
    });
  }

  Future<bool> addProduct() async {
    if (!formKey.currentState!.validate()) return false;
    isLoading.value = true;
    try {
      bool success = await _repository.createProduct(getFormData());
      if (success) {
        await refreshProducts();
        Get.snackbar(
          "Thành công",
          "Đã thêm sản phẩm mới",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed(Routes.home);
        return true;
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateProduct(int id) async {
    if (!formKey.currentState!.validate()) return false;
    isLoading.value = true;
    try {
      bool success = await _repository.updateProduct(id, getFormData());
      if (success) {
        await refreshProducts();
        Get.snackbar(
          "Thành công",
          "Đã cập nhật sản phẩm",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed(Routes.home);
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
      middleText: "Bạn có chắc chắn muốn xóa sản phẩm này không?",
      textConfirm: "Xóa",
      textCancel: "Hủy",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        bool success = await _repository.deleteProduct(id);
        if (success) {
          products.removeWhere((p) => p.id == id);
          Get.snackbar("Thành công", "Đã xóa sản phẩm");
        }
      },
    );
  }

  Future<void> refreshProducts() async => await fetchProducts(isRefresh: true);

  @override
  void onClose() {
    _debounce?.cancel();
    nameController.dispose();
    codeController.dispose();
    priceController.dispose();
    stockController.dispose();
    descController.dispose();
    super.onClose();
  }
}
