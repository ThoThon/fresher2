import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['initialTab'] != null) {
      currentIndex.value = Get.arguments['initialTab'];
    }
  }

  void changeTab(int index) => currentIndex.value = index;

  void onFabPressed() {
    if (currentIndex.value == 0) {
      Get.toNamed(Routes.product);
    } else {
      Get.toNamed(Routes.category);
    }
  }
}
