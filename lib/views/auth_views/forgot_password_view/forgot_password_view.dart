import 'package:bin_management_system/config/app_colors/app_colors.dart';
import 'package:bin_management_system/config/app_images.dart';
import 'package:bin_management_system/core/utils/app_button/app_button.dart';
import 'package:bin_management_system/core/utils/app_field/app_field.dart';
import 'package:bin_management_system/core/utils/app_text/app_text.dart';
import 'package:bin_management_system/core/utils/lottie_loader/lottie_loader.dart';
import 'package:bin_management_system/views/auth_views/forgot_password_view/controller/forgot_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final ForgotPasswordController controller = Get.put(
    ForgotPasswordController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginBg,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // ── Background image ───────────────────────────────────────────────
          Positioned(
            right: Get.width * -0.3,
            top: Get.height * 0.01,
            height: Get.height * 1.7,
            width: Get.width * 1.9,
            child: Image.asset(
              AppImages.authBackground,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),

          // ── Main content ───────────────────────────────────────────────────
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: FadeTransition(
                  opacity: controller.fadeAnimation,
                  child: SlideTransition(
                    position: controller.slideAnimation,
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Logo
                          Center(
                            child: Image.asset(
                              AppImages.appIcon,
                              height: 90,
                              fit: BoxFit.contain,
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Heading
                          AppText(
                            title: 'Forgot Password?',
                            size: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                            letterSpacing: -0.5,
                            height: 1.2,
                          ),
                          const SizedBox(height: 8),
                          AppText(
                            title:
                                'Enter your registered email and we\'ll send you a reset token.',
                            size: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white,
                          ),

                          const SizedBox(height: 36),

                          // Email field
                          AppField(
                            label: 'Email address',
                            hint: 'you@example.com',
                            controller: controller.emailController,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: const Icon(
                              Icons.mail_outline_rounded,
                              size: 20,
                              color: AppColors.textHint,
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 32),

                          // Send button — disabled while loading
                          Obx(
                            () => AppButton(
                              label: 'Send Reset Token',
                              isLoading: false,
                              onPressed: controller.isLoading.value
                                  ? null
                                  : () => controller.handleSendRequest(context),
                            ),
                          ),

                          const SizedBox(height: 28),

                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppText(
                                  title: 'Remember your password? ',
                                  size: 13,
                                  color: AppColors.white,
                                ),
                                GestureDetector(
                                  onTap: () => Get.back(),
                                  child: AppText(
                                    title: 'Sign In',
                                    size: 14,
                                    color: AppColors.buttonColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Floating back button ───────────────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 24,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.white,
                  size: 18,
                ),
              ),
            ),
          ),

          // ── Lottie loading overlay ─────────────────────────────────────────
          Obx(
            () => LottieOverlay(
              visible: controller.isLoading.value,
              message: 'Sending reset token…',
            ),
          ),
        ],
      ),
    );
  }
}
