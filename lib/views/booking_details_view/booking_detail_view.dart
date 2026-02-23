import 'package:bin_management_system/config/app_colors/app_colors.dart';
import 'package:bin_management_system/core/controllers/data_controller/data_controller.dart';
import 'package:bin_management_system/core/utils/app_button/app_button.dart';
import 'package:bin_management_system/core/utils/app_snackbar/app_snackbar.dart';
import 'package:bin_management_system/core/utils/app_text/app_text.dart';
import 'package:bin_management_system/core/utils/lottie_loader/lottie_loader.dart';
import 'package:bin_management_system/models/booking_model.dart';
import 'package:bin_management_system/views/booking_details_view/components/bin_selection.dart';
import 'package:bin_management_system/views/booking_details_view/components/section_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BookingDetailView extends StatefulWidget {
  final String bookingId;

  const BookingDetailView({super.key, required this.bookingId});

  @override
  State<BookingDetailView> createState() => _BookingDetailViewState();
}

class _BookingDetailViewState extends State<BookingDetailView> {
  final Set<int> _selectedBinIds = {};
  final DataController dataController = Get.find<DataController>();

  static String _fmt(String? iso) {
    if (iso == null || iso.isEmpty) return '—';
    try {
      return DateFormat('dd/MM/yyyy').format(DateTime.parse(iso).toLocal());
    } catch (_) {
      return '—';
    }
  }

  void _toggleBin(Items item) {
    if (item.returnedAt != null) {
      CustomSnackbar.showCustomSnackBar(
        context,
        'This bin has already been returned.',
      );
      return;
    }

    final binId = item.bin?.id ?? 0;
    setState(() {
      _selectedBinIds.contains(binId)
          ? _selectedBinIds.remove(binId)
          : _selectedBinIds.add(binId);
    });
  }

  // ── Return ──────────────────────────────────────────────────────────────────
  void _onReturn() {
    if (_selectedBinIds.isEmpty) {
      CustomSnackbar.showCustomSnackBar(
        context,
        'Please select at least one bin to return.',
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Return Bins',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Are you sure you want to return the selected bins?',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 11),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        dataController
                            .completeBooking(
                              bookingId: widget.bookingId,
                              body: {
                                'returnedBinIds': _selectedBinIds.toList(),
                              },
                              siteId: dataController
                                  .bookingDetailModel
                                  .value
                                  .siteId
                                  .toString(),
                            )
                            .whenComplete(() {
                              setState(() => _selectedBinIds.clear());
                              // Re-fetch to update the detail screen
                              dataController.fetchBookingDetails(
                                bookingId: widget.bookingId,
                              );
                            });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 11),
                      ),
                      child: const Text(
                        'Return',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Complete ────────────────────────────────────────────────────────────────
  void _onComplete() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Complete Booking',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Are you sure you want to complete this booking?',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 11),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        dataController
                            .completeBooking(
                              bookingId: widget.bookingId,
                              siteId: dataController
                                  .bookingDetailModel
                                  .value
                                  .siteId
                                  .toString(),
                            )
                            .whenComplete(
                              // Re-fetch to update the detail screen
                              () => dataController.fetchBookingDetails(
                                bookingId: widget.bookingId,
                              ),
                            );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.loginBg,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 11),
                      ),
                      child: const Text(
                        'Complete',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Build ───────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: AppColors.loginBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: AppText(
          title: 'Booking Detail',
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Stack(
        children: [
          Obx(() {
            final booking = dataController.bookingDetailModel.value;
            final subcontractor = booking.subcontractor;
            final items = booking.items ?? [];
            // final workers = subcontractor?.workers ?? [];

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SectionCard(
                  title: 'Booking Information',
                  icon: Icons.receipt_long_outlined,
                  children: [
                    InfoRow(
                      label: 'Reference',
                      value: booking.bookingRef ?? '—',
                    ),
                    InfoRow(
                      label: 'Status',
                      value: booking.status ?? '—',
                      isStatus: true,
                    ),
                    InfoRow(
                      label: 'Start Date',
                      value: _fmt(booking.startDate),
                    ),
                    InfoRow(
                      label: 'Expected End',
                      value: _fmt(booking.expectedEndDate),
                    ),
                    InfoRow(
                      label: 'Created On',
                      value: _fmt(booking.createdAt),
                      isLast: true,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                BinsSection(
                  items: items,
                  selectedBinIds: _selectedBinIds,
                  onToggle: _toggleBin,
                  onReturn: _onReturn,
                  fmtDate: _fmt,
                ),
                const SizedBox(height: 12),

                if (subcontractor != null)
                  SectionCard(
                    title: 'Subcontractor',
                    icon: Icons.business_outlined,
                    children: [
                      InfoRow(
                        label: 'Company',
                        value: subcontractor.companyName ?? '—',
                      ),
                      // if (workers.isNotEmpty) ...[
                      //   const SectionDivider(),
                      //   Padding(
                      //     padding: const EdgeInsets.only(bottom: 8),
                      //     child: AppText(
                      //       title: 'Workers (${workers.length})',
                      //       size: 12,
                      //       fontWeight: FontWeight.w600,
                      //       color: Colors.grey.shade600,
                      //     ),
                      //   ),
                      //   ...workers.asMap().entries.map((e) {
                      //     final w = e.value;
                      //     return WorkerRow(
                      //       name: w.name ?? '—',
                      //       email: w.email ?? '—',
                      //       isActive: w.isActive ?? false,
                      //       isLast: e.key == workers.length - 1,
                      //     );
                      //   }),
                      // ],
                    ],
                  ),

                const SizedBox(height: 24),

                Obx(() {
                  final isCompleted =
                      dataController.bookingDetailModel.value.status
                          ?.toLowerCase() ==
                      'completed';

                  return AppButton(
                    label: isCompleted
                        ? 'Booking Completed ✓'
                        : 'Complete Booking',
                    isLoading: false,
                    onPressed: isCompleted ? null : _onComplete,
                  );
                }),

                const SizedBox(height: 28),
              ],
            );
          }),

          // ── Loading Overlay ──────────────────────────────────────────────
          Obx(
            () => LottieOverlay(
              visible: dataController.bookingDetailLoader.value,
              message: 'Loading booking details…',
            ),
          ),
        ],
      ),
    );
  }
}
