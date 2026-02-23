// ── Multi-Bin Dropdown ────────────────────────────────────────────────────────

import 'package:bin_management_system/config/app_colors/app_colors.dart';
import 'package:bin_management_system/core/controllers/data_controller/data_controller.dart';
import 'package:bin_management_system/core/utils/app_text/app_text.dart';
import 'package:bin_management_system/views/bookings_list_view/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MultiBinDropdown extends StatelessWidget {
  final HomeController ctrl;
  final DataController dataController;
  const MultiBinDropdown({
    super.key,
    required this.ctrl,
    required this.dataController,
  });

  void _openBinSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      isScrollControlled: true,
      builder: (_) =>
          BinSelectionSheet(ctrl: ctrl, dataController: dataController),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final apiBins = dataController.availableBins.value.bins ?? [];
      final selectedSerials = apiBins
          .where((b) => ctrl.selectedBinIds.contains(b.id?.toString()))
          .map((b) => b.serialNumber ?? '')
          .where((s) => s.isNotEmpty)
          .toList();

      return GestureDetector(
        onTap: () => _openBinSheet(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  selectedSerials.isEmpty
                      ? 'Select bins'
                      : selectedSerials.join(', '),
                  style: TextStyle(
                    fontSize: 14,
                    color: selectedSerials.isEmpty
                        ? Colors.grey.shade500
                        : Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
            ],
          ),
        ),
      );
    });
  }
}

// ── Bin Selection Sheet ───────────────────────────────────────────────────────

class BinSelectionSheet extends StatelessWidget {
  final HomeController ctrl;
  final DataController dataController;

  const BinSelectionSheet({
    super.key,
    required this.ctrl,
    required this.dataController,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        final isLoading = dataController.availableBinsLoader.value;
        final apiBins = dataController.availableBins.value.bins ?? [];

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 8, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Bins',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'Done',
                      style: TextStyle(
                        color: AppColors.loginBg,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // ── Loading state ────────────────────────────────
            if (isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.loginBg,
                    strokeWidth: 2.5,
                  ),
                ),
              )
            // ── Empty state ──────────────────────────────────
            else if (apiBins.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: AppText(
                    title: 'No bins available',
                    color: Colors.grey.shade500,
                    size: 14,
                  ),
                ),
              )
            // ── Bin list ─────────────────────────────────────
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: apiBins.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: Colors.grey.shade100),
                itemBuilder: (context, index) {
                  final bin = apiBins[index];
                  final binId = bin.id?.toString() ?? '';
                  return Obx(() {
                    final isSelected = ctrl.selectedBinIds.contains(binId);
                    return InkWell(
                      onTap: () => ctrl.toggleBinSelection(binId),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              size: 20,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                bin.serialNumber ?? '—',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isSelected
                                      ? AppColors.loginBg
                                      : Colors.black87,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: AppColors.loginBg,
                                size: 20,
                              )
                            else
                              Icon(
                                Icons.radio_button_unchecked,
                                color: Colors.grey.shade400,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    );
                  });
                },
              ),
            const SizedBox(height: 8),
          ],
        );
      }),
    );
  }
}

// ── Shared Helper Widgets ─────────────────────────────────────────────────────

class SectionLabel extends StatelessWidget {
  final String label;
  const SectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: AppText(
        title: label,
        size: 13,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }
}

class DateTile extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const DateTile({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 15,
              color: Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: label == 'dd/MM/yyyy'
                      ? Colors.grey.shade500
                      : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StyledDropdown<T> extends StatelessWidget {
  final T? value;
  final String hint;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const StyledDropdown({
    super.key,
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          hint: Text(
            hint,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
          items: items,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
          dropdownColor: Colors.white,
        ),
      ),
    );
  }
}
