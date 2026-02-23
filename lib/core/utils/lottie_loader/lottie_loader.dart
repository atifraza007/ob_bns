import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class LottieOverlay extends StatelessWidget {
  final bool visible;
  final String lottiePath;
  final String? message;
  final double lottieSize;
  final double blurSigma;
  final double overlayOpacity;

  const LottieOverlay({
    super.key,
    required this.visible,
    this.lottiePath = 'assets/lottie/Delete Bin.json',
    this.message,
    this.lottieSize = 160,
    this.blurSigma = 10,
    this.overlayOpacity = 0.6,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          color: Colors.white.withOpacity(overlayOpacity),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  lottiePath,
                  width: lottieSize,
                  height: lottieSize,
                  fit: BoxFit.contain,
                ),
                if (message != null) ...[
                  const SizedBox(height: 0),
                  Text(
                    message!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.urbanist(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1410),
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
