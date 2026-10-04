import 'package:flutter/material.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/themes/spacing.dart';

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

  /// Construye una tarjeta individual de resumen estadístico.
  Widget _buildCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(color: AppColors.grey.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 11, color: AppColors.grey),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        side: BorderSide(color: AppColors.grey.withOpacity(0.2)),
      ),
      child: ExpansionTile(
        initiallyExpanded: false,
        tilePadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        childrenPadding: const EdgeInsets.fromLTRB(
          AppSpacing.sm,
          0,
          AppSpacing.sm,
          AppSpacing.sm,
        ),
        leading: const Icon(Icons.inventory_2, color: AppColors.racingRed),
        title: const Text(
          'Inventario total',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('$totalPares pares registrados'),
        children: [
          Row(
            children: [
              _buildCard(
                'Total de Pares',
                totalPares.toString(),
                Icons.inventory_2,
                AppColors.racingRed,
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildCard(
                'Pares Activos',
                paresActivos.toString(),
                Icons.check_circle,
                Colors.green,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              _buildCard(
                'Reservados',
                paresReservados.toString(),
                Icons.watch_later,
                Colors.orange,
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildCard(
                'Valor Total',
                '\$${valorTotal.toStringAsFixed(2)}',
                Icons.attach_money,
                AppColors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
