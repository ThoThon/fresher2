import 'package:get/get.dart';
import '../../category/controller/category_controller.dart';
import '../../category/repositories/category_repository.dart';
import '../../product/controller/product_controller.dart';
import '../controller/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CategoryController>(
        () => CategoryController(Get.find<CategoryRepository>()));
    Get.lazyPut<ProductController>(() => ProductController());
  }
}
