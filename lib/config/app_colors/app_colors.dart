// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class AppColors {
  static Color primary_color = const Color(0xff00e038);
  static Color primaryColorWithLowOpacity = const Color(
    0x00e038,
  ).withOpacity(0.1);
  static Color homeBG = const Color(0xFFe9eaec);
  static Color secondary_color = const Color(0xFF042628);
  static Color lightBlue = Colors.lightBlue;
  static Color white = const Color(0xFFFDFDFD);
  static Color grey = Colors.grey;
  static Color black = Colors.black;
  static Color transparent = Colors.transparent;
  static Color greyWithLowOpacity = Colors.grey.shade200;
  static Color grey300 = Colors.grey.shade300;
  static Color grey100 = Colors.grey.shade100;
  static Color bodyColor = const Color(0xfffdfdfd);
  static Color bg_color = const Color(0xFFf1f4fd);
  static Color text_secondary_color = const Color(0xFF414042);
  static const drawerTileColor = Color(0xffe9f5fe);

  static Color fieldBgColor = Color.fromARGB(51, 196, 196, 196);
  // static Color fieldBgColor = Color(0xffF5F5F5);
  static Color skyBlue = Colors.lightBlue.withValues(alpha: .2);
  static Color detailPageBgColor = Color(0xfffbeee3);

  static const profileTileBgColor = Color(0xffF5F5F5);
  static const searchScreenBg = Color(0xfff1f1f1);
  static const greyTextColor = Color(0xff797979);
  static const lightGreen = Color(0xff61E290);
  static const appRed = Color(0xffFF4448);
  static const Color primary = Color(0xFF1A1A2E);
  static const Color accent = Color(0xFFDC131B);
  // static const Color accent = Color(0xFF4F46E5);
  static const Color accentLight = Color(0xFFEEF2FF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textHint = Color(0xFFADB5BD);
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderFocus = Color(0xFF4F46E5);
  static const Color error = Color(0xFFEF4444);
  static const Color background = Color(0xFFF8FAFC);
  static const Color divider = Color(0xFFE2E8F0);
  static const Color loginBg = Color(0xFF18181B);
  static const Color buttonColor = Color(0xFFDC131B);
}

class AppTextStyles {
  static const TextStyle displayLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.2,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );
  static const TextStyle labelSmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.1,
  );
  static const TextStyle labelAccent = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.accent,
    letterSpacing: 0.1,
  );
  static const TextStyle buttonLabel = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    color: AppColors.surface,
  );
}
