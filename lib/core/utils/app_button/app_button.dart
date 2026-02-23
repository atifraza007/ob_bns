import 'package:bin_management_system/config/app_colors/app_colors.dart';
import 'package:bin_management_system/core/utils/app_text/app_text.dart';
import 'package:flutter/material.dart';

class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final double? width;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.width,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  bool get _isDisabled => widget.onPressed == null && !widget.isLoading;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _isDisabled ? null : (_) => _animController.forward(),
      onTapUp: _isDisabled ? null : (_) => _animController.reverse(),
      onTapCancel: _isDisabled ? null : () => _animController.reverse(),
      onTap: (_isDisabled || widget.isLoading) ? null : widget.onPressed,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Opacity(
          opacity: _isDisabled ? 0.5 : 1.0,
          child: Container(
            width: widget.width ?? double.infinity,
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: widget.isOutlined
                  ? null
                  : const LinearGradient(
                      colors: [AppColors.primary, AppColors.buttonColor],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
              border: widget.isOutlined
                  ? Border.all(color: AppColors.accent, width: 1.5)
                  : null,
              boxShadow: widget.isOutlined
                  ? null
                  : [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(
                          _isDisabled ? 0.1 : 0.35,
                        ),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
            ),
            child: Center(
              child: widget.isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.surface,
                        ),
                      ),
                    )
                  : AppText(
                      title: widget.label,
                      color: widget.isOutlined
                          ? AppColors.accent
                          : AppColors.surface,
                      fontWeight: FontWeight.w600,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
