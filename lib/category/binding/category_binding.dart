import 'package:get/get.dart';
import '../controller/category_controller.dart';
import '../controller/category_form_controller.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

class CategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryRepository>(() => CategoryRepository());
    Get.lazyPut<CategoryController>(
        () => CategoryController(Get.find<CategoryRepository>()));

    Get.lazyPut<CategoryFormController>(
      () => CategoryFormController(
        Get.find<CategoryRepository>(),
        initialCategory: Get.arguments as Category?,
      ),
    );
  }
}
