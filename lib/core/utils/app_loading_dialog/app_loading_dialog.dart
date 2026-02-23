import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bin_management_system/config/app_colors/app_colors.dart';
import 'package:bin_management_system/core/utils/app_text/app_text.dart';

class AppLoadingDialog extends StatefulWidget {
  final bool isLoading;
  final String text;

  const AppLoadingDialog({
    super.key,
    required this.isLoading,
    this.text = "Loading",
  });

  @override
  State<AppLoadingDialog> createState() => _AppLoadingDialogState();
}

class _AppLoadingDialogState extends State<AppLoadingDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.isLoading,
      child: AnimatedOpacity(
        opacity: widget.isLoading ? 1 : 0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        child: Stack(
          children: [
            /// Smooth blurred background
            Positioned.fill(
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: widget.isLoading ? 8 : 0),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                builder: (context, sigma, _) => BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
                  child: Container(color: Colors.black.withValues(alpha: 0.25)),
                ),
              ),
            ),

            /// Center dialog with fade+scale animation
            Center(
              child: AnimatedScale(
                scale: widget.isLoading ? 1 : 0.9,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                child: AnimatedOpacity(
                  opacity: widget.isLoading ? 1 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: IntrinsicWidth(
                    child: IntrinsicHeight(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            /// Pulsing activity indicator
                            ScaleTransition(
                              scale: Tween(begin: 0.9, end: 1.1).animate(
                                CurvedAnimation(
                                  parent: _pulseController,
                                  curve: Curves.easeInOut,
                                ),
                              ),
                              child: const CupertinoActivityIndicator(),
                            ),
                            const SizedBox(width: 12),
                            AppText(
                              title: widget.text,
                              color: AppColors.black,
                              size: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
