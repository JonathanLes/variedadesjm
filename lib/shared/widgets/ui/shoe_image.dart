import 'dart:io';

import 'package:flutter/material.dart';

/// Foto de un zapato con un recuadro de respaldo cuando no existe o no se puede leer.
class ShoeImage extends StatelessWidget {
  final String? path;
  final BoxFit fit;
  final double iconSize;
  final IconData icon;

  const ShoeImage({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
    this.iconSize = 34,
    this.icon = Icons.image_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fallback = Center(
      child: Icon(icon, size: iconSize, color: scheme.primary.withValues(alpha: .6)),
    );
    final value = path;
    return Container(
      color: scheme.primary.withValues(alpha: .08),
      width: double.infinity,
      height: double.infinity,
      child: value == null || value.isEmpty
          ? fallback
          // El tamaño de decodificación sigue al del recuadro: una foto de 1600 px
          // mostrada en una tarjeta pequeña no necesita ocupar toda esa memoria.
          : LayoutBuilder(
              builder: (context, constraints) {
                final ancho = constraints.maxWidth.isFinite ? constraints.maxWidth : 400.0;
                final px = (ancho * MediaQuery.devicePixelRatioOf(context))
                    .round()
                    .clamp(120, 1600);
                return Image.file(
                  File(value),
                  fit: fit,
                  cacheWidth: px,
                  errorBuilder: (_, __, ___) => fallback,
                );
              },
            ),
    );
  }
}
