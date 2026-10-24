import 'package:flutter/material.dart';
import 'package:variedadesjm/shared/utils/format.dart';
import 'package:variedadesjm/shared/widgets/ui/shoe_image.dart';
import 'inventario_status_badge.dart';

/// Tarjeta de un par para la cuadrícula del inventario. Toda ella es pulsable.
class InventarioItemCard extends StatelessWidget {
  final String sku;
  final String modelo;
  final String? imagenPath;
  final String detalle;
  final double precio;
  final EstadoInventario estado;
  final VoidCallback onTap;

  const InventarioItemCard({
    super.key,
    required this.sku,
    required this.modelo,
    required this.imagenPath,
    required this.detalle,
    required this.precio,
    required this.estado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
                  child: ShoeImage(path: imagenPath, icon: Icons.inventory_2_outlined),
                ),
              ),
              const SizedBox(height: 8),
              Text(modelo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
              Text(detalle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11.5)),
              Text(sku,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10.5)),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(money(precio),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                  const Spacer(),
                  InventarioStatusBadge(estado: estado),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
