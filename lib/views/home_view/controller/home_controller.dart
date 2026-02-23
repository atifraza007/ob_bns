import 'dart:io';
import 'package:bin_management_system/config/app_colors/app_colors.dart';
import 'package:bin_management_system/core/controllers/data_controller/data_controller.dart';
import 'package:bin_management_system/views/home_view/controller/components/image_picker_widget.dart';
import 'package:bin_management_system/views/home_view/multiple_camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SubcontractorModel {
  final String id;
  final String name;
  SubcontractorModel({required this.id, required this.name});
}

class HomeController extends GetxController {
  final DataController dataController = Get.put(DataController());

  final subcontractors = <SubcontractorModel>[
    SubcontractorModel(id: '1', name: 'John Smith'),
    SubcontractorModel(id: '2', name: 'Sara Lee'),
    SubcontractorModel(id: '3', name: 'Mike Johnson'),
    SubcontractorModel(id: '4', name: 'Emily Davis'),
    SubcontractorModel(id: '5', name: 'Tom Wilson'),
  ];

  // ---------- Form State ----------
  final bookingNameController = TextEditingController();
  final notesController = TextEditingController();

  final startDate = Rxn<DateTime>();
  final expectedDate = Rxn<DateTime>();
  final selectedSubcontractorId = RxnString();
  final selectedBinIds = <String>[].obs;

  /// All selected/captured images
  final pickedImages = <File>[].obs;

  String? get selectedSubcontractorName {
    if (selectedSubcontractorId.value == null) return null;
    return subcontractors
        .firstWhereOrNull((s) => s.id == selectedSubcontractorId.value)
        ?.name;
  }

  List<String> get selectedBinSerials {
    final apiBins = dataController.availableBins.value.bins ?? [];
    return apiBins
        .where((b) => selectedBinIds.contains(b.id?.toString()))
        .map((b) => b.serialNumber ?? '')
        .where((s) => s.isNotEmpty)
        .toList();
  }

  void toggleBinSelection(String binId) {
    if (selectedBinIds.contains(binId)) {
      selectedBinIds.remove(binId);
    } else {
      selectedBinIds.add(binId);
    }
  }

  Future<void> pickStartDate(BuildContext context) async {
    final picked = await showAppDatePicker(
      context: context,
      initialDate: startDate.value ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      startDate.value = picked;
      if (expectedDate.value != null && !expectedDate.value!.isAfter(picked)) {
        expectedDate.value = null;
      }
    }
  }

  Future<void> pickExpectedDate(BuildContext context) async {
    final firstAllowed = startDate.value != null
        ? startDate.value!.add(const Duration(days: 1))
        : DateTime.now().add(const Duration(days: 1));
    final picked = await showAppDatePicker(
      context: context,
      initialDate: expectedDate.value ?? firstAllowed,
      firstDate: firstAllowed,
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      expectedDate.value = picked;
    }
  }

  /// Shows bottom sheet: Camera (custom screen) or Gallery (multi-pick)
  Future<void> pickImage(BuildContext context) async {
    Get.bottomSheet(
      _ImageSourceSheet(controller: this),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }

  /// Opens the custom multi-capture camera screen.
  /// Awaits result (List<File>) and appends to pickedImages.
  Future<void> openCameraScreen() async {
    Get.back(); // close bottom sheet first
    final result = await Get.to(() => const MultiCameraScreen());
    if (result is List<File> && result.isNotEmpty) {
      pickedImages.addAll(result);
    }
  }

  /// Picks multiple images from gallery and appends them.
  Future<void> pickFromGallery() async {
    Get.back(); // close bottom sheet first
    final picker = ImagePicker();
    final xfiles = await picker.pickMultiImage(imageQuality: 85);
    if (xfiles.isNotEmpty) {
      pickedImages.addAll(xfiles.map((x) => File(x.path)));
    }
  }

  /// Removes a single image from the list by index.
  void removeImage(int index) {
    if (index >= 0 && index < pickedImages.length) {
      pickedImages.removeAt(index);
    }
  }

  void createBooking() async {
    if (startDate.value == null || expectedDate.value == null) {
      Get.snackbar('Validation', 'Please select both start and expected dates');
      return;
    }
    if (selectedSubcontractorId.value == null) {
      Get.snackbar('Validation', 'Please select a subcontractor');
      return;
    }
    if (selectedBinIds.isEmpty) {
      Get.snackbar('Validation', 'Please select at least one bin');
      return;
    }

    final siteId = await dataController.getSiteIdFromStorage();

    final obj = {
      'siteId': siteId,
      'subcontractorId': selectedSubcontractorId.value,
      'startDate': startDate.value.toString(),
      'expectedEndDate': expectedDate.value.toString(),
      'binIds': selectedBinIds.toList(),
      'photoPaths': pickedImages.map((f) => f.path).toList(),
      'notes': notesController.text.trim(),
    };

    print('📦 New Booking Object: $obj');
    dataController.createBooking(obj);
  }

  void resetForm() {
    bookingNameController.clear();
    notesController.clear();
    startDate.value = null;
    expectedDate.value = null;
    selectedSubcontractorId.value = null;
    selectedBinIds.clear();
    pickedImages.clear();
  }

  @override
  void onClose() {
    bookingNameController.dispose();
    notesController.dispose();
    super.onClose();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom sheet — choose Camera (custom screen) or Gallery
// ─────────────────────────────────────────────────────────────────────────────
class _ImageSourceSheet extends StatelessWidget {
  const _ImageSourceSheet({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Add Photos',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1D23),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              // Camera option
              Expanded(
                child: _SourceOption(
                  icon: Icons.camera_alt_outlined,
                  label: 'Camera',
                  subtitle: 'Capture multiple',
                  onTap: controller.openCameraScreen,
                ),
              ),
              const SizedBox(width: 12),
              // Gallery option
              Expanded(
                child: _SourceOption(
                  icon: Icons.photo_library_outlined,
                  label: 'Gallery',
                  subtitle: 'Pick multiple',
                  onTap: controller.pickFromGallery,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _SourceOption extends StatelessWidget {
  const _SourceOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F6F8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFDDE3EC), width: 1.2),
        ),
        child: Column(
          children: [
            Icon(icon, size: 30, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1D23),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}
