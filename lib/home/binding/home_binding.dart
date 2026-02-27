import 'package:get/get.dart';
import '../../category/category_form/repositories/category_form_repository.dart';
import '../../category/category_list/controller/category_controller.dart';
import '../../category/category_form/controller/category_form_controller.dart';
import '../../category/category_list/repositories/category_repository.dart';
import '../../product/controller/product_controller.dart';
import '../controller/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryRepository>(() => CategoryRepository());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CategoryController>(
        () => CategoryController(Get.find<CategoryRepository>()));
    Get.lazyPut<CategoryFormController>(
        () => CategoryFormController(Get.find<CategoryFormRepository>()));
    Get.lazyPut<ProductController>(() => ProductController());
  }
}
