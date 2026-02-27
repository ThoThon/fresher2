import 'package:flutter/material.dart';
import 'package:fresher_demo_2/product/entities/product.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../controller/product_list_controller.dart';

class ProductListScreen extends GetView<ProductListController> {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (value) => controller.onSearchChanged(value),
              decoration: InputDecoration(
                hintText: "Tìm sản phẩm...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: Obx(() => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: controller.categories.length + 1,
                  itemBuilder: (context, index) {
                    final isAll = index == 0;
                    final label = isAll
                        ? "Tất cả"
                        : controller.categories[index - 1].name;
                    final id =
                        isAll ? null : controller.categories[index - 1].id;
                    final isSelected =
                        controller.selectedCategoryId.value == id;

                    return GestureDetector(
                      onTap: () => controller.filterByCategory(id),
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFf24e1e)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  },
                )),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.products.isEmpty) {
                return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFf24e1e)));
              }

              return RefreshIndicator(
                onRefresh: () => controller.refreshProducts(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: controller.products.length,
                  itemBuilder: (context, index) {
                    final product = controller.products[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Image.network(
                          product.image,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.image),
                        ),
                        title: Text(product.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            "Giá: \$${product.price} - Kho: ${product.stock}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _goToForm(product: product),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  controller.confirmDelete(product.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _goToForm({Product? product}) async {
    final result = await Get.toNamed(Routes.productForm, arguments: product);
    if (result == true) {
      controller.refreshProducts();
    }
  }
}
