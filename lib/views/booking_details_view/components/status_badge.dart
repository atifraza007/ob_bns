import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge({super.key, required this.status});

  Color get _bgColor {
    switch (status.toUpperCase()) {
      case 'APPROVED':
        return const Color(0xFFE3F2FD);
      case 'PENDING':
        return const Color(0xFFFFF8E1);
      case 'REJECTED':
        return const Color(0xFFFFEBEE);
      case 'ACTIVE':
        return const Color(0xFFE6F4EA);
      case 'COMPLETED':
        return const Color(0xFFE6F4EA);

      default:
        return Colors.grey.shade100;
    }
  }

  Color get _textColor {
    switch (status.toUpperCase()) {
      case 'APPROVED':
        return const Color(0xFF1565C0);
      case 'PENDING':
        return const Color(0xFFF9A825);
      case 'REJECTED':
        return const Color(0xFFC62828);
      case 'ACTIVE':
        return const Color(0xFF2E7D32);
      case 'COMPLETED':
        return const Color(0xFF2E7D32);

      default:
        return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final display = status.isNotEmpty
        ? status[0].toUpperCase() + status.substring(1).toLowerCase()
        : status;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        display,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _textColor,
        ),
      ),
    );
  }
}
