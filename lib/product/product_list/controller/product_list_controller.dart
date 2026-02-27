import 'dart:async';
import 'package:get/get.dart';
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
  final searchQuery = "".obs;
  final selectedCategoryId = Rxn<int>();
  final currentPage = 1.obs;

  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchProducts();
  }

  Future<void> fetchCategories() async {
    try {
      final result = await _categoryRepo.getCategories();
      categories.assignAll(result);
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể tải danh sách danh mục");
    }
  }

  Future<void> fetchProducts({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage.value = 1;
    }
    isLoading.value = true;
    try {
      var result = await _productRepo.getProducts(
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

  void filterByCategory(int? categoryId) {
    selectedCategoryId.value = categoryId;
    fetchProducts(isRefresh: true);
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      searchQuery.value = query;
      fetchProducts(isRefresh: true);
    });
  }

  void confirmDelete(int id) {
    Get.defaultDialog(
      title: "Xác nhận xóa",
      middleText: "Bạn có chắc chắn muốn xóa sản phẩm này không?",
      textConfirm: "Xóa",
      textCancel: "Hủy",
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

  Future<void> refreshProducts() async => await fetchProducts(isRefresh: true);

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}
