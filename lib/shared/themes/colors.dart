import 'package:flutter/material.dart';

/// Define las paletas visuales disponibles y las utilidades de color
/// compartidas por todas las pantallas de Variedades JM.
class AppColors {
  AppColors._();

  /// Negro y vino: una paleta de alto contraste para la operación diaria.
  static const AppPalette vino = AppPalette(
    primary: Color(0xFF702632),
    accent: Color(0xFF912F40),
    background: Color(0xFFFFFFFA),
    surface: Color(0xFFFFFFFF),
    text: Color(0xFF080705),
    muted: Color(0xFF40434E),
  );

  /// Acero y arena: una alternativa neutra y sobria.
  static const AppPalette acero = AppPalette(
    primary: Color(0xFF4C5760),
    accent: Color(0xFF93A8AC),
    background: Color(0xFFF7F5EF),
    surface: Color(0xFFFFFFFF),
    text: Color(0xFF2F3030),
    muted: Color(0xFF66635B),
  );

  /// Cobre y café: una alternativa cálida para el panel administrativo.
  static const AppPalette cobre = AppPalette(
    primary: Color(0xFF6F1A07),
    accent: Color(0xFFA8763E),
    background: Color(0xFFF7F3E3),
    surface: Color(0xFFFFFFFF),
    text: Color(0xFF2B2118),
    muted: Color(0xFF6F6258),
  );

  /// Catálogo ordenado usado por la configuración y los selectores.
  static const List<AppPalette> all = [vino, acero, cobre];

  /// Conserva compatibilidad con widgets existentes.
  static const Color black = Color(0xFF080705);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF66635B);
  static const Color graphite = Color(0xFF40434E);
  static const Color deepCrimson = Color(0xFF702632);
  static const Color racingRed = Color(0xFF912F40);

  /// Compara texto ignorando mayúsculas, espacios y acentos.
  static String normalize(String value) {
    const replacements = <String, String>{
      'á': 'a', 'é': 'e', 'í': 'i', 'ó': 'o', 'ú': 'u', 'ü': 'u', 'ñ': 'n',
    };
    var result = value.trim().toLowerCase();
    replacements.forEach((from, to) => result = result.replaceAll(from, to));
    return result;
  }
}

/// Colores semánticos de una paleta, separados de los widgets que los usan.
class AppPalette {
  final Color primary;
  final Color accent;
  final Color background;
  final Color surface;
  final Color text;
  final Color muted;

  const AppPalette({
    required this.primary,
    required this.accent,
    required this.background,
    required this.surface,
    required this.text,
    required this.muted,
  });
}
