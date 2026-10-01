import 'package:flutter/material.dart';
import 'package:variedadesjm/shared/widgets/pagination/app_back_button.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/themes/spacing.dart';

import '../widgets/inventario_info_banner.dart';

class InventarioFormPage extends StatelessWidget {
  const InventarioFormPage({super.key});

  /// Ejecuta las validaciones del formulario e invoca la creación del inventario.
  void _guardarInventario(BuildContext context) {
    // TODO: Validar form y llamar a Riverpod
    Navigator.pop(context);
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
        title: const Text('Registrar Nuevo Par', style: TextStyle(color: AppColors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const InventarioInfoBanner(
              text: "El código de inventario (SKU) se generará automáticamente con la fecha y costo de compra, y el estado inicial será 'Activo'.",
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text('Modelo de zapato *', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.xs),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: const [],
              onChanged: (val) {},
              hint: const Text('Selecciona un modelo'),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Talla *', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: AppSpacing.xs),
                      TextFormField(decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Ej. 9')),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Medida en CM *', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: AppSpacing.xs),
                      TextFormField(decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Ej. 27.5')),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const Text('Precio de compra *', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.xs),
            TextFormField(
              decoration: const InputDecoration(border: OutlineInputBorder(), prefixText: '\$ '),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _guardarInventario(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.racingRed,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Registrar Inventario'),
              ),
            )
          ],
        ),
      ),
    );
  }
}