import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/modules/categoria_zapato/controllers/categoria_zapato_controller.dart';
import 'package:variedadesjm/modules/marca/controller/marca_controller.dart';
import 'package:variedadesjm/shared/utils/format.dart';
import 'package:variedadesjm/shared/widgets/ui/shoe_image.dart';

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
    final modelos = ref.watch(zapatosCatalogoProvider).valueOrNull ?? const [];
    final zapato = modelos.where((z) => z.id == item.idZapato).firstOrNull;
    final marca = (ref.watch(marcasCatalogoProvider).valueOrNull ?? const [])
        .where((m) => m.id == zapato?.idMarca)
        .map((m) => m.nombreMarca)
        .firstOrNull;
    final categoria =
        (ref.watch(categoriasZapatoCatalogoProvider).valueOrNull ?? const [])
            .where((c) => c.id == zapato?.idCategoria)
            .map((c) => c.nombreCategoria)
            .firstOrNull;
    final sugerido = zapato?.precioVentaSugerido ?? 0;
    final ganancia = sugerido - item.precioCompra;
    final subtitulo = [
      if (marca != null) marca,
      if (categoria != null) categoria.replaceAll('_', ' '),
    ].join(' · ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del par'),
        actions: [
          IconButton(
            tooltip: 'Eliminar',
            icon: const Icon(Icons.delete_outline, color: AppColors.danger),
            onPressed: () => _eliminarPar(context, ref),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: SizedBox(
              height: 230,
              child: ShoeImage(
                path: zapato?.imagenPath,
                fit: BoxFit.contain,
                iconSize: 80,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      zapato?.modelo ?? item.idZapato,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                    if (subtitulo.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(subtitulo, style: TextStyle(color: context.muted)),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              InventarioStatusBadge(estado: EstadoInventario.values.byName(item.estado.name)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _Dato(
                icono: Icons.sell_outlined,
                etiqueta: 'Precio sugerido',
                valor: money(sugerido),
                color: context.brand,
              ),
              const SizedBox(width: 10),
              _Dato(
                icono: Icons.trending_up_rounded,
                etiqueta: 'Ganancia estimada',
                valor: money(ganancia),
                color: ganancia < 0 ? AppColors.danger : AppColors.success,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Column(
                children: [
                  _Fila(Icons.qr_code_rounded, 'Código (SKU)', item.codigo),
                  _Fila(Icons.straighten_rounded, 'Talla / cm', '${item.talla} / ${item.cm} cm'),
                  _Fila(Icons.palette_outlined, 'Color',
                      (item.color ?? '').isEmpty ? 'Sin color registrado' : item.color!),
                  _Fila(Icons.payments_outlined, 'Precio de compra', money(item.precioCompra)),
                  _Fila(Icons.calendar_today_outlined, 'Fecha de compra',
                      shortDate(item.fechaCompra),
                      ultima: true),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: () => _abrirModalCambioEstado(context),
            icon: const Icon(Icons.sync),
            label: const Text('Cambiar estado del par'),
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () async {
              final resultado = await Navigator.push<String>(
                context,
                MaterialPageRoute(builder: (_) => InventarioFormPage(item: item)),
              );
              if (context.mounted && resultado != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(resultado)),
                );
              }
            },
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Editar datos'),
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta con un dato destacado (precio sugerido, ganancia...).
class _Dato extends StatelessWidget {
  final IconData icono;
  final String etiqueta;
  final String valor;
  final Color color;

  const _Dato({
    required this.icono,
    required this.etiqueta,
    required this.valor,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icono, size: 16, color: color),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(etiqueta,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: context.muted)),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(valor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Fila de información: ícono, etiqueta y valor.
class _Fila extends StatelessWidget {
  final IconData icono;
  final String etiqueta;
  final String valor;
  final bool ultima;

  const _Fila(this.icono, this.etiqueta, this.valor, {this.ultima = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: ultima ? null : Border(bottom: BorderSide(color: context.line)),
      ),
      child: Row(
        children: [
          Icon(icono, size: 20, color: context.brand),
          const SizedBox(width: 12),
          Expanded(child: Text(etiqueta, style: TextStyle(color: context.muted))),
          const SizedBox(width: 8),
          Flexible(
            child: Text(valor,
                textAlign: TextAlign.end,
                style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
