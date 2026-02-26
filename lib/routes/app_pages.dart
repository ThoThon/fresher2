import 'package:get/get.dart';
import '../category/binding/category_binding.dart';
import '../category/ui/category_form_screen.dart';
import '../home/binding/home_binding.dart';
import '../home/ui/home_screen.dart';
import '../login/binding/login_binding.dart';
import '../login/ui/login_screen.dart';
import '../product/binding/product_binding.dart';
import '../product/ui/product_screen.dart';
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
      name: Routes.product,
      page: () => const ProductFormScreen(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: Routes.category,
      page: () => const CategoryFormScreen(),
      binding: CategoryBinding(),
    ),
  ];
}
