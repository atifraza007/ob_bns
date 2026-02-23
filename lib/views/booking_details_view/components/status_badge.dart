import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge({super.key, required this.status});

  String get _normalized => status.trim().toUpperCase();

  Color get _bgColor {
    switch (_normalized) {
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
      case 'PARTIAL_RETURNED':
        return const Color(0xFFE8F5E9);
      case 'CANCELLED':
        return const Color(0xFFF3E5F5);
      default:
        return Colors.grey.shade100;
    }
  }

  Color get _textColor {
    switch (_normalized) {
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
      case 'PARTIAL_RETURNED':
        return const Color(0xFF1B5E20);
      case 'CANCELLED':
        return const Color(0xFF6A1B9A);
      default:
        return Colors.grey.shade700;
    }
  }

  String get _displayStatus {
    if (_normalized.isEmpty) return status;

    return _normalized
        .toLowerCase()
        .split('_')
        .map((e) => e[0].toUpperCase() + e.substring(1))
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _displayStatus,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _textColor,
        ),
      ),
    );
  }
}
