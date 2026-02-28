import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../repositories/login_repository.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final TextEditingController taxController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final AuthRepository _authRepository = AuthRepository();

  Future<bool> login() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _authRepository.login(
        usernameController.text.trim(),
        passwordController.text.trim(),
      );

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
    if (!(formKey.currentState?.validate() ?? false)) return;

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
