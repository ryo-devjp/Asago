import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// アプリ全体で使用するカラー定数。
const primaryBlue = Color(0xFF0055D4);
const accentOrange = Color(0xFFFF6F00);

/// 指定された [brightness] に応じた [ThemeData] を構築する。
///
/// ライト/ダーク両対応。フォントは BIZ UDGothic で統一。
ThemeData buildAppTheme(Brightness brightness) {
  final isLight = brightness == Brightness.light;

  final colorScheme = ColorScheme.fromSeed(
    seedColor: primaryBlue,
    brightness: brightness,
    primary: primaryBlue,
    secondary: accentOrange,
    surface: isLight ? Colors.white : const Color(0xFF1C1C1E),
    surfaceContainerHighest: isLight
        ? const Color(0xFFF2F3F7)
        : const Color(0xFF2C2C2E),
  );

  final baseText = isLight
      ? GoogleFonts.bizUDGothicTextTheme(ThemeData.light().textTheme)
      : GoogleFonts.bizUDGothicTextTheme(ThemeData.dark().textTheme);

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    textTheme: baseText,
    scaffoldBackgroundColor: isLight
        ? const Color(0xFFF2F3F7)
        : const Color(0xFF121212),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.bizUDGothic(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: isLight ? Colors.black : Colors.white,
      ),
      iconTheme: IconThemeData(color: isLight ? Colors.black87 : Colors.white),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: colorScheme.surface,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      indicatorColor: primaryBlue.withAlpha(30),
      labelTextStyle: WidgetStatePropertyAll(
        GoogleFonts.bizUDGothic(fontSize: 12, fontWeight: FontWeight.w500),
      ),
      height: 64,
    ),
    dividerTheme: const DividerThemeData(space: 0, thickness: 0.5),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: GoogleFonts.bizUDGothic(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
