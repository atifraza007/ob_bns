import 'package:bin_management_system/config/app_colors/app_colors.dart';
import 'package:bin_management_system/core/utils/app_text/app_text.dart';
import 'package:bin_management_system/views/booking_details_view/components/status_badge.dart';
import 'package:flutter/material.dart';

// ── Section Card ──────────────────────────────────────────────────────────────

class SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const SectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: AppColors.loginBg.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(6),
              ),
              border: const Border(
                bottom: BorderSide(color: Color(0xFFE8E8E8)),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, size: 16, color: AppColors.loginBg),
                const SizedBox(width: 8),
                AppText(
                  title: title,
                  size: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.loginBg,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Info Row ──────────────────────────────────────────────────────────────────

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;
  final bool isStatus;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.isLast = false,
    this.isStatus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                child: AppText(
                  title: label,
                  size: 13,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: isStatus
                    ? StatusBadge(status: value)
                    : AppText(
                        title: value,
                        size: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
              ),
            ],
          ),
        ),
        if (!isLast) Divider(height: 1, color: Colors.grey.shade100),
      ],
    );
  }
}

// ── Internal Section Divider ──────────────────────────────────────────────────

class SectionDivider extends StatelessWidget {
  const SectionDivider({super.key});

  @override
  Widget build(BuildContext context) =>
      Divider(height: 16, color: Colors.grey.shade200, thickness: 1);
}
