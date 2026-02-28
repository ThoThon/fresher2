import 'package:get/get.dart';
import '../../category/category_list/binding/category_list_binding.dart';
import '../../product/product_list/binding/product_list_binding.dart';
import '../controller/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    CategoryBinding().dependencies();
    ProductListBinding().dependencies();
  }
}
