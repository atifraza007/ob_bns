import 'package:bin_management_system/config/app_colors/app_colors.dart';
import 'package:bin_management_system/core/utils/app_text/app_text.dart';
import 'package:flutter/material.dart';

class BookingTile extends StatelessWidget {
  final String bookingName;
  final String subcontractorName;
  final String binName;
  final String status;
  final VoidCallback? onTap;

  const BookingTile({
    super.key,
    required this.bookingName,
    required this.subcontractorName,
    required this.binName,
    required this.status,
    this.onTap,
  });

  _StatusStyle _getStatusStyle(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return _StatusStyle(
          color: const Color(0xFF2E7D32),
          background: const Color(0xFFE8F5E9),
          icon: Icons.check_circle_outline_rounded,
        );
      case 'active':
        return _StatusStyle(
          color: const Color(0xFF1565C0),
          background: const Color(0xFFE3F2FD),
          icon: Icons.timelapse_rounded,
        );
      case 'pending':
        return _StatusStyle(
          color: const Color(0xFFE65100),
          background: const Color(0xFFFFF3E0),
          icon: Icons.hourglass_empty_rounded,
        );
      case 'cancelled':
        return _StatusStyle(
          color: const Color(0xFFC62828),
          background: const Color(0xFFFFEBEE),
          icon: Icons.cancel_outlined,
        );
      default:
        return _StatusStyle(
          color: Colors.grey.shade700,
          background: Colors.grey.shade100,
          icon: Icons.info_outline,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusStyle = _getStatusStyle(status);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Icon ────────────────────────────────────────────────────
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.loginBg.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.receipt_long_outlined,
                  color: AppColors.loginBg,
                  size: 22,
                ),
              ),
              const SizedBox(width: 13),

              // ── Content ──────────────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Booking Name
                    AppText(
                      title: bookingName,
                      fontWeight: FontWeight.w600,
                      size: 14.5,
                      color: Colors.black87,
                    ),
                    const SizedBox(height: 6),

                    // Subcontractor
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 13,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        AppText(
                          title: subcontractorName,
                          size: 12.5,
                          color: Colors.grey.shade500,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),

                    // Bin
                    Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          size: 13,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        AppText(
                          title: binName,
                          size: 12.5,
                          color: Colors.grey.shade500,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: statusStyle.background,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            statusStyle.icon,
                            size: 11,
                            color: statusStyle.color,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            status[0].toUpperCase() +
                                status.substring(1).toLowerCase(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: statusStyle.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 4),
              Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Helper ───────────────────────────────────────────────────────────────────
class _StatusStyle {
  final Color color;
  final Color background;
  final IconData icon;

  _StatusStyle({
    required this.color,
    required this.background,
    required this.icon,
  });
}
