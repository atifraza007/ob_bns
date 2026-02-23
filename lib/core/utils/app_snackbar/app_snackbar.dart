import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:bin_management_system/config/app_colors/app_colors.dart';

class CustomSnackbar {
  static void showCustomSnackBar(
    BuildContext context,
    String message, {
    bool success = false,
    bool error = false,
  }) {
    final bool isDefault = !success && !error;

    final Color baseColor = success
        ? const Color.fromARGB(230, 56, 142, 60)
        : error
        ? const Color.fromARGB(230, 211, 47, 47)
        : Colors.transparent;

    final Gradient? gradient = isDefault
        ? LinearGradient(
            colors: [Colors.black, AppColors.buttonColor],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )
        : null;

    final IconData icon = success
        ? Icons.check_circle_rounded
        : error
        ? Icons.error_rounded
        : Icons.info_outline;

    final Color iconColor = success
        ? Colors.lightGreenAccent
        : error
        ? Colors.redAccent.shade100
        : Colors.white;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 10 * (1 - value)),
                child: child,
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isDefault ? null : baseColor,
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(icon, color: iconColor, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
