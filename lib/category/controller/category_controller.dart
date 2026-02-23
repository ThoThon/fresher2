import 'package:fresher_demo_2/category/models/category_model.dart';
import 'package:fresher_demo_2/category/repositories/category_repository.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  final CategoryRepository _repo = CategoryRepository();
  
  var categories = <CategoryModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
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
}