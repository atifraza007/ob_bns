import 'package:bin_management_system/core/utils/app_text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:bin_management_system/config/app_colors/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool hasToggle;
  final int? maxLines;

  const AppField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.hasToggle = false,
    this.maxLines,
  });

  @override
  State<AppField> createState() => _AppFieldState();
}

class _AppFieldState extends State<AppField> {
  late bool _obscure;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    // Flutter does not allow obscured fields to be multiline —
    // if obscureText is true, maxLines must always be 1.
    final effectiveMaxLines = _obscure ? 1 : widget.maxLines;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty) ...[
          AppText(
            title: widget.label,
            color: _isFocused ? AppColors.accent : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 8),
        ],
        Focus(
          onFocusChange: (focused) => setState(() => _isFocused = focused),
          child: TextFormField(
            maxLines: effectiveMaxLines,
            controller: widget.controller,
            obscureText: _obscure,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            style: GoogleFonts.urbanist(
              fontSize: 15,
              color: AppColors.textPrimary,
              letterSpacing: 0.1,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: const TextStyle(
                fontSize: 14,
                color: AppColors.textHint,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: widget.prefixIcon,
                    )
                  : null,
              prefixIconConstraints: const BoxConstraints(
                minWidth: 48,
                minHeight: 48,
              ),
              suffixIcon: widget.hasToggle
                  ? GestureDetector(
                      onTap: () => setState(() => _obscure = !_obscure),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Icon(
                          _obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                          color: _isFocused
                              ? AppColors.accent
                              : AppColors.textHint,
                        ),
                      ),
                    )
                  : widget.suffixIcon,
              suffixIconConstraints: const BoxConstraints(
                minWidth: 48,
                minHeight: 48,
              ),
              filled: true,
              fillColor: _isFocused
                  ? AppColors.accentLight
                  : AppColors.background,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.border,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.border,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.error,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.error, width: 2),
              ),
              errorStyle: const TextStyle(
                fontSize: 12,
                color: AppColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
