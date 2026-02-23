import 'package:bin_management_system/config/app_colors/app_colors.dart';
import 'package:bin_management_system/config/app_images.dart';
import 'package:bin_management_system/core/utils/app_button/app_button.dart';
import 'package:bin_management_system/core/utils/app_field/app_field.dart';
import 'package:bin_management_system/core/utils/app_text/app_text.dart';
import 'package:bin_management_system/core/utils/lottie_loader/lottie_loader.dart';
import 'package:bin_management_system/views/auth_views/reset_password_view/controller/reset_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final ResetPasswordController controller = Get.put(ResetPasswordController());

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
                            title: 'Reset Password',
                            size: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                            letterSpacing: -0.5,
                            height: 1.2,
                          ),
                          const SizedBox(height: 8),
                          AppText(
                            title:
                                'Enter the token sent to your email along with your new password.',
                            size: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white,
                          ),

                          const SizedBox(height: 36),

                          // Reset token
                          AppField(
                            label: 'Reset Token',
                            hint: 'Enter your token',
                            controller: controller.tokenController,
                            keyboardType: TextInputType.text,
                            prefixIcon: const Icon(
                              Icons.vpn_key_outlined,
                              size: 20,
                              color: AppColors.textHint,
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Please enter the reset token';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          // New password
                          AppField(
                            label: 'New Password',
                            hint: '••••••••',
                            controller: controller.passwordController,
                            obscureText: true,
                            hasToggle: true,
                            prefixIcon: const Icon(
                              Icons.lock_outline_rounded,
                              size: 20,
                              color: AppColors.textHint,
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Please enter a new password';
                              }
                              if (v.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          // Confirm password
                          AppField(
                            label: 'Confirm Password',
                            hint: '••••••••',
                            controller: controller.confirmPasswordController,
                            obscureText: true,
                            hasToggle: true,
                            prefixIcon: const Icon(
                              Icons.lock_outline_rounded,
                              size: 20,
                              color: AppColors.textHint,
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (v != controller.passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 32),

                          // Reset button — disabled while loading
                          Obx(
                            () => AppButton(
                              label: 'Reset Password',
                              isLoading: false,
                              onPressed: controller.isLoading.value
                                  ? null
                                  : () =>
                                        controller.handleResetPassword(context),
                            ),
                          ),

                          const SizedBox(height: 28),

                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppText(
                                  title: 'Back to ',
                                  size: 13,
                                  color: AppColors.white,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.back();
                                    Get.back();
                                  },
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
                  color: Colors.white.withOpacity(0.1),
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
              message: 'Resetting password…',
            ),
          ),
        ],
      ),
    );
  }
}
