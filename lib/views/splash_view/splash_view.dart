import 'package:bin_management_system/config/app_colors/app_colors.dart';
import 'package:bin_management_system/config/app_images.dart';
import 'package:bin_management_system/core/utils/app_text/app_text.dart';
import 'package:bin_management_system/views/splash_view/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashView extends StatelessWidget {
  SplashView({super.key});

  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginBg,
      body: Stack(
        alignment: Alignment.center,
        children: [
          /// ───────── BACKGROUND IMAGE ─────────
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

          /// ───────── MAIN CONTENT (FIXED & RESPONSIVE) ─────────
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(flex: 3),

                    /// ── Animated Logo ──
                    Obx(
                      () => AnimatedOpacity(
                        opacity: controller.opacity.value,
                        duration: const Duration(milliseconds: 900),
                        curve: Curves.easeOut,
                        child: AnimatedSlide(
                          offset: controller.isVisible.value
                              ? Offset.zero
                              : const Offset(0, 0.15),
                          duration: const Duration(milliseconds: 900),
                          curve: Curves.easeOut,
                          child: Column(
                            children: [
                              /// App Icon
                              Container(
                                width: 160,
                                height: 160,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28),
                                  color: AppColors.white.withValues(
                                    alpha: 0.08,
                                  ),
                                  border: Border.all(
                                    color: AppColors.white.withValues(
                                      alpha: 0.15,
                                    ),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.25,
                                      ),
                                      blurRadius: 30,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(18),
                                child: Image.asset(
                                  AppImages.appIcon,
                                  fit: BoxFit.contain,
                                ),
                              ),

                              const SizedBox(height: 28),

                              /// App Name
                              AppText(
                                title: 'Bin Management',
                                size: 30,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                                letterSpacing: -0.5,
                                height: 1.2,
                              ),

                              const SizedBox(height: 8),

                              /// Tagline
                              AppText(
                                title: 'System',
                                size: 15,
                                fontWeight: FontWeight.w500,
                                color: AppColors.white.withValues(alpha: 0.6),
                                letterSpacing: 0.3,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const Spacer(flex: 3),

                    /// ── Loading Indicator ──
                    Obx(
                      () => AnimatedOpacity(
                        opacity: controller.opacity.value,
                        duration: const Duration(milliseconds: 1200),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 52),
                          child: Column(
                            children: [
                              SizedBox(
                                width: 28,
                                height: 28,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.buttonColor.withValues(
                                      alpha: 0.85,
                                    ),
                                  ),
                                  backgroundColor: AppColors.white.withValues(
                                    alpha: 0.12,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              AppText(
                                title: 'Loading...',
                                size: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.white.withValues(alpha: 0.45),
                                letterSpacing: 0.5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
