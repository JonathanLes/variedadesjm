import 'package:flutter/material.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/themes/spacing.dart';

class ZapatoEmptyState extends StatelessWidget {
  final VoidCallback onActionPressed;

  const ZapatoEmptyState({super.key, required this.onActionPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.style_outlined, size: 80, color: AppColors.grey.withOpacity(0.5)),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Catálogo vacío',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'No hay modelos de zapatos registrados. Agrega el primer modelo para empezar a gestionar tu inventario.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.grey),
          ),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton.icon(
            onPressed: onActionPressed,
            icon: const Icon(Icons.add),
            label: const Text('Registrar Modelo'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brand,
              foregroundColor: AppColors.white,
            ),
          )
        ],
      ),
    );
  }
}