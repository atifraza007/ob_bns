import 'package:bin_management_system/core/utils/app_appbar/app_appbar.dart';
import 'package:bin_management_system/core/utils/app_text/app_text.dart';
import 'package:bin_management_system/core/utils/lottie_loader/lottie_loader.dart';
import 'package:bin_management_system/views/auth_views/login_view/login_view.dart';
import 'package:bin_management_system/views/booking_details_view/booking_detail_view.dart';
import 'package:bin_management_system/views/home_view/components/logout_dialog.dart';
import 'package:bin_management_system/views/home_view/controller/components/booking_tile.dart';
import 'package:bin_management_system/views/home_view/controller/home_controller.dart';
import 'package:bin_management_system/views/home_view/create_bookings_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bin_management_system/config/app_colors/app_colors.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final dataController = controller.dataController;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppAppBar(
        title: 'Bookings',
        showLogo: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.power_settings_new, color: Colors.white),
            onPressed: () => showLogoutDialog(context, _logout),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Count bar ──────────────────────────────────
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Obx(() {
                  final count =
                      dataController.bookingsList.value.bookings?.length ?? 0;
                  return AppText(
                    title: '$count Bookings',
                    size: 13,
                    color: Colors.grey.shade600,
                  );
                }),
              ),
              const Divider(height: 1, color: Color(0xFFE0E0E0)),

              // ── List ───────────────────────────────────────
              Expanded(
                child: Obx(() {
                  final isLoading = dataController.isLoading.value;
                  final bookings =
                      dataController.bookingsList.value.bookings ?? [];

                  if (isLoading) return const SizedBox.shrink();

                  if (bookings.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 52,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          AppText(
                            title: 'No bookings yet',
                            color: Colors.grey.shade500,
                            size: 15,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 90),
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                      return BookingTile(
                        onTap: () {
                          dataController.fetchBookingDetails(
                            bookingId: booking.id.toString(),
                            isLoading: true,
                          );
                          Get.to(
                            () => BookingDetailView(
                              bookingId: booking.id.toString(),
                            ),
                          );
                        },
                        status: booking.status ?? 'unknown',
                        bookingName: booking.bookingRef ?? 'N/A',
                        subcontractorName:
                            booking.subcontractor?.companyName ?? '—',
                        binName: _binLabel(booking),
                      );
                    },
                  );
                }),
              ),
            ],
          ),

          // ── Lottie loading overlay ──────────────────────────
          Obx(
            () => LottieOverlay(
              visible: dataController.isLoading.value,
              message: 'Loading bookings…',
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.buttonColor],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            controller.resetForm();
            Get.to(() => CreateBookingView());
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            'New Booking',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  String _binLabel(dynamic booking) {
    final items = booking.items;
    if (items == null || items.isEmpty) return '—';
    if (items.length == 1) return items.first.bin?.serialNumber ?? '—';
    return '${items.length} Bins';
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    Get.offAll(() => LoginScreen());
  }
}
