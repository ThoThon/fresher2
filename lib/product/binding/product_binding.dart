import 'package:get/get.dart';
import '../../category/category_list/controller/category_controller.dart';
import '../../category/category_list/repositories/category_repository.dart';
import '../controller/product_controller.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryRepository>(() => CategoryRepository());
    Get.lazyPut<ProductController>(() => ProductController());
    Get.lazyPut<CategoryController>(
        () => CategoryController(Get.find<CategoryRepository>()));
  }
}
