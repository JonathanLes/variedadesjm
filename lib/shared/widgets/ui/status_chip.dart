import 'package:flutter/material.dart';
import 'package:variedadesjm/shared/themes/colors.dart';

/// Tonos semánticos de la app: verde = venta/ganancia, ámbar = reserva/saldo,
/// rojo = gasto/aviso, azul = información.
enum StatusTone { success, warning, danger, info, neutral }

/// Color principal de un [StatusTone] para texto, íconos y barras.
Color toneColor(BuildContext context, StatusTone tone) {
  final scheme = Theme.of(context).colorScheme;
  switch (tone) {
    case StatusTone.success:
      return AppColors.success;
    case StatusTone.warning:
      return AppColors.warning;
    case StatusTone.danger:
      return AppColors.danger;
    case StatusTone.info:
      return scheme.primary;
    case StatusTone.neutral:
      return scheme.onSurfaceVariant;
  }
}

/// Etiqueta redondeada para estados: "Disponible", "Reservado", "Pendiente"...
class StatusChip extends StatelessWidget {
  final String label;
  final StatusTone tone;

  const StatusChip({super.key, required this.label, required this.tone});

  @override
  Widget build(BuildContext context) {
    final color = toneColor(context, tone);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
