import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'routes/app_pages.dart'; 
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Khởi tạo Hive để lưu trữ local
  await Hive.initFlutter();
  // Mở box 'settings' để Controller có thể lưu/đọc token
  await Hive.openBox('settings');

  runApp(
    GetMaterialApp(
      title: "Login Demo",
      initialRoute: Routes.login, // Để mặc định vào màn Login trước
      getPages: AppPages.routes, 
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
    ),
  );
}