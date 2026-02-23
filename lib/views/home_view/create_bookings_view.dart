import 'dart:io';

import 'package:bin_management_system/config/app_colors/app_colors.dart';
import 'package:bin_management_system/core/controllers/data_controller/data_controller.dart';
import 'package:bin_management_system/core/utils/app_button/app_button.dart';
import 'package:bin_management_system/core/utils/app_field/app_field.dart';
import 'package:bin_management_system/core/utils/app_text/app_text.dart';
import 'package:bin_management_system/core/utils/lottie_loader/lottie_loader.dart';
import 'package:bin_management_system/views/home_view/controller/components/common_components.dart';
import 'package:bin_management_system/views/home_view/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreateBookingView extends StatelessWidget {
  CreateBookingView({super.key});

  final DataController dataController = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<HomeController>();
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFFF4F6F8),
          appBar: AppBar(
            backgroundColor: AppColors.loginBg,
            title: AppText(
              title: 'Create Booking',
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Dates ───────────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionLabel(label: 'Start Date'),
                          Obx(
                            () => DateTile(
                              label: ctrl.startDate.value != null
                                  ? dateFormat.format(ctrl.startDate.value!)
                                  : 'dd/MM/yyyy',
                              onTap: () => ctrl.pickStartDate(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionLabel(label: 'Expected Date'),
                          Obx(
                            () => DateTile(
                              label: ctrl.expectedDate.value != null
                                  ? dateFormat.format(ctrl.expectedDate.value!)
                                  : 'dd/MM/yyyy',
                              onTap: () => ctrl.pickExpectedDate(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ── Subcontractor Dropdown ───────────────────────────────
                SectionLabel(label: 'Subcontractor'),
                Obx(
                  () => StyledDropdown<String>(
                    value: ctrl.selectedSubcontractorId.value,
                    hint: 'Select subcontractor',
                    items: ctrl.subcontractors
                        .map(
                          (s) => DropdownMenuItem(
                            value: s.id,
                            child: Text(s.name),
                          ),
                        )
                        .toList(),
                    onChanged: (val) =>
                        ctrl.selectedSubcontractorId.value = val,
                  ),
                ),
                const SizedBox(height: 16),

                // ── Bin Multi-select Dropdown ────────────────────────────
                SectionLabel(label: 'Bins'),
                MultiBinDropdown(ctrl: ctrl, dataController: dataController),
                const SizedBox(height: 16),

                // ── Multi-image Picker ───────────────────────────────────
                SectionLabel(label: 'Attachments (optional)'),
                _MultiImagePicker(ctrl: ctrl),
                const SizedBox(height: 16),

                // ── Notes ────────────────────────────────────────────────
                SectionLabel(label: 'Notes'),
                AppField(
                  controller: ctrl.notesController,
                  hint: 'Write any notes here...',
                  maxLines: 4,
                  label: '',
                ),
                const SizedBox(height: 28),

                // ── Submit ───────────────────────────────────────────────
                AppButton(
                  label: 'Create Booking',
                  isLoading: false,
                  onPressed: ctrl.createBooking,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),

        // ── Lottie loading overlay ─────────────────────────────────────
        Obx(
          () => Material(
            color: Colors.transparent,
            child: LottieOverlay(
              visible: dataController.createBookingLoader.value,
              message: 'Creating booking…',
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Multi-image picker — grid layout with add button
// ─────────────────────────────────────────────────────────────────────────────
class _MultiImagePicker extends StatelessWidget {
  const _MultiImagePicker({required this.ctrl});

  final HomeController ctrl;

  // 3 columns, each cell is a square
  static const int _columns = 3;
  static const double _gap = 8.0;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final images = ctrl.pickedImages; // RxList read ✓

      // Total items = images + 1 "Add" button
      final int itemCount = images.length + 1;

      // Calculate grid height so we avoid unbounded height inside
      // SingleChildScrollView — compute number of rows × cell size.
      final double cellSize =
          (MediaQuery.of(context).size.width - 32 - (_gap * (_columns - 1))) /
          _columns;
      final int rows = (itemCount / _columns).ceil();
      final double gridHeight = rows * cellSize + (rows - 1) * _gap;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Grid ────────────────────────────────────────────────────
          SizedBox(
            height: gridHeight,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _columns,
                crossAxisSpacing: _gap,
                mainAxisSpacing: _gap,
              ),
              itemCount: itemCount,
              itemBuilder: (context, index) {
                // Last slot → "Add" button
                if (index == images.length) {
                  return _AddButton(onTap: () => ctrl.pickImage(context));
                }
                return _ImageThumb(
                  file: images[index],
                  onRemove: () => ctrl.removeImage(index),
                );
              },
            ),
          ),

          // ── Counter label ────────────────────────────────────────────
          if (images.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.photo_library_outlined,
                  size: 14,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(width: 5),
                AppText(
                  title:
                      '${images.length} ${images.length == 1 ? 'image' : 'images'} selected',
                  size: 12,
                  color: Colors.grey.shade500,
                ),
              ],
            ),
          ],
        ],
      );
    });
  }
}

// ── Single thumbnail — × button sits inside the cell, never clipped ───────────
class _ImageThumb extends StatelessWidget {
  const _ImageThumb({required this.file, required this.onRemove});

  final File file;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Image
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(file, fit: BoxFit.cover),
        ),
        // × remove — anchored inside the cell (top-right corner)
        Positioned(
          top: 5,
          right: 5,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 13),
            ),
          ),
        ),
      ],
    );
  }
}

// ── "Add Photo" tile ──────────────────────────────────────────────────────────
class _AddButton extends StatelessWidget {
  const _AddButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFDDE3EC), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_a_photo_outlined,
              size: 26,
              color: AppColors.primary,
            ),
            const SizedBox(height: 6),
            Text(
              'Add Photo',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
