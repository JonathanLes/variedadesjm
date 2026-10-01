import 'package:flutter/material.dart';
import 'package:variedadesjm/shared/widgets/pagination/app_back_button.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/themes/spacing.dart';

import '../widgets/inventario_status_badge.dart';
import '../dialogs/inventario_change_state_modal.dart';

class InventarioDetailPage extends StatelessWidget {
  const InventarioDetailPage({super.key});

  /// Abre el modal inferior para modificar el estado del inventario.
  void _abrirModalCambioEstado(BuildContext context) {
    InventarioChangeStateModal.show(context, EstadoInventario.activo);
  }

  /// Ejecuta la eliminación lógica o física del registro tras verificar reglas de negocio.
  void _eliminarPar(BuildContext context) {
    // TODO: Validar si está en estado reservado. Mostrar snackbar si falla.
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
        title: const Text('Detalle del Par', style: TextStyle(color: AppColors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Container(
            height: 200,
            color: AppColors.grey.withOpacity(0.1),
            child: const Center(child: Icon(Icons.image, size: 100, color: AppColors.grey)),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Air Max Runner',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const InventarioStatusBadge(estado: EstadoInventario.activo),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.qr_code),
            title: const Text('Código (SKU)'),
            subtitle: const Text('INV-20250915-1200-0001'),
          ),
          ListTile(
            leading: const Icon(Icons.straighten),
            title: const Text('Talla / Cm'),
            subtitle: const Text('9 / 27.5 cm'),
          ),
          ListTile(
            leading: const Icon(Icons.monetization_on_outlined),
            title: const Text('Precio de compra'),
            subtitle: const Text('\$ 120.00'),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, color: AppColors.graphite),
                  label: const Text('Editar', style: TextStyle(color: AppColors.graphite)),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _abrirModalCambioEstado(context),
                  icon: const Icon(Icons.sync),
                  label: const Text('Cambiar Estado'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.racingRed,
                    foregroundColor: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}