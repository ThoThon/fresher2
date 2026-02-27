import 'package:get/get.dart';
import '../category/category_form/binding/category_form_binding.dart';
import '../category/category_form/ui/category_form_screen.dart';
import '../category/category_list/binding/category_list_binding.dart';
import '../category/category_list/ui/category_screen.dart';
import '../home/binding/home_binding.dart';
import '../home/ui/home_screen.dart';
import '../login/binding/login_binding.dart';
import '../login/ui/login_screen.dart';
import '../product/product_form/binding/product_form_binding.dart';
import '../product/product_form/ui/product_screen.dart';
import '../product/product_list/binding/product_list_binding.dart';
import '../product/product_list/ui/product_list_screen.dart';
import 'app_routes.dart';

class AppPages {
  static List<GetPage> routes = [
    GetPage(
      name: Routes.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.productList,
      page: () => const ProductListScreen(),
      binding: ProductListBinding(),
    ),
    GetPage(
      name: Routes.productForm,
      page: () => const ProductFormScreen(),
      binding: ProductFormBinding(),
    ),
    GetPage(
      name: Routes.category,
      page: () => const CategoryScreen(),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: Routes.categoryForm,
      page: () => const CategoryFormScreen(),
      binding: CategoryFormBinding(),
    ),
  ];
}
