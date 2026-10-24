import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/modules/marca/entity/marca.dart';
import 'package:variedadesjm/modules/marca/controller/marca_controller.dart';
import 'package:variedadesjm/modules/marca/service/marca_service.dart';
import 'package:variedadesjm/modules/marca/boundary/widgets/marca_search_bar.dart';
import 'package:variedadesjm/modules/marca/boundary/widgets/marca_list_view.dart';
import 'package:variedadesjm/modules/marca/boundary/pages/marca_form_bottom_sheet.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/widgets/pagination/app_alphabet_filter.dart';
import 'package:variedadesjm/shared/widgets/pagination/app_sort_filter.dart';
import 'package:variedadesjm/shared/widgets/pagination/app_pagination.dart';
import 'package:variedadesjm/shared/widgets/ui/admin_page.dart';

/// Página principal del módulo de gestión de marcas.
class MarcaPage extends ConsumerWidget {
  const MarcaPage({super.key});

  /// Abre el formulario modal para crear una marca (o editar si se pasa una).
  void _openForm(BuildContext context, [Marca? marca]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MarcaFormBottomSheet(marcaAEditar: marca),
    );
  }

  /// Pide confirmación y elimina la marca.
  Future<void> _onDeleteMarca(BuildContext context, WidgetRef ref, Marca marca) async {
    final ok = await confirmDelete(
      context,
      title: '¿Eliminar marca?',
      message: '¿Estás seguro de que deseas eliminar la marca "${marca.nombreMarca}"?',
    );
    if (!ok || !context.mounted) return;
    await _ejecutarEliminacion(context, ref, marca);
  }

  /// Llama al controller para eliminar la marca y gestiona las excepciones de negocio
  Future<void> _ejecutarEliminacion(
    BuildContext context,
    WidgetRef ref,
    Marca marca,
  ) async {
    try {
      await ref.read(marcaControllerProvider.notifier).eliminarMarca(marca.id);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Marca "${marca.nombreMarca}" eliminada correctamente'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } on BrandInUseExpection catch (e) {
      _mostrarSnackBarError(context, e.mensaje);
    } on BrandNotFoundExpection catch (e) {
      _mostrarSnackBarError(context, e.mensaje);
    } catch (e) {
      _mostrarSnackBarError(
        context,
        'Ocurrió un error inesperado al eliminar la marca.',
      );
    }
  }

  void _mostrarSnackBarError(BuildContext context, String mensaje) {
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
    final marcaStateAsync = ref.watch(marcaControllerProvider);
    final notifier = ref.read(marcaControllerProvider.notifier);

    return AdminPage(
      title: 'Marcas',
      subtitle: 'Registra las marcas del calzado',
      addLabel: 'Nueva marca',
      onAdd: () => _openForm(context),
      children: [
        Row(
          children: [
            const Expanded(child: MarcaSearchBar()),
            marcaStateAsync.maybeWhen(
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
        marcaStateAsync.maybeWhen(
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
        MarcasListView(
          onEdit: (marca) => _openForm(context, marca),
          onDelete: (marca) => _onDeleteMarca(context, ref, marca),
        ),
        const SizedBox(height: 16),
        marcaStateAsync.maybeWhen(
          data: (estado) => Center(
            child: AppPagination(
              currentPage: estado.filtros.page,
              totalItems: estado.totalItems,
              pageSize: estado.filtros.pageSize,
              itemName: 'marcas',
              onPageChanged: notifier.cambiarPagina,
            ),
          ),
          orElse: () => const SizedBox.shrink(),
        ),
      ],
    );
  }
}
