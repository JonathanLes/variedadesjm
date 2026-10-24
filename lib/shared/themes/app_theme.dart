import 'package:flutter/material.dart';
import 'colors.dart';

/// Construye el tema Material de la aplicación a partir de una paleta.
class AppTheme {
  AppTheme._();

  /// Genera un tema consistente para botones, tarjetas, formularios y textos.
  static ThemeData fromPalette(AppPalette palette, ThemeMode mode) {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: palette.primary,
          brightness: mode == ThemeMode.dark
              ? Brightness.dark
              : Brightness.light,
        ).copyWith(
          primary: palette.primary,
          secondary: palette.accent,
          surface: palette.surface,
        );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: palette.background,
      fontFamily: 'Roboto',
      appBarTheme: AppBarTheme(
        backgroundColor: palette.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        filled: true,
        fillColor: palette.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
      ),
      cardTheme: CardThemeData(
        color: palette.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(44),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: palette.muted.withValues(alpha: .16),
        thickness: 1,
      ),
    );
  }
}
