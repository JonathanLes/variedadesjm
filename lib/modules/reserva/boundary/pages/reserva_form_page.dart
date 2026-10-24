/// Formulario de nueva reserva: usa el formulario único con el modo "Reserva".
import 'package:flutter/material.dart';
import 'package:variedadesjm/shared/widgets/operation/operation_form_page.dart';

/// Abre el formulario de operación listo para registrar una reserva.
class ReservaFormPage extends StatelessWidget {
  const ReservaFormPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const OperationFormPage(initialMode: OperationMode.reserva);
}
