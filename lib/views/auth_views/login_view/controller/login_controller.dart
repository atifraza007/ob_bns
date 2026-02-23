import 'package:bin_management_system/core/controllers/auth_controller/auth_controller.dart';
import 'package:bin_management_system/core/utils/app_snackbar/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final AuthController authController = Get.put(AuthController());

  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final rememberMe = false.obs;
  final isLoading = false.obs;

  late AnimationController fadeController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  @override
  void onInit() {
    super.onInit();

    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    fadeAnimation = CurvedAnimation(
      parent: fadeController,
      curve: Curves.easeOut,
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: fadeController, curve: Curves.easeOut));

    fadeController.forward();
  }

  void toggleRememberMe({
    required BuildContext context,
  }) {
    FocusScope.of(context).unfocus();
    rememberMe.value = !rememberMe.value;
  }

  // Handle login logic
  Future<void> handleLogin(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    final email = emailController.text;
    final password = passwordController.text;

    try {
      // Call login API
      await authController.login(email, password, rememberMe.value);
    } catch (e) {
      // If login fails, show error snackbar
      CustomSnackbar.showCustomSnackBar(context, e.toString(), error: true);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    fadeController.dispose();
    super.onClose();
  }
}
