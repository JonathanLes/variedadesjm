import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/themes/spacing.dart';

import '../widgets/inventario_status_badge.dart';
import '../dialogs/inventario_change_state_modal.dart';
import '../../controller/inventario_controller.dart';
import '../../entity/inventario.dart';
import 'inventario_form_page.dart';
import '../../../zapato/controller/zapato_controller.dart';

class InventarioDetailPage extends ConsumerWidget {
  final Inventario item;

  const InventarioDetailPage({super.key, required this.item});

  /// Abre el modal inferior para modificar el estado del inventario.
  Future<void> _abrirModalCambioEstado(BuildContext context) async {
    final resultado = await InventarioChangeStateModal.show(context, item);
    if (context.mounted && resultado != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resultado)),
      );
    }
  }

  /// Ejecuta la eliminación lógica o física del registro tras verificar reglas de negocio.
  Future<void> _eliminarPar(BuildContext context, WidgetRef ref) async {
    if (item.estado != EstadoZapato.activo) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se puede eliminar un par reservado o vendido.')),
      );
      return;
    }
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar inventario'),
        content: const Text('¿Deseas eliminar este registro? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
        ],
      ),
    );
    if (confirmado != true || !context.mounted) return;
    try {
      await ref.read(inventarioControllerProvider.notifier).eliminarInventario(item.id);
      if (context.mounted) {
        Navigator.pop(context, 'Inventario eliminado correctamente.');
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$error')));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        leading: const BackButton(color: AppColors.white),
        title: const Text('Detalle del Par', style: TextStyle(color: AppColors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _buildImagen(ref),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  (ref.watch(zapatosCatalogoProvider).valueOrNull ?? const [])
                      .where((zapato) => zapato.id == item.idZapato)
                      .map((zapato) => zapato.modelo)
                      .firstOrNull ??
                  item.idZapato,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              InventarioStatusBadge(estado: EstadoInventario.values.byName(item.estado.name)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.qr_code),
            title: const Text('Código (SKU)'),
            subtitle: Text(item.codigo),
          ),
          ListTile(
            leading: const Icon(Icons.straighten),
            title: const Text('Talla / Cm'),
            subtitle: Text('${item.talla} / ${item.cm} cm'),
          ),
          ListTile(
            leading: const Icon(Icons.monetization_on_outlined),
            title: const Text('Precio de compra'),
            subtitle: Text('\$ ${item.precioCompra.toStringAsFixed(2)}'),
          ),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Color'),
            subtitle: Text(item.color ?? 'Sin color registrado'),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today_outlined),
            title: const Text('Fecha de compra'),
            subtitle: Text(
              '${item.fechaCompra.day.toString().padLeft(2, '0')}/'
              '${item.fechaCompra.month.toString().padLeft(2, '0')}/'
              '${item.fechaCompra.year}',
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _eliminarPar(context, ref),
                  icon: const Icon(Icons.delete_outline, color: AppColors.racingRed),
                  label: const Text('Eliminar', style: TextStyle(color: AppColors.racingRed)),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final resultado = await Navigator.push<String>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => InventarioFormPage(item: item),
                      ),
                    );
                    if (context.mounted && resultado != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(resultado)),
                      );
                    }
                  },
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

  Widget _buildImagen(WidgetRef ref) {
    final zapato = (ref.watch(zapatosCatalogoProvider).valueOrNull ?? const [])
        .where((item) => item.id == this.item.idZapato)
        .firstOrNull;
    final path = zapato?.imagenPath;
    return Container(
      height: 200,
      color: AppColors.grey.withOpacity(0.1),
      child: path == null
          ? const Center(child: Icon(Icons.image, size: 100, color: AppColors.grey))
          : Image.file(
              File(path),
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Center(
                child: Icon(Icons.broken_image, size: 100, color: AppColors.grey),
              ),
            ),
    );
  }
}