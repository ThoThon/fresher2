import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../../../category/category_list/repositories/category_repository.dart';
import '../../../category/entities/category.dart';
import '../../entities/product.dart';
import '../repositories/product_list_repository.dart';

class ProductListController extends GetxController {
  final ProductListRepository _productRepo;
  final CategoryRepository _categoryRepo;

  ProductListController(this._productRepo, this._categoryRepo);

  final products = <Product>[].obs;
  final categories = <Category>[].obs;
  final isLoading = false.obs;

  var currentPage = 1;
  final int pageSize = 10;
  static const int defaultPageNumber = 1;

  final refreshController = RefreshController(initialRefresh: false);

  final searchQuery = "".obs;
  final selectedCategoryId = Rxn<int>();
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchProducts();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    refreshController.dispose();
    super.onClose();
  }

  Future<void> fetchCategories() async {
    try {
      final result = await _categoryRepo.getCategories();
      categories.assignAll(result);
    } catch (e) {
      debugPrint("Lỗi fetchCategories: $e");
    }
  }

  Future<void> fetchProducts({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      isLoading.value = true;
    }

    try {
      final page = isLoadMore ? currentPage + 1 : defaultPageNumber;

      final result = await _productRepo.getProducts(
        page: page,
        limit: pageSize,
        keyword: searchQuery.value,
        categoryId: selectedCategoryId.value,
      );

      if (isLoadMore) {
        if (result.isEmpty) {
          refreshController.loadNoData(); 
        } else {
          products.addAll(result);
          refreshController.loadComplete();
        }
      } else {
        products.assignAll(result);
        refreshController.refreshCompleted();
        refreshController.resetNoData(); 
      }

      currentPage = page;
    } catch (e) {
      debugPrint("Lỗi fetchProducts: $e");
      if (isLoadMore) {
        refreshController.loadFailed();
      } else {
        refreshController.refreshFailed();
      }
    } finally {
      isLoading.value = false;
    }
  }

  void onRefresh() async => await fetchProducts(isLoadMore: false);

  void onLoadMore() async => await fetchProducts(isLoadMore: true);

  void filterByCategory(int? categoryId) {
    selectedCategoryId.value = categoryId;
    onRefresh();
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      searchQuery.value = query;
      onRefresh();
    });
  }

  void confirmDelete(int id) {
    Get.defaultDialog(
      title: "Xác nhận xóa",
      middleText: "Bạn có chắc chắn muốn xóa sản phẩm này không?",
      textConfirm: "Xóa",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        bool success = await _productRepo.deleteProduct(id);
        if (success) {
          products.removeWhere((p) => p.id == id);
          Get.snackbar("Thành công", "Đã xóa sản phẩm");
        }
      },
    );
  }
}