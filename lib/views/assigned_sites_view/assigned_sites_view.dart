import 'package:bin_management_system/config/app_colors/app_colors.dart';
import 'package:bin_management_system/core/controllers/auth_controller/auth_controller.dart';
import 'package:bin_management_system/core/controllers/data_controller/data_controller.dart';
import 'package:bin_management_system/core/utils/app_appbar/app_appbar.dart';
import 'package:bin_management_system/core/utils/app_text/app_text.dart';
import 'package:bin_management_system/core/utils/lottie_loader/lottie_loader.dart';
import 'package:bin_management_system/views/assigned_sites_view/components/assigned_sites_tile.dart';
import 'package:bin_management_system/views/assigned_sites_view/controller/assigned_sites_controller.dart';
import 'package:bin_management_system/views/auth_views/login_view/login_view.dart';
import 'package:bin_management_system/views/home_view/components/logout_dialog.dart';
import 'package:bin_management_system/views/home_view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssignedSitesView extends StatefulWidget {
  const AssignedSitesView({super.key});

  @override
  State<AssignedSitesView> createState() => _AssignedSitesViewState();
}

class _AssignedSitesViewState extends State<AssignedSitesView>
    with SingleTickerProviderStateMixin {
  final AssignedSitesController controller = Get.put(AssignedSitesController());
  final AuthController authController = Get.put(AuthController());
  final DataController dataController = Get.put(DataController());

  // Count-bar slides down from appbar on entry
  late final AnimationController _headerCtrl;
  late final Animation<double> _headerFade;
  late final Animation<Offset> _headerSlide;

  @override
  void initState() {
    super.initState();

    // If loginModel has no sites yet (app restarted), load from local storage.
    // checkTokenOnStart() already calls loadAssignedSitesFromLocal(), but this
    // is a safety net in case AssignedSitesView is reached before that resolves.
    final hasSites =
        (authController.loginModel.value.user?.assignedSites ?? []).isNotEmpty;
    if (!hasSites) {
      controller.isLoading.value = true;
      authController.loadAssignedSitesFromLocal().then((_) {
        controller.isLoading.value = false;
      });
    }

    // Header animation
    _headerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _headerFade = CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut);

    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOutCubic));

    _headerCtrl.forward();
  }

  @override
  void dispose() {
    _headerCtrl.dispose();
    super.dispose();
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    // Clear token but keep assignedSites so they survive next cold start
    // if needed. Remove the line below to also wipe sites on logout.
    prefs.remove('token');
    Get.offAll(() => LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppAppBar(
        title: 'Assigned Sites',
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
          // ── Main content ─────────────────────────────────────────────────
          Obx(() {
            // Single Obx that reacts to loginModel changes (after local load)
            // AND isLoading changes. Both are valid Rx reads ✓
            final isLoading = controller.isLoading.value;
            final sites =
                authController.loginModel.value.user?.assignedSites ?? [];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Animated count bar ─────────────────────────────────
                FadeTransition(
                  opacity: _headerFade,
                  child: SlideTransition(
                    position: _headerSlide,
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.domain_rounded,
                            size: 15,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 6),
                          AppText(
                            title:
                                '${sites.length} ${sites.length == 1 ? 'Site' : 'Sites'} Assigned',
                            size: 13,
                            color: Colors.grey.shade600,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFE0E0E0)),

                // ── List ───────────────────────────────────────────────
                Expanded(
                  child: isLoading
                      ? const SizedBox.shrink()
                      : sites.isEmpty
                      ? const _EmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.only(top: 8, bottom: 24),
                          itemCount: sites.length,
                          itemBuilder: (context, index) {
                            return SiteTile(
                              assignedSite: sites[index],
                              animationIndex: index,
                              onTap: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                  "siteId",
                                  sites[index].id.toString(),
                                );
                                dataController.fetchAllBookings(
                                  siteId: sites[index].id.toString(),
                                );
                                dataController.fetchAvailableBins(
                                  siteId: sites[index].id.toString(),
                                );
                                Get.to(() => HomeView());
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          }),

          // ── Lottie loading overlay ───────────────────────────────────────
          Obx(
            () => LottieOverlay(
              visible: controller.isLoading.value,
              message: 'Loading sites…',
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state — scale + fade entrance
// ─────────────────────────────────────────────────────────────────────────────
class _EmptyState extends StatefulWidget {
  const _EmptyState();

  @override
  State<_EmptyState> createState() => _EmptyStateState();
}

class _EmptyStateState extends State<_EmptyState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();

    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _scale = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_off_outlined,
                size: 52,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 12),
              AppText(
                title: 'No sites assigned',
                color: Colors.grey.shade500,
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
