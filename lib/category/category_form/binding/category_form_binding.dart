import 'package:get/get.dart';
import '../controller/category_form_controller.dart';
import '../repositories/category_form_repository.dart';
import '../../entities/category.dart';

class CategoryFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryFormRepository>(() => CategoryFormRepository());
    Get.lazyPut<CategoryFormController>(
      () => CategoryFormController(
        Get.find<CategoryFormRepository>(),
        initialCategory: Get.arguments as Category?,
      ),
    );
  }
}