import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/themes/spacing.dart';
import '../../controller/inventario_controller.dart';
import '../../entity/inventario.dart';

class InventarioChangeStateModal extends ConsumerStatefulWidget {
  final Inventario item;

  const InventarioChangeStateModal({super.key, required this.item});

  /// Muestra el modal para cambiar el estado de un par específico.
  static Future<String?> show(BuildContext context, Inventario item) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => InventarioChangeStateModal(item: item),
    );
  }

  @override
  ConsumerState<InventarioChangeStateModal> createState() =>
      _InventarioChangeStateModalState();
}

class _InventarioChangeStateModalState
    extends ConsumerState<InventarioChangeStateModal> {
  late EstadoZapato _estadoSeleccionado;

  @override
  void initState() {
    super.initState();
    _estadoSeleccionado = widget.item.estado;
  }

  /// Guarda el nuevo estado en la base de datos y cierra el modal.
  Future<void> _guardarEstado() async {
    try {
      await ref
          .read(inventarioControllerProvider.notifier)
          .cambiarEstadoInventario(widget.item.id, _estadoSeleccionado);
      if (mounted) {
        Navigator.pop(
          context,
          'Estado cambiado a ${_nombreEstado(_estadoSeleccionado)} correctamente.',
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$error')));
      }
    }
  }

  String _nombreEstado(EstadoZapato estado) {
    switch (estado) {
      case EstadoZapato.activo:
        return 'Activo';
      case EstadoZapato.reservado:
        return 'Reservado';
      case EstadoZapato.vendido:
        return 'Vendido';
    }
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
          const Text(
            'Selecciona el nuevo estado',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.sm),
          RadioListTile<EstadoZapato>(
            title: const Text('Activo'),
            subtitle: const Text('Disponible para venta'),
            value: EstadoZapato.activo,
            groupValue: _estadoSeleccionado,
            activeColor: Colors.green,
            onChanged: (val) => setState(() => _estadoSeleccionado = val!),
          ),
          RadioListTile<EstadoZapato>(
            title: const Text('Reservado'),
            subtitle: const Text('En proceso de apartado'),
            value: EstadoZapato.reservado,
            activeColor: Colors.orange,
            groupValue: _estadoSeleccionado,
            onChanged: (val) => setState(() => _estadoSeleccionado = val!),
          ),
          RadioListTile<EstadoZapato>(
            title: const Text('Vendido'),
            subtitle: const Text('Finalizado'),
            value: EstadoZapato.vendido,
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
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: AppColors.graphite),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: ElevatedButton(
                  onPressed: _guardarEstado,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brand,
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
