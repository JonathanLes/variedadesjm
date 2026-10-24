import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/modules/categoria_zapato/entity/categoria_zapato.dart';
import 'package:variedadesjm/modules/categoria_zapato/controllers/categoria_zapato_controller.dart';
import 'package:variedadesjm/modules/zapato/controller/zapato_controller.dart';
import 'package:variedadesjm/shared/widgets/ui/admin_page.dart';

/// Listado reactivo de categorías de zapatos.
class CategoriasZapatoListView extends ConsumerWidget {
  final void Function(CategoriaZapato categoria) onEdit;
  final void Function(CategoriaZapato categoria) onDelete;

  const CategoriasZapatoListView({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estadoAsync = ref.watch(categoriaZapatoControllerProvider);
    final modelos = ref.watch(zapatosCatalogoProvider).valueOrNull ?? const [];

    return estadoAsync.when(
      data: (estado) {
        final categorias = estado.categorias;
        if (categorias.isEmpty) {
          return const AdminMessage('No se encontraron categorías', icon: Icons.category_outlined);
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categorias.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final categoria = categorias[index];
            final total = modelos.where((m) => m.idCategoria == categoria.id).length;
            return AdminItemCard(
              leading: AdminAvatar(
                text: categoria.nombreCategoria.isNotEmpty
                    ? categoria.nombreCategoria[0].toUpperCase()
                    : '?',
              ),
              title: categoria.nombreCategoria.replaceAll('_', ' '),
              details: [
                AdminDetail(
                  total == 1 ? '1 modelo registrado' : '$total modelos registrados',
                  icon: Icons.inventory_2_outlined,
                ),
              ],
              onEdit: () => onEdit(categoria),
              onDelete: () => onDelete(categoria),
            );
          },
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 44),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => AdminMessage(
        'Error al cargar las categorías: $error',
        icon: Icons.error_outline,
        isError: true,
      ),
    );
  }
}
