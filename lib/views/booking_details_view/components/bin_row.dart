import 'package:bin_management_system/config/app_colors/app_colors.dart';
import 'package:bin_management_system/core/utils/app_text/app_text.dart';
import 'package:bin_management_system/views/booking_details_view/components/status_badge.dart';
import 'package:flutter/material.dart';

class BinRow extends StatelessWidget {
  final String serial;
  final bool isActive;
  final String startDate;
  final String expectedEnd;
  final String? returnedAt;
  final bool isLast;

  const BinRow({
    super.key,
    required this.serial,
    required this.isActive,
    required this.startDate,
    required this.expectedEnd,
    this.returnedAt,
    required this.isLast,
  });

  bool get isReturned => returnedAt != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Opacity(
            // Dim the whole row when already returned
            opacity: isReturned ? 0.5 : 1.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    // Grey tint when returned, brand colour when active
                    color: isReturned
                        ? Colors.grey.withOpacity(0.12)
                        : AppColors.loginBg.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: isReturned
                        ? Colors.grey.shade400
                        : AppColors.loginBg,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AppText(
                            title: serial,
                            size: 13,
                            fontWeight: FontWeight.w600,
                            color: isReturned ? Colors.grey : Colors.black87,
                          ),
                          const SizedBox(width: 8),
                          StatusBadge(status: isActive ? 'ACTIVE' : 'INACTIVE'),
                          // Extra "Returned" badge when applicable
                          if (isReturned) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.green.shade200,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                'Returned',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 11,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(width: 4),
                          AppText(
                            title: '$startDate → $expectedEnd',
                            size: 12,
                            color: Colors.grey.shade500,
                          ),
                        ],
                      ),
                      if (isReturned) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 11,
                              color: Colors.green.shade400,
                            ),
                            const SizedBox(width: 4),
                            AppText(
                              title: 'Returned: $returnedAt',
                              size: 12,
                              color: Colors.green.shade600,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!isLast) Divider(height: 1, color: Colors.grey.shade100),
      ],
    );
  }
}
