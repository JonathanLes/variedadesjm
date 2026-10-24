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
          : Image.file(
              File(value),
              fit: fit,
              errorBuilder: (_, __, ___) => fallback,
            ),
    );
  }
}
