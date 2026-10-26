import 'package:flutter/material.dart';
import 'colors.dart';

/// Construye el tema Material de la aplicación a partir de una paleta.
class AppTheme {
  AppTheme._();

  /// Genera un tema consistente para botones, tarjetas, formularios y textos.
  static ThemeData fromPalette(AppPalette base, ThemeMode mode) {
    final palette = mode == ThemeMode.dark ? _darkVariant(base) : base;
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
    final border = palette.muted.withValues(alpha: .22);
    const pill = StadiumBorder();
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: palette.background,
      fontFamily: 'Roboto',
      // Barra superior clara con texto de marca, como en los mockups.
      appBarTheme: AppBarTheme(
        backgroundColor: palette.surface,
        foregroundColor: palette.primary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        shape: Border(bottom: BorderSide(color: border)),
        iconTheme: IconThemeData(color: palette.primary),
        titleTextStyle: TextStyle(
          color: palette.primary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: palette.primary, width: 1.6),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.danger),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.danger, width: 1.6),
        ),
      ),
      cardTheme: CardThemeData(
        color: palette.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: border),
        ),
      ),
      // Botones de acción redondeados y con área táctil cómoda (48 px).
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          backgroundColor: palette.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: pill,
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          backgroundColor: palette.primary,
          foregroundColor: Colors.white,
          shape: pill,
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          foregroundColor: palette.primary,
          side: BorderSide(color: palette.primary, width: 1.2),
          shape: pill,
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: palette.surface,
        selectedColor: palette.primary,
        side: BorderSide(color: border),
        shape: pill,
        labelStyle: TextStyle(
          color: palette.muted,
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
        ),
        secondaryLabelStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
        ),
        checkmarkColor: Colors.white,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: palette.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: const CircleBorder(),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: palette.muted.withValues(alpha: .16),
        thickness: 1,
      ),
    );
  }

  /// Versión oscura de una paleta: fondos casi negros teñidos con el color de
  /// marca y un tono de marca más claro para que se lea sobre fondo oscuro.
  static AppPalette _darkVariant(AppPalette p) {
    final hsl = HSLColor.fromColor(p.primary);
    final primary = hsl
        .withLightness(0.58)
        .withSaturation(hsl.saturation.clamp(0.0, 0.6).toDouble())
        .toColor();
    final tintSource = HSLColor.fromColor(p.primary).withSaturation(0.35);
    Color tinted(double lightness) =>
        tintSource.withLightness(lightness).toColor();
    return AppPalette(
      primary: primary,
      accent: HSLColor.fromColor(p.accent).withLightness(0.66).toColor(),
      background: tinted(0.07),
      surface: tinted(0.12),
      text: const Color(0xFFE8ECF3),
      muted: const Color(0xFFA7B1C2),
    );
  }
}
