import 'package:bin_management_system/config/app_colors/app_colors.dart';
import 'package:bin_management_system/core/utils/app_text/app_text.dart';
import 'package:bin_management_system/views/booking_details_view/components/status_badge.dart';
import 'package:flutter/material.dart';

class WorkerRow extends StatelessWidget {
  final String name;
  final String email;
  final bool isActive;
  final bool isLast;

  const WorkerRow({
    super.key,
    required this.name,
    required this.email,
    required this.isActive,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.loginBg.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_outline,
                  size: 17,
                  color: AppColors.loginBg,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      title: name,
                      size: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    const SizedBox(height: 1),
                    AppText(
                      title: email,
                      size: 12,
                      color: Colors.grey.shade500,
                    ),
                  ],
                ),
              ),
              StatusBadge(status: isActive ? 'ACTIVE' : 'INACTIVE'),
            ],
          ),
        ),
        if (!isLast) Divider(height: 1, color: Colors.grey.shade100),
      ],
    );
  }
}
