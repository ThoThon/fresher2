import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class HomeController extends GetxController {
  final currentIndex = 0.obs;

  void changeTab(int index) => currentIndex.value = index;

  void onFabPressed() {
    if (currentIndex.value == 0) {
      Get.toNamed(Routes.product);
    } else {
      Get.toNamed(Routes.categoryForm);
    }
  }
}
