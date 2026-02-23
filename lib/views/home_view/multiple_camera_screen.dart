import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bin_management_system/config/app_colors/app_colors.dart';

/// Push this screen and await the result:
///
///   final result = await Get.to(() => const MultiCameraScreen());
///   if (result is List<File> && result.isNotEmpty) {
///     ctrl.pickedImages.addAll(result);
///   }
///
class MultiCameraScreen extends StatefulWidget {
  const MultiCameraScreen({super.key});

  @override
  State<MultiCameraScreen> createState() => _MultiCameraScreenState();
}

class _MultiCameraScreenState extends State<MultiCameraScreen>
    with WidgetsBindingObserver {
  CameraController? _cameraCtrl;
  List<CameraDescription> _cameras = [];
  int _selectedCamera = 0;

  bool _isInitialised = false;
  bool _isCapturing = false;

  /// All images captured in this session
  final List<File> _captured = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  Future<void> _initCamera({int cameraIndex = 0}) async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        _showError('No cameras found on this device.');
        return;
      }

      final controller = CameraController(
        _cameras[cameraIndex],
        ResolutionPreset.high,
        enableAudio: false,
      );

      await controller.initialize();

      if (!mounted) return;
      setState(() {
        _cameraCtrl = controller;
        _selectedCamera = cameraIndex;
        _isInitialised = true;
      });
    } catch (e) {
      _showError('Camera initialisation failed: $e');
    }
  }

  Future<void> _flipCamera() async {
    if (_cameras.length < 2) return;
    setState(() => _isInitialised = false);
    await _cameraCtrl?.dispose();
    final next = (_selectedCamera + 1) % _cameras.length;
    await _initCamera(cameraIndex: next);
  }

  Future<void> _capture() async {
    if (_cameraCtrl == null || !_cameraCtrl!.value.isInitialized) return;
    if (_isCapturing) return;

    setState(() => _isCapturing = true);

    try {
      final xfile = await _cameraCtrl!.takePicture();
      setState(() {
        _captured.add(File(xfile.path));
        _isCapturing = false;
      });
    } catch (e) {
      setState(() => _isCapturing = false);
      _showError('Capture failed: $e');
    }
  }

  void _removeImage(int index) {
    setState(() => _captured.removeAt(index));
  }

  void _onOkay() {
    // Return the list back to the caller
    Get.back(result: List<File>.from(_captured));
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final ctrl = _cameraCtrl;
    if (ctrl == null || !ctrl.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      ctrl.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera(cameraIndex: _selectedCamera);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraCtrl?.dispose();
    super.dispose();
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──────────────────────────────────────────────────
            _TopBar(
              captureCount: _captured.length,
              onBack: () => Get.back(result: <File>[]),
              onFlip: _cameras.length > 1 ? _flipCamera : null,
            ),

            // ── Camera preview ───────────────────────────────────────────
            Expanded(
              child: _isInitialised
                  ? _CameraPreviewWidget(controller: _cameraCtrl!)
                  : const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
            ),

            // ── Captured thumbnails strip ────────────────────────────────
            if (_captured.isNotEmpty)
              _ThumbnailStrip(
                images: _captured,
                onRemove: _removeImage,
              ),

            // ── Bottom controls ──────────────────────────────────────────
            _BottomControls(
              isCapturing: _isCapturing,
              hasImages: _captured.isNotEmpty,
              onCapture: _capture,
              onOkay: _onOkay,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Top bar
// ─────────────────────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.captureCount,
    required this.onBack,
    this.onFlip,
  });

  final int captureCount;
  final VoidCallback onBack;
  final VoidCallback? onFlip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      color: Colors.black,
      child: Row(
        children: [
          // Back
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: onBack,
          ),
          const SizedBox(width: 4),
          // Title + count badge
          Expanded(
            child: Row(
              children: [
                const Text(
                  'Camera',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (captureCount > 0) ...[
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$captureCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Flip camera
          if (onFlip != null)
            IconButton(
              icon: const Icon(Icons.flip_camera_ios_outlined,
                  color: Colors.white),
              onPressed: onFlip,
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Camera preview
// ─────────────────────────────────────────────────────────────────────────────
class _CameraPreviewWidget extends StatelessWidget {
  const _CameraPreviewWidget({required this.controller});

  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: OverflowBox(
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: controller.value.previewSize?.height ?? 1,
            height: controller.value.previewSize?.width ?? 1,
            child: CameraPreview(controller),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Horizontal thumbnail strip
// ─────────────────────────────────────────────────────────────────────────────
class _ThumbnailStrip extends StatelessWidget {
  const _ThumbnailStrip({required this.images, required this.onRemove});

  final List<File> images;
  final void Function(int index) onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      color: Colors.black.withOpacity(0.75),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  images[index],
                  width: 68,
                  height: 68,
                  fit: BoxFit.cover,
                ),
              ),
              // Remove ×
              Positioned(
                top: -5,
                right: -5,
                child: GestureDetector(
                  onTap: () => onRemove(index),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close,
                        color: Colors.white, size: 12),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom controls — capture shutter + okay button
// ─────────────────────────────────────────────────────────────────────────────
class _BottomControls extends StatelessWidget {
  const _BottomControls({
    required this.isCapturing,
    required this.hasImages,
    required this.onCapture,
    required this.onOkay,
  });

  final bool isCapturing;
  final bool hasImages;
  final VoidCallback onCapture;
  final VoidCallback onOkay;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ── Placeholder (keeps shutter centred) ─────────────────────
          const SizedBox(width: 72),

          // ── Shutter button ───────────────────────────────────────────
          GestureDetector(
            onTap: isCapturing ? null : onCapture,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCapturing
                    ? Colors.grey.shade400
                    : Colors.white,
                border: Border.all(
                  color: Colors.white.withOpacity(0.6),
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.15),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: isCapturing
                  ? const Padding(
                      padding: EdgeInsets.all(18),
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
          ),

          // ── Okay button ──────────────────────────────────────────────
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: hasImages ? 1.0 : 0.3,
            child: GestureDetector(
              onTap: hasImages ? onOkay : null,
              child: Container(
                width: 72,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.buttonColor],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: hasImages
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: const Center(
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}