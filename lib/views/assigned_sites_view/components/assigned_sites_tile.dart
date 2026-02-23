import 'package:bin_management_system/config/app_colors/app_colors.dart';
import 'package:bin_management_system/core/utils/app_text/app_text.dart';
import 'package:bin_management_system/models/login_model.dart';
import 'package:flutter/material.dart';

class SiteTile extends StatefulWidget {
  const SiteTile({
    super.key,
    required this.assignedSite,
    required this.animationIndex,
    this.onTap,
  });

  final AssignedSites assignedSite;
  final int animationIndex;
  final VoidCallback? onTap;

  @override
  State<SiteTile> createState() => _SiteTileState();
}

class _SiteTileState extends State<SiteTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    // Stagger each tile by 80ms based on its list index
    Future.delayed(
      Duration(milliseconds: 80 * widget.animationIndex),
      () {
        if (mounted) _ctrl.forward();
      },
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final site = widget.assignedSite.site;
    final bool isActive =
        (site?.status ?? '').toUpperCase() == 'ACTIVE';

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFDDE3EC),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Row 1: Icon + Name + Status badge ──────────────────
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.location_city_rounded,
                          color: AppColors.primary,
                          size: 21,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppText(
                          title: site?.name ?? '—',
                          size: 15,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1D23),
                        ),
                      ),
                      // Status chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFFE6F9F0)
                              : const Color(0xFFFFF0F0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          site?.status ?? '—',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isActive
                                ? const Color(0xFF27AE60)
                                : const Color(0xFFE53935),
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  const Divider(height: 1, color: Color(0xFFF0F0F0)),
                  const SizedBox(height: 12),

                  // ── Row 2: Address ──────────────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 15,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: AppText(
                          title: site?.address ?? '—',
                          size: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // ── Row 3: Site ID ──────────────────────────────────────
                  Row(
                    children: [
                      Icon(
                        Icons.tag_rounded,
                        size: 14,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(width: 5),
                      AppText(
                        title: 'Site ID: ${site?.id ?? '—'}',
                        size: 12,
                        color: Colors.grey.shade500,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}