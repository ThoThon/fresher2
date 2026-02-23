import 'package:fresher_demo_2/home/ui/home_screen.dart';
import 'package:fresher_demo_2/login/binding/login_binding.dart';
import 'package:fresher_demo_2/login/ui/login_screen.dart';
import 'package:get/get.dart';

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
    ),
  ];
}
