import 'package:flutter/material.dart';
import 'package:fresher_demo_2/core/network/api_client.dart';
import 'package:get/get.dart';
import 'package:fresher_demo_2/routes/app_routes.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final TextEditingController taxController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final ApiClient _apiClient = ApiClient();

  Future<bool> login() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Dữ liệu truyền đi
      final Map<String, dynamic> loginData = {
        "username": usernameController.text.trim(),
        "password": passwordController.text.trim(),
      };

      final response = await _apiClient.dio.post('/login', data: loginData);

      return response.statusCode == 200;
    } catch (e) {
      errorMessage.value =
          "Thông tin đăng nhập không chính xác hoặc lỗi kết nối";
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onLoginPressed() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    final success = await login();

    if (success) {
      Get.offAllNamed(Routes.home);
    } else {
      _showErrorDialog();
    }
  }

  void _showErrorDialog() {
    Get.defaultDialog(
      title: "Thông báo",
      middleText: errorMessage.value.isNotEmpty
          ? errorMessage.value
          : "Đăng nhập thất bại, vui lòng thử lại",
      backgroundColor: Colors.white,
      radius: 10,
      textConfirm: "Đóng",
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFf24e1e),
      onConfirm: () => Get.back(),
    );
  }

  @override
  void onClose() {
    taxController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
