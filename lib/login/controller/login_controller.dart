import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../models/login_request.dart';
import '../repositories/login_repository.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final AuthRepository _authRepository = AuthRepository();

  Future<void> onLoginPressed() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final request = LoginRequest(
        username: usernameController.text.trim(),
        password: passwordController.text.trim(),
      );
      final success = await _authRepository.login(request);

      if (success) {
        Get.offAllNamed(Routes.home);
      } else {
        _showErrorDialog();
      }
    } catch (e) {
      _showErrorDialog();
    } finally {
      isLoading.value = false;
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
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
