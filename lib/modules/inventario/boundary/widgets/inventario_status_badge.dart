import 'package:flutter/material.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/themes/spacing.dart';

enum EstadoInventario { activo, reservado, vendido }

class InventarioStatusBadge extends StatelessWidget {
  final EstadoInventario estado;

  const InventarioStatusBadge({super.key, required this.estado});

  /// Determina el color principal del badge según el estado actual.
  Color _getColor() {
    switch (estado) {
      case EstadoInventario.activo:
        return Colors.green;
      case EstadoInventario.reservado:
        return Colors.orange;
      case EstadoInventario.vendido:
        return AppColors.grey;
    }
  }

  /// Devuelve el texto formateado correspondiente al estado.
  String _getText() {
    switch (estado) {
      case EstadoInventario.activo:
        return 'Activo';
      case EstadoInventario.reservado:
        return 'Reservado';
      case EstadoInventario.vendido:
        return 'Vendido';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 4, backgroundColor: color),
          const SizedBox(width: AppSpacing.xs),
          Text(
            _getText(),
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}