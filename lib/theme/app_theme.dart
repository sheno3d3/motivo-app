// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color orange     = Color(0xFFFF6B35);
  static const Color orangeDark = Color(0xFFD94F1E);
  static const Color gold       = Color(0xFFF5C842);
  static const Color goldDark   = Color(0xFFC8960A);
  static const Color navy       = Color(0xFF04090F);
  static const Color navy2      = Color(0xFF070F1C);
  static const Color navy3      = Color(0xFF0C1928);
  static const Color green      = Color(0xFF00C896);
  static const Color blue       = Color(0xFF2F78FF);
  static const Color rose       = Color(0xFFFF3D6E);
  static const Color cyan       = Color(0xFF00C4D4);
  static const Color glass1     = Color(0x0BFFFFFF);
  static const Color glass2     = Color(0x14FFFFFF);
  static const Color glass3     = Color(0x1FFFFFFF);
  static const Color border1    = Color(0x12FFFFFF);
  static const Color border2    = Color(0x21FFFFFF);
  static const Color border3    = Color(0x33FFFFFF);
  static const Color text1      = Color(0xFFF8F6F0);
  static const Color text2      = Color(0x94F8F6F0);
  static const Color text3      = Color(0x52F8F6F0);

  static const LinearGradient orangeGrad = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [orange, orangeDark],
  );
  static const LinearGradient goldGrad = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [gold, goldDark],
  );
}

class AppTextStyles {
  // Playfair Display for all display/heading text
  static TextStyle display({
    double size = 44,
    FontWeight weight = FontWeight.w900,
    Color color = AppColors.text1,
  }) =>
      GoogleFonts.playfairDisplay(
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: size > 30 ? -2.0 : -0.3,
        height: 1.1,
      );

  // Inter for all body/UI text
  static TextStyle body({
    double size = 13,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.text2,
  }) =>
      GoogleFonts.inter(
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: 0.01,
        height: 1.65,
      );

  static TextStyle label({Color color = AppColors.text3}) =>
      GoogleFonts.inter(
        fontSize: 9.5,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 0.11,
        height: 1,
      );

  static TextStyle button({double size = 13.5}) =>
      GoogleFonts.inter(
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        letterSpacing: 0.02,
        height: 1,
      );
}

class AppTheme {
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.navy,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.orange,
          secondary: AppColors.gold,
          surface: AppColors.navy2,
          error: AppColors.rose,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      );
}
