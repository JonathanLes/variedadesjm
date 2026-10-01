import 'package:flutter/material.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/themes/spacing.dart';

class InventarioEmptyState extends StatelessWidget {
  final VoidCallback onActionPressed;

  const InventarioEmptyState({super.key, required this.onActionPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 80, color: AppColors.grey.withOpacity(0.5)),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'No se encontraron resultados',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Intenta cambiar los filtros o registra un nuevo par en el inventario.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.grey),
          ),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton.icon(
            onPressed: onActionPressed,
            icon: const Icon(Icons.add),
            label: const Text('Registrar Nuevo Par'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.racingRed,
              foregroundColor: AppColors.white,
            ),
          )
        ],
      ),
    );
  }
}