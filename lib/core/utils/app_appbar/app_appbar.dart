import 'package:bin_management_system/config/app_colors/app_colors.dart';
import 'package:bin_management_system/core/utils/app_text/app_text.dart';
import 'package:flutter/material.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showLogo;
  final bool showBack;

  const AppAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showLogo = false,
    this.showBack = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.loginBg,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showLogo) ...[
            Image.asset(
              'assets/icons/main_logo.png',
              height: 60,
              width: 60,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 10),
          ],
          AppText(
            title: title,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
      actions: actions,
    );
  }
}