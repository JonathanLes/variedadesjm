import 'package:flutter/material.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/utils/format.dart';

/// Tres mosaicos con el estado del stock y el valor del inventario a costo.
class InventarioSummaryCards extends StatelessWidget {
  final int totalPares;
  final int paresActivos;
  final int paresReservados;
  final double valorTotal;

  const InventarioSummaryCards({
    super.key,
    required this.totalPares,
    required this.paresActivos,
    required this.paresReservados,
    required this.valorTotal,
  });

  Widget _tile(BuildContext context, String value, String label, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color)),
              Text(label, style: const TextStyle(fontSize: 11.5)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Row(
          children: [
            _tile(context, '$totalPares', 'Registrados', scheme.primary),
            const SizedBox(width: 8),
            _tile(context, '$paresActivos', 'Disponibles', AppColors.success),
            const SizedBox(width: 8),
            _tile(context, '$paresReservados', 'Reservados', AppColors.warning),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
          child: Row(
            children: [
              const Expanded(child: Text('Valor del inventario (a costo)')),
              Text(money(valorTotal), style: const TextStyle(fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ],
    );
  }
}
