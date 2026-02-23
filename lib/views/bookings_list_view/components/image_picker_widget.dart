// Bottom sheet widget
import 'package:bin_management_system/config/app_colors/app_colors.dart';
import 'package:bin_management_system/views/bookings_list_view/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImagePickerSheet extends StatelessWidget {
  const ImagePickerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<HomeController>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Image Source',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.photo_library_outlined),
            title: const Text('Choose from Gallery'),
            onTap: ctrl.pickFromGallery,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.camera_alt_outlined),
            title: const Text('Open Camera'),
            // onTap: ctrl.pickFromCamera,
          ),
        ],
      ),
    );
  }
}

Future<DateTime?> showAppDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) {
  return showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            // Header background & selected day fill
            primary: AppColors.loginBg,
            // Header text & selected day text
            onPrimary: Colors.white,
            // Calendar surface background
            surface: Colors.white,
            // Default day number text
            onSurface: Colors.black87,
          ),
          // OK / Cancel button style
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.loginBg,
              textStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          // Dialog rounded corners
          dialogTheme: const DialogThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
          // Text styles used internally by the picker
          textTheme: Theme.of(context).textTheme.copyWith(
            // Day number cells
            bodyMedium: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            // Month + year header label
            titleMedium: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ),
        child: child!,
      );
    },
  );
}
