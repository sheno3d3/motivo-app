// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Brand primaries
  static const Color orange = Color(0xFFFF6B35);
  static const Color orangeDark = Color(0xFFD94F1E);
  static const Color gold = Color(0xFFF5C842);
  static const Color goldDark = Color(0xFFC8960A);

  // Backgrounds
  static const Color navy = Color(0xFF04090F);
  static const Color navy2 = Color(0xFF070F1C);
  static const Color navy3 = Color(0xFF0C1928);

  // Semantic
  static const Color green = Color(0xFF00C896);
  static const Color blue = Color(0xFF2F78FF);
  static const Color rose = Color(0xFFFF3D6E);
  static const Color cyan = Color(0xFF00C4D4);

  // Glass surfaces
  static const Color glass1 = Color(0x0BFFFFFF);  // 4.2%
  static const Color glass2 = Color(0x14FFFFFF);  // 7.8%
  static const Color glass3 = Color(0x1FFFFFFF);  // 12%

  // Borders
  static const Color border1 = Color(0x12FFFFFF);  // 7%
  static const Color border2 = Color(0x21FFFFFF);  // 13%
  static const Color border3 = Color(0x33FFFFFF);  // 20%

  // Text
  static const Color text1 = Color(0xFFF8F6F0);
  static const Color text2 = Color(0x94F8F6F0);  // 58%
  static const Color text3 = Color(0x52F8F6F0);  // 32%

  // Gradients
  static const LinearGradient orangeGrad = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [orange, orangeDark],
  );

  static const LinearGradient goldGrad = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gold, goldDark],
  );

  static const LinearGradient ringGrad = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [orange, Color(0xFFF5C842), Color(0xFFFFD166)],
  );
}

class AppTextStyles {
  // Playfair Display — display/headings
  static TextStyle display({double size = 44, FontWeight weight = FontWeight.w900, Color color = AppColors.text1}) =>
    TextStyle(
      fontFamily: 'PlayfairDisplay',
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: size > 30 ? -2.0 : -0.3,
      height: 1.1,
    );

  // Inter — body/UI
  static TextStyle body({double size = 13, FontWeight weight = FontWeight.w400, Color color = AppColors.text2}) =>
    GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: 0.01,
      height: 1.65,
    );

  static TextStyle label({double size = 9.5, Color color = AppColors.text3}) =>
    GoogleFonts.inter(
      fontSize: size,
      fontWeight: FontWeight.w600,
      color: color,
      letterSpacing: 0.11,
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
    textTheme: TextTheme(
      displayLarge: AppTextStyles.display(size: 44),
      titleLarge: AppTextStyles.display(size: 22, weight: FontWeight.w700),
      bodyMedium: AppTextStyles.body(),
      labelSmall: AppTextStyles.label(),
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
