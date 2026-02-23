import 'package:bin_management_system/config/app_colors/app_colors.dart';
import 'package:bin_management_system/config/app_images.dart';
import 'package:bin_management_system/core/utils/app_button/app_button.dart';
import 'package:bin_management_system/core/utils/app_field/app_field.dart';
import 'package:bin_management_system/core/utils/app_text/app_text.dart';
import 'package:bin_management_system/core/utils/lottie_loader/lottie_loader.dart';
import 'package:bin_management_system/views/auth_views/forgot_password_view/forgot_password_view.dart';
import 'package:bin_management_system/views/auth_views/login_view/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginBg,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // ── Background image ─────────────────────────────────────────────────
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

          // ── Main content ─────────────────────────────────────────────────────
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
                            title: 'Welcome back',
                            size: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                            letterSpacing: -0.5,
                            height: 1.2,
                          ),
                          const SizedBox(height: 8),
                          AppText(
                            title: 'Sign in to continue to your account',
                            size: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white,
                          ),

                          const SizedBox(height: 36),

                          // Email
                          AppField(
                            label: 'Email address',
                            hint: 'you@example.com',
                            controller: controller.emailController,
                            keyboardType: TextInputType.emailAddress,
                            maxLines: 1,
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

                          const SizedBox(height: 20),

                          // Password
                          AppField(
                            label: 'Password',
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
                                return 'Please enter your password';
                              }
                              if (v.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          // Remember me + Forgot password
                          Obx(
                            () => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    controller.toggleRememberMe(
                                      context: context,
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 180,
                                        ),
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          color: controller.rememberMe.value
                                              ? AppColors.buttonColor
                                              : Colors.transparent,
                                          border: Border.all(
                                            color: controller.rememberMe.value
                                                ? AppColors.buttonColor
                                                : AppColors.border,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: controller.rememberMe.value
                                            ? const Icon(
                                                Icons.check_rounded,
                                                size: 14,
                                                color: AppColors.surface,
                                              )
                                            : null,
                                      ),
                                      const SizedBox(width: 10),
                                      AppText(
                                        title: 'Remember me',
                                        color: AppColors.white,
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    Get.to(() => ForgotPasswordScreen());
                                  },
                                  child: AppText(
                                    title: 'Forgot password?',
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          Obx(
                            () => AppButton(
                              label: 'Sign In',
                              isLoading:
                                  false, // spinner removed — lottie handles it
                              onPressed: controller.isLoading.value
                                  ? null
                                  : () {
                                      FocusScope.of(context).unfocus();
                                      controller.handleLogin(context);
                                    },
                            ),
                          ),

                          const SizedBox(height: 28),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          Obx(
            () => LottieOverlay(
              visible: controller.isLoading.value,
              message: 'Signing in…',
            ),
          ),
        ],
      ),
    );
  }
}
