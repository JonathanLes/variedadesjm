/// Formulario de nueva venta: usa el formulario único con el modo "Venta".
import 'package:flutter/material.dart';
import 'package:variedadesjm/shared/widgets/operation/operation_form_page.dart';

/// Abre el formulario de operación listo para registrar una venta.
class VentaFormPage extends StatelessWidget {
  const VentaFormPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const OperationFormPage(initialMode: OperationMode.venta);
}
