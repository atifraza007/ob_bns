import 'package:bin_management_system/config/app_colors/app_colors.dart';
import 'package:bin_management_system/core/utils/app_text/app_text.dart';
import 'package:bin_management_system/models/booking_model.dart';
import 'package:bin_management_system/views/booking_details_view/components/bin_row.dart';
import 'package:bin_management_system/views/booking_details_view/components/section_card.dart';
import 'package:flutter/material.dart';

class BinsSection extends StatelessWidget {
  const BinsSection({super.key, 
    required this.items,
    required this.selectedBinIds,
    required this.onToggle,
    required this.onReturn,
    required this.fmtDate,
  });

  final List<Items> items;
  final Set<int> selectedBinIds;
  final void Function(Items item) onToggle;
  final VoidCallback onReturn;
  final String Function(String?) fmtDate;

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
          // ── Header ───────────────────────────────────────────────────
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
                Icon(Icons.delete_outline, size: 16, color: AppColors.loginBg),
                const SizedBox(width: 8),
                Expanded(
                  child: AppText(
                    title: 'Assigned Bins (${items.length})',
                    size: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.loginBg,
                  ),
                ),
                if (items.isNotEmpty)
                  GestureDetector(
                    onTap: onReturn,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: selectedBinIds.isNotEmpty
                            ? Colors.red
                            : Colors.red.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.undo_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            selectedBinIds.isEmpty
                                ? 'Return'
                                : 'Return (${selectedBinIds.length})',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── Hint ─────────────────────────────────────────────────────
          if (items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 13,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(width: 5),
                  AppText(
                    title: 'Tap a bin to select it for return',
                    size: 11,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),

          // ── Rows ─────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Column(
              children: items.isEmpty
                  ? [
                      InfoRow(
                        label: 'Bins',
                        value: 'No bins assigned',
                        isLast: true,
                      ),
                    ]
                  : items.asMap().entries.map((e) {
                      final item = e.value;
                      final bin = item.bin;
                      final binId = bin?.id ?? 0;
                      final isReturned = item.returnedAt != null;
                      final isSelected = selectedBinIds.contains(binId);

                      return GestureDetector(
                        onTap: () => onToggle(item), // full item ✓
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: isReturned
                                ? Colors.grey.withOpacity(0.05)
                                : isSelected
                                ? Colors.red.withOpacity(0.06)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isReturned
                                  ? Colors.grey.withOpacity(0.2)
                                  : isSelected
                                  ? Colors.red.withOpacity(0.4)
                                  : Colors.transparent,
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 4,
                                  right: 10,
                                ),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isReturned
                                        ? Colors.grey.shade200
                                        : isSelected
                                        ? Colors.red
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: isReturned
                                          ? Colors.grey.shade300
                                          : isSelected
                                          ? Colors.red
                                          : Colors.grey.shade300,
                                      width: 1.8,
                                    ),
                                  ),
                                  // Returned → lock icon; selected → check; else empty
                                  child: isReturned
                                      ? Icon(
                                          Icons.lock_outline,
                                          color: Colors.grey.shade400,
                                          size: 11,
                                        )
                                      : isSelected
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 12,
                                        )
                                      : null,
                                ),
                              ),
                              Expanded(
                                child: BinRow(
                                  serial: bin?.serialNumber ?? '—',
                                  isActive: bin?.isActive ?? false,
                                  startDate: fmtDate(item.startDate),
                                  expectedEnd: fmtDate(item.expectedEndDate),
                                  returnedAt: item.returnedAt != null
                                      ? fmtDate(item.returnedAt)
                                      : null,
                                  isLast: e.key == items.length - 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
