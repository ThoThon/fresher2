import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../../../routes/app_routes.dart';
import '../../entities/product.dart';
import '../controller/product_list_controller.dart';

class ProductListScreen extends GetView<ProductListController> {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategoryFilter(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.products.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFf24e1e)),
                );
              }

              if (controller.products.isEmpty) {
                return _buildEmptyState();
              }

              return SmartRefresher(
                controller: controller.refreshController,
                enablePullDown: true,
                enablePullUp: true,
                onRefresh: controller.onRefresh,
                onLoading: controller.onLoadMore,
                header:
                    const WaterDropHeader(waterDropColor: Color(0xFFf24e1e)),
                footer: _buildFooter(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: controller.products.length,
                  itemBuilder: (context, index) {
                    final product = controller.products[index];
                    return _buildProductCard(product);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: TextField(
        onChanged: controller.onSearchChanged,
        decoration: InputDecoration(
          hintText: "Tìm sản phẩm...",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 60,
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: controller.categories.length + 1,
          itemBuilder: (context, index) {
            return Obx(() {
              final isAll = index == 0;
              final label =
                  isAll ? "Tất cả" : controller.categories[index - 1].name;
              final id = isAll ? null : controller.categories[index - 1].id;
              final isSelected = controller.selectedCategoryId.value == id;

              return GestureDetector(
                onTap: () => controller.filterByCategory(id),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFf24e1e) : Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected ? Colors.transparent : Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            });
          },
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            product.image,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 60,
              height: 60,
              color: Colors.grey[200],
              child: const Icon(Icons.image, color: Colors.grey),
            ),
          ),
        ),
        title: Text(
          product.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text("Giá: \$${product.price}",
                style: const TextStyle(
                    color: Color(0xFFf24e1e), fontWeight: FontWeight.w600)),
            Text("Kho: ${product.stock}",
                style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.blue),
              onPressed: () => _goToForm(product: product),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => controller.confirmDelete(product.id),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return CustomFooter(
      builder: (context, mode) {
        if (mode == LoadStatus.noMore) {
          return const Center(
              child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text("Không còn sản phẩm nào nữa",
                style: TextStyle(color: Colors.grey)),
          ));
        }
        return const SizedBox(
          height: 55,
          child: Center(
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Color(0xFFf24e1e))),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text("Không tìm thấy sản phẩm",
              style: TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }

  void _goToForm({Product? product}) async {
    final result = await Get.toNamed(Routes.productForm, arguments: product);
    if (result == true) {
      controller.onRefresh();
    }
  }
}
