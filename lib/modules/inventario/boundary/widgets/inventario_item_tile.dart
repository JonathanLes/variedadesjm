import 'dart:io';

import 'package:flutter/material.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/themes/spacing.dart';
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
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: context.muted.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: imagenPath == null
                  ? Icon(Icons.image_not_supported, color: context.muted)
                  : Image.file(
                      File(imagenPath!),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.image_not_supported,
                        color: context.muted,
                      ),
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