import 'package:flutter/material.dart';
import 'package:variedadesjm/shared/widgets/ui/status_chip.dart';

enum EstadoInventario { activo, reservado, vendido }

/// Etiqueta de estado de un par: Disponible, Reservado o Vendido.
class InventarioStatusBadge extends StatelessWidget {
  final EstadoInventario estado;

  const InventarioStatusBadge({super.key, required this.estado});

  @override
  Widget build(BuildContext context) {
    switch (estado) {
      case EstadoInventario.activo:
        return const StatusChip(label: 'Disponible', tone: StatusTone.success);
      case EstadoInventario.reservado:
        return const StatusChip(label: 'Reservado', tone: StatusTone.warning);
      case EstadoInventario.vendido:
        return const StatusChip(label: 'Vendido', tone: StatusTone.neutral);
    }
  }
}
