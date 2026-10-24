import 'package:flutter/material.dart';
import 'package:variedadesjm/shared/widgets/ui/shoe_image.dart';

/// Tarjeta de un modelo del catálogo: foto grande, nombre, marca y categoría.
class ZapatoItemCard extends StatelessWidget {
  final String nombre;
  final String marca;
  final String categoria;
  final String? imagenPath;
  final VoidCallback onTap;

  const ZapatoItemCard({
    super.key,
    required this.nombre,
    required this.marca,
    required this.categoria,
    this.imagenPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ShoeImage(path: imagenPath, iconSize: 40),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                nombre,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
              ),
              const SizedBox(height: 2),
              Text(
                '$marca • $categoria',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: muted, fontSize: 11.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
