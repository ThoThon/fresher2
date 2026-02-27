import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../routes/app_routes.dart';
import '../controller/home_controller.dart';
import '../../product/ui/product_list_screen.dart';
import '../../category/category_list/ui/category_screen.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screens = [
      const ProductListScreen(),
      const CategoryScreen(),
    ];

    return Obx(() => Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: Text(
              controller.currentIndex.value == 0
                  ? "Quản lý Sản phẩm"
                  : "Quản lý Danh mục",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0.5,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.red),
                onPressed: () {
                  Hive.box('settings').delete('token');
                  Get.offAllNamed(Routes.login);
                },
              )
            ],
          ),
          body: IndexedStack(
            index: controller.currentIndex.value,
            children: screens,
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xFFf24e1e),
            onPressed: () => controller.onFabPressed(),
            child: const Icon(Icons.add, color: Colors.white),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: (index) => controller.changeTab(index),
            selectedItemColor: const Color(0xFFf24e1e),
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.inventory), label: "Sản phẩm"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.category), label: "Danh mục"),
            ],
          ),
        ));
  }
}
