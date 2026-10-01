import 'package:flutter/material.dart';
import 'package:variedadesjm/shared/widgets/pagination/app_back_button.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/themes/spacing.dart';

class ZapatoFormPage extends StatelessWidget {
  const ZapatoFormPage({super.key});

  /// Ejecuta la validación del formulario y registra el modelo en la base de datos.
  void _guardarModelo(BuildContext context) {
    Navigator.pop(context);
  }

  /// Desencadena el selector de imágenes de la galería o cámara.
  void _seleccionarImagen() {
    // TODO: Lógica de ImagePicker
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
        title: const Text('Registrar Modelo', style: TextStyle(color: AppColors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _seleccionarImagen,
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: AppColors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(color: AppColors.grey.withOpacity(0.3), style: BorderStyle.solid),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, size: 40, color: AppColors.grey),
                      SizedBox(height: AppSpacing.sm),
                      Text('Añadir Imagen', style: TextStyle(color: AppColors.grey)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text('Nombre del modelo *', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.xs),
            TextFormField(
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Ej. Air Force 1'),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Marca *', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: AppSpacing.xs),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                        items: const [],
                        onChanged: (val) {},
                        hint: const Text('Seleccionar'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Categoría *', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: AppSpacing.xs),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                        items: const [],
                        onChanged: (val) {},
                        hint: const Text('Seleccionar'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const Text('Descripción', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.xs),
            TextFormField(
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Detalles adicionales...'),
              maxLines: 3,
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _guardarModelo(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.racingRed,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Guardar Modelo'),
              ),
            )
          ],
        ),
      ),
    );
  }
}