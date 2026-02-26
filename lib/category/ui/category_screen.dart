import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/category_controller.dart';
import 'category_form_screen.dart';

class CategoryScreen extends GetView<CategoryController> {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Obx(() {
        if (controller.isLoading.value && controller.categories.isEmpty) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFFf24e1e)));
        }
        if (controller.categories.isEmpty) {
          return const Center(child: Text("Chưa có danh mục nào"));
        }

        return RefreshIndicator(
          onRefresh: () async => controller.fetchCategories(),
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              final cat = controller.categories[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: const CircleAvatar(
                      backgroundColor: Color(0xFFf24e1e), radius: 6),
                  title: Text(cat.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => Get.to(
                          () => const CategoryFormScreen(),
                          arguments: cat,
                        ),
                      ),
                      IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => controller.confirmDelete(cat.id)),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
