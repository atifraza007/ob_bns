import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  const AppText({
    super.key,
    this.title = "Savyator",
    this.color,
    this.decoration = TextDecoration.none,
    this.size,
    this.fontWeight,
    this.fontFamily = "urbanist",
    this.textAlign,
    this.height,
    this.letterSpacing,
    this.maxLines,
    this.overFlow,
    this.fontStyle,
    this.softWrap,
    this.textWidthBasis,
    this.decorationStyle,
  });

  final Color? color;
  final TextOverflow? overFlow;
  final String title;
  final double? size;
  final double? height;
  final FontWeight? fontWeight;
  final TextDecoration decoration;
  final FontStyle? fontStyle;
  final String? fontFamily;
  final TextAlign? textAlign;
  final double? letterSpacing;
  final int? maxLines;
  final bool? softWrap;
  final TextWidthBasis? textWidthBasis;
  final TextDecorationStyle? decorationStyle;

  TextStyle _googleFontStyle() {
    // IMPORTANT: leave `color` nullable so it can inherit from DefaultTextStyle (e.g., TabBar)
    final baseStyle = TextStyle(
      color: color, // null → inherits selected/unselected color
      fontSize: size,
      height: height,
      fontStyle: fontStyle,
      fontWeight: fontWeight,
      decoration: decoration,
      decorationColor: color, // null → inherits
      letterSpacing: letterSpacing,
      decorationStyle: decorationStyle,
    );

    switch (fontFamily?.toLowerCase()) {
      case "poppins":
        return GoogleFonts.poppins(textStyle: baseStyle);
      case "mulish":
        return GoogleFonts.mulish(textStyle: baseStyle);
      case "roboto":
        return GoogleFonts.roboto(textStyle: baseStyle);
      case "inter": // fixed casing to match toLowerCase()
        return GoogleFonts.inter(textStyle: baseStyle);
      case "urbanist":
        return GoogleFonts.urbanist(textStyle: baseStyle);
      default:
        return GoogleFonts.mulish(textStyle: baseStyle);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Do NOT force a color if not provided; let parents (like TabBar) style it.
    final style = _googleFontStyle();

    return Text(
      title,
      style: style,
      softWrap: softWrap,
      overflow: overFlow,
      textAlign: textAlign,
      maxLines: maxLines,
      textWidthBasis: textWidthBasis,
    );
  }
}
