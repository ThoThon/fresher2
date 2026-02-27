import 'package:get/get.dart';
import '../../category/controller/category_controller.dart';
import '../../category/repositories/category_repository.dart';
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
