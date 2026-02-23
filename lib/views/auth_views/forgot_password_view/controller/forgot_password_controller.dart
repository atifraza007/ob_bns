import 'package:bin_management_system/views/auth_views/reset_password_view/reset_password_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  final RxBool isLoading = false.obs;

  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeIn),
    );

    slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        );

    animationController.forward();
  }

  void handleSendRequest(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));
      isLoading.value = false;

      Get.to(() => ResetPasswordScreen());
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
