import 'package:get/get.dart';
import '../../../category/category_list/controller/category_controller.dart';
import '../../../category/entities/category.dart';
import '../../models/product_model.dart';
import '../controller/product_form_controller.dart';
import '../repositories/product_form_repository.dart';

class ProductFormBinding extends Bindings {
  @override
  void dependencies() {
    final repository = ProductFormRepository();
    final ProductModel? product =
        Get.arguments is ProductModel ? Get.arguments : null;
    final List<Category> currentCategories =
        Get.isRegistered<CategoryController>()
            ? Get.find<CategoryController>().categories
            : [];

    Get.lazyPut<ProductFormController>(
      () => ProductFormController(
        repository,
        initialProduct: product,
        categories: currentCategories, 
      ),
    );
  }
}
