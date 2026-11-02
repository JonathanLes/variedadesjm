import 'package:flutter/material.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/themes/spacing.dart';
import 'package:variedadesjm/shared/widgets/ui/shoe_image.dart';
import 'inventario_status_badge.dart';

class InventarioItemTile extends StatelessWidget {
  final String sku;
  final String modelo;
  final String? imagenPath;
  final String tallaCm;
  final EstadoInventario estado;
  final VoidCallback onTap;

  const InventarioItemTile({
    super.key,
    required this.sku,
    required this.modelo,
    this.imagenPath,
    required this.tallaCm,
    required this.estado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: context.muted.withValues(alpha: 0.2))),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              child: SizedBox(
                width: 50,
                height: 50,
                child: ShoeImage(path: imagenPath, iconSize: 24),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(sku, style: TextStyle(fontSize: 12, color: context.muted)),
                  Text(modelo, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(tallaCm, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                InventarioStatusBadge(estado: estado),
              ],
            ),
            const SizedBox(width: AppSpacing.sm),
            Icon(Icons.chevron_right, color: context.muted),
          ],
        ),
      ),
    );
  }
}