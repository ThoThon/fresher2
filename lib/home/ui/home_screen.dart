import 'package:flutter/material.dart';
import 'package:fresher_demo_2/category/controller/category_controller.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:fresher_demo_2/routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryController controller = Get.put(CategoryController());
    final box = Hive.box('settings');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh mục sản phẩm"), // Đổi tiêu đề cho đúng nội dung
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              box.delete('token');
              Get.offAllNamed(Routes.login);
            },
          )
        ],
      ),
      body: Obx(() {
        // 1. Trạng thái đang tải dữ liệu
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2. Trạng thái danh sách trống
        if (controller.categories.isEmpty) {
          return const Center(child: Text("Không có danh mục nào"));
        }

        // 3. Hiển thị danh sách dạng Card
        return RefreshIndicator(
          onRefresh: () async => controller.fetchCategories(),
          child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              final category = controller.categories[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFFf24e1e), // Màu cam giống Postman của ông
                    child: Text(
                      "${category.id}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    category.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Trạng thái: ${category.status == 1 ? 'Hoạt động' : 'Bị khóa'}",
                    style: TextStyle(
                      color: category.status == 1 ? Colors.green : Colors.red,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Xử lý khi nhấn vào từng danh mục (ví dụ xem sản phẩm thuộc danh mục này)
                  },
                ),
              );
            },
          ),
        );
      }),
      // Nút thêm sản phẩm như trong yêu cầu
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Logic thêm danh mục mới
        },
        backgroundColor: const Color(0xFFf24e1e),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}