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

  /// Azul marino: la identidad del rediseño. Es la paleta por defecto.
  static const AppPalette marino = AppPalette(
    primary: Color(0xFF13315C),
    accent: Color(0xFF3A6EA5),
    background: Color(0xFFF4F6FA),
    surface: Color(0xFFFFFFFF),
    text: Color(0xFF1B2A41),
    muted: Color(0xFF66758B),
  );

  /// Catálogo ordenado usado por la configuración y los selectores.
  /// `marino` va al final para no alterar el índice de las preferencias ya guardadas.
  static const List<AppPalette> all = [vino, acero, cobre, marino];

  /// Colores semánticos compartidos por todas las paletas:
  /// verde = ventas y ganancias, ámbar = reservas y saldos, rojo = gastos y avisos.
  static const Color success = Color(0xFF1E9E6A);
  static const Color warning = Color(0xFFE08A00);
  static const Color danger = Color(0xFFC8412F);

  /// Colores base que usan los widgets de módulos anteriores al rediseño.
  /// `brand` es el azul marino de la marca; antes eran tonos vino.
  static const Color brand = Color(0xFF13315C);
  static const Color black = Color(0xFF1B2A41);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF66758B);
  static const Color graphite = Color(0xFF4A5A73);

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
