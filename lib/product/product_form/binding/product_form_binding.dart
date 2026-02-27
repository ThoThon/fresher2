import 'package:fresher_demo_2/category/category_list/repositories/category_repository.dart';
import 'package:get/get.dart';
import '../../models/product_model.dart';
import '../controller/product_form_controller.dart';
import '../repositories/product_form_repository.dart';

class ProductFormBinding extends Bindings {
  @override
  void dependencies() {
    final repository = ProductFormRepository();
    final ProductModel? product = Get.arguments;

    Get.lazyPut<ProductFormController>(
      () => ProductFormController(
        repository,
        initialProduct: product,
        Get.put(CategoryRepository()),
      ),
    );
  }
}
