import 'package:flutter/material.dart';
import 'package:variedadesjm/modules/marca/boundary/pages/marca_form_bottom_sheet.dart';

/// Botón principal que dispara la apertura del formulario modal para registrar una nueva marca.
class NuevaMarcaButton extends StatelessWidget {
  const NuevaMarcaButton({super.key});

  void _openFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite ajustar la altura con el teclado desplegado
      backgroundColor: Colors.transparent,
      builder: (context) => const MarcaFormBottomSheet(),
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
          backgroundColor: const Color(0xFFB71C1C), // Rojo principal
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.add_circle_outline, size: 22),
        label: const Text(
          'Nueva marca',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}