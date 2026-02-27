import 'package:get/get.dart';
import '../../category/category_form/binding/category_form_binding.dart';
import '../../category/category_list/binding/category_list_binding.dart';
import '../../product/binding/product_binding.dart';
import '../controller/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    CategoryFormBinding().dependencies();
    CategoryBinding().dependencies();
    ProductBinding().dependencies();
  }
}
