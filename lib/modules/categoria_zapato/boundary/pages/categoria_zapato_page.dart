import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/modules/categoria_zapato/entity/categoria_zapato.dart';
import 'package:variedadesjm/modules/categoria_zapato/controllers/categoria_zapato_controller.dart';
import 'package:variedadesjm/modules/categoria_zapato/service/categoria_zapato_service.dart';
import 'package:variedadesjm/modules/categoria_zapato/boundary/widgets/categoria_zapato_search_bar.dart';
import 'package:variedadesjm/modules/categoria_zapato/boundary/widgets/categoria_zapato_list_view.dart';
import 'package:variedadesjm/modules/categoria_zapato/boundary/pages/categoria_zapato_form_bottom_sheet.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/widgets/pagination/app_alphabet_filter.dart';
import 'package:variedadesjm/shared/widgets/pagination/app_sort_filter.dart';
import 'package:variedadesjm/shared/widgets/pagination/app_pagination.dart';
import 'package:variedadesjm/shared/widgets/ui/admin_page.dart';

/// Página principal del módulo de gestión de categorías de zapatos.
class CategoriaZapatoPage extends ConsumerWidget {
  const CategoriaZapatoPage({super.key});

  /// Abre el formulario modal para crear una categoría (o editar si se pasa una).
  void _openForm(BuildContext context, [CategoriaZapato? categoria]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CategoriaZapatoFormBottomSheet(categoriaAEditar: categoria),
    );
  }

  /// Pide confirmación y elimina la categoría.
  Future<void> _onDelete(BuildContext context, WidgetRef ref, CategoriaZapato categoria) async {
    final ok = await confirmDelete(
      context,
      title: '¿Eliminar categoría?',
      message: '¿Estás seguro de que deseas eliminar la categoría "${categoria.nombreCategoria}"?',
    );
    if (!ok || !context.mounted) return;
    await _ejecutarEliminacion(context, ref, categoria);
  }

  Future<void> _ejecutarEliminacion(
    BuildContext context,
    WidgetRef ref,
    CategoriaZapato categoria,
  ) async {
    try {
      await ref
          .read(categoriaZapatoControllerProvider.notifier)
          .eliminarCategoria(categoria.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Categoría "${categoria.nombreCategoria}" eliminada correctamente'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } on CategoryInUseException catch (e) {
      _mostrarError(context, e.mensaje);
    } on CategoryNotFoundException catch (e) {
      _mostrarError(context, e.mensaje);
    } catch (e) {
      _mostrarError(context, 'Ocurrió un error inesperado al eliminar la categoría.');
    }
  }

  void _mostrarError(BuildContext context, String mensaje) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: AppColors.danger,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estadoAsync = ref.watch(categoriaZapatoControllerProvider);
    final notifier = ref.read(categoriaZapatoControllerProvider.notifier);

    return AdminPage(
      title: 'Categorías',
      subtitle: 'Registra las categorías del calzado',
      addLabel: 'Nueva categoría',
      onAdd: () => _openForm(context),
      children: [
        Row(
          children: [
            const Expanded(child: CategoriaZapatoSearchBar()),
            estadoAsync.maybeWhen(
              data: (estado) => Padding(
                padding: const EdgeInsets.only(left: 10),
                child: AppSortFilter(
                  currentSort: estado.filtros.sortDirection,
                  onSortChanged: notifier.cambiarOrden,
                ),
              ),
              orElse: () => const SizedBox.shrink(),
            ),
          ],
        ),
        estadoAsync.maybeWhen(
          data: (estado) => Padding(
            padding: const EdgeInsets.only(top: 12),
            child: AppAlphabetFilter(
              selectedLetter: estado.filtros.initialLetter,
              onChanged: notifier.cambiarLetra,
            ),
          ),
          orElse: () => const SizedBox.shrink(),
        ),
        const SizedBox(height: 16),
        CategoriasZapatoListView(
          onEdit: (categoria) => _openForm(context, categoria),
          onDelete: (categoria) => _onDelete(context, ref, categoria),
        ),
        const SizedBox(height: 16),
        estadoAsync.maybeWhen(
          data: (estado) => Center(
            child: AppPagination(
              currentPage: estado.filtros.page,
              totalItems: estado.totalItems,
              pageSize: estado.filtros.pageSize,
              itemName: 'categorías',
              onPageChanged: notifier.cambiarPagina,
            ),
          ),
          orElse: () => const SizedBox.shrink(),
        ),
      ],
    );
  }
}
