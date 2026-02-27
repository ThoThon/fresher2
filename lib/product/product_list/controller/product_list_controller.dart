import 'dart:async';
import 'package:fresher_demo_2/product/entities/product.dart';
import 'package:get/get.dart';
import '../../../category/category_list/controller/category_controller.dart';
import '../../../category/entities/category.dart';
import '../repositories/product_list_repository.dart';

class ProductListController extends GetxController {
  final ProductListRepository _repository = ProductListRepository();

  CategoryController get categoryController => Get.find<CategoryController>();

  final products = <Product>[].obs;
  final isLoading = false.obs;
  final searchQuery = "".obs;
  final selectedCategoryId = Rxn<int>();
  final currentPage = 1.obs;

  List<Category> get categories => categoryController.categories;
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
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
    super.onClose();
  }
}
