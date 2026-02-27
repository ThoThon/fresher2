import 'package:get/get.dart';
import '../controller/category_controller.dart';
import '../repositories/category_repository.dart';

class CategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryRepository>(() => CategoryRepository());
    Get.lazyPut<CategoryController>(
        () => CategoryController(Get.find<CategoryRepository>()));
  }
}
