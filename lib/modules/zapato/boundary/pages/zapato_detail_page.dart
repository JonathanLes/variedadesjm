import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/themes/spacing.dart';
import 'package:variedadesjm/shared/widgets/ui/shoe_image.dart';
import '../../controller/zapato_controller.dart';
import '../../entity/zapato.dart';
import '../../../marca/controller/marca_controller.dart';
import '../../../categoria_zapato/controllers/categoria_zapato_controller.dart';

class ZapatoDetailPage extends ConsumerWidget {
  final Zapato zapato;

  const ZapatoDetailPage({super.key, required this.zapato});

  /// Ejecuta la eliminación lógica del modelo de zapato del catálogo.
  Future<void> _eliminarModelo(BuildContext context, WidgetRef ref) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar modelo'),
        content: const Text('¿Deseas eliminar este modelo del catálogo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmado != true || !context.mounted) return;
    try {
      await ref
          .read(zapatoControllerProvider.notifier)
          .eliminarZapato(zapato.id);
      if (context.mounted) Navigator.pop(context);
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$error')));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marcas = ref.watch(marcasCatalogoProvider).valueOrNull ?? const [];
    final categorias =
        ref.watch(categoriasZapatoCatalogoProvider).valueOrNull ?? const [];
    final marca = marcas
        .where((item) => item.id == zapato.idMarca)
        .map((item) => item.nombreMarca)
        .firstOrNull;
    final categoria = categorias
        .where((item) => item.id == zapato.idCategoria)
        .map((item) => item.nombreCategoria)
        .firstOrNull;
    return Scaffold(
      backgroundColor: context.cardColor,
      appBar: AppBar(
        title: const Text('Detalle del modelo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.danger),
            onPressed: () => _eliminarModelo(context, ref),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: SizedBox(
              height: 250,
              child: ShoeImage(path: zapato.imagenPath, fit: BoxFit.contain, iconSize: 90),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            zapato.modelo,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${marca ?? zapato.idMarca} • ${categoria ?? zapato.idCategoria}',
            style: TextStyle(fontSize: 16, color: context.muted),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            '\$ ${zapato.precioVentaSugerido.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Descripción',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            zapato.descripcion ?? 'Sin descripción registrada.',
            style: TextStyle(color: context.softInk, height: 1.5),
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.edit, color: context.softInk),
              label: Text(
                'Editar Modelo',
                style: TextStyle(color: context.softInk),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
