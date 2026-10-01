import 'package:flutter/material.dart';
import 'package:variedadesjm/shared/widgets/pagination/app_back_button.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/themes/spacing.dart';

class ZapatoDetailPage extends StatelessWidget {
  const ZapatoDetailPage({super.key});

  /// Ejecuta la eliminación lógica del modelo de zapato del catálogo.
  void _eliminarModelo(BuildContext context) {
    // TODO: Confirmar eliminación y validar dependencias en inventario
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: AppBackButton(iconColor: AppColors.white),
        ),
        title: const Text('Detalle del Modelo', style: TextStyle(color: AppColors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.racingRed),
            onPressed: () => _eliminarModelo(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: AppColors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: const Center(child: Icon(Icons.image, size: 120, color: AppColors.grey)),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text(
            'Air Max Runner',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            'Nike • Deportivo',
            style: TextStyle(fontSize: 16, color: AppColors.grey),
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Descripción',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            'Modelo deportivo de alta resistencia ideal para correr en asfalto. Cuenta con cámara de aire para mayor amortiguación.',
            style: TextStyle(color: AppColors.graphite, height: 1.5),
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit, color: AppColors.graphite),
              label: const Text('Editar Modelo', style: TextStyle(color: AppColors.graphite)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}