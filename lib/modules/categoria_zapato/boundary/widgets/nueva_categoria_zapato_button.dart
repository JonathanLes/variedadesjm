import 'package:flutter/material.dart';
import 'package:variedadesjm/modules/categoria_zapato/boundary/pages/categoria_zapato_form_bottom_sheet.dart';

/// Botón principal que dispara la apertura del formulario modal para registrar una nueva categoría.
class NuevaCategoriaZapatoButton extends StatelessWidget {
  const NuevaCategoriaZapatoButton({super.key});

  void _openFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CategoriaZapatoFormBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: () => _openFormModal(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFB71C1C),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.add_circle_outline, size: 22),
        label: const Text(
          'Nueva categoría',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}