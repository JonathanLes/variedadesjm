import 'package:flutter/material.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/themes/spacing.dart';
import '../widgets/inventario_status_badge.dart';

class InventarioChangeStateModal extends StatefulWidget {
  final EstadoInventario estadoActual;

  const InventarioChangeStateModal({super.key, required this.estadoActual});

  /// Muestra el modal para cambiar el estado de un par específico.
  static void show(BuildContext context, EstadoInventario estadoActual) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => InventarioChangeStateModal(estadoActual: estadoActual),
    );
  }

  @override
  State<InventarioChangeStateModal> createState() => _InventarioChangeStateModalState();
}

class _InventarioChangeStateModalState extends State<InventarioChangeStateModal> {
  late EstadoInventario _estadoSeleccionado;

  @override
  void initState() {
    super.initState();
    _estadoSeleccionado = widget.estadoActual;
  }

  /// Guarda el nuevo estado en la base de datos y cierra el modal.
  void _guardarEstado() {
    // TODO: Ejecutar controlador de Riverpod para actualizar estado en Sembast
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Cambiar estado del par',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Text('Selecciona el nuevo estado', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.sm),
          RadioListTile<EstadoInventario>(
            title: const Text('Activo'),
            subtitle: const Text('Disponible para venta'),
            value: EstadoInventario.activo,
            groupValue: _estadoSeleccionado,
            activeColor: Colors.green,
            onChanged: (val) => setState(() => _estadoSeleccionado = val!),
          ),
          RadioListTile<EstadoInventario>(
            title: const Text('Reservado'),
            subtitle: const Text('En proceso de apartado'),
            value: EstadoInventario.reservado,
            activeColor: Colors.orange,
            groupValue: _estadoSeleccionado,
            onChanged: (val) => setState(() => _estadoSeleccionado = val!),
          ),
          RadioListTile<EstadoInventario>(
            title: const Text('Vendido'),
            subtitle: const Text('Finalizado'),
            value: EstadoInventario.vendido,
            activeColor: AppColors.grey,
            groupValue: _estadoSeleccionado,
            onChanged: (val) => setState(() => _estadoSeleccionado = val!),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar', style: TextStyle(color: AppColors.graphite)),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: ElevatedButton(
                  onPressed: _guardarEstado,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.racingRed,
                    foregroundColor: AppColors.white,
                  ),
                  child: const Text('Cambiar Estado'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}