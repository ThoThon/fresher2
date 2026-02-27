import 'package:get/get.dart';
import '../../../category/category_list/repositories/category_repository.dart';
import '../controller/product_list_controller.dart';
import '../repositories/product_list_repository.dart';

class ProductListBinding extends Bindings {
  @override
  void dependencies() {
    final productRepository = ProductListRepository();
    final categoryRepository = CategoryRepository();

    Get.lazyPut<ProductListController>(
      () => ProductListController(
        productRepository, 
        categoryRepository
      ),
    );
  }
}
