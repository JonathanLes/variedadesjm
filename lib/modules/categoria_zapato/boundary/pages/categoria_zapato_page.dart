import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/modules/categoria_zapato/entity/categoria_zapato.dart';
import 'package:variedadesjm/modules/categoria_zapato/controllers/categoria_zapato_controller.dart';
import 'package:variedadesjm/modules/categoria_zapato/service/categoria_zapato_service.dart';

import 'package:variedadesjm/modules/categoria_zapato/boundary/widgets/categoria_zapato_header.dart';
import 'package:variedadesjm/modules/categoria_zapato/boundary/widgets/categoria_zapato_search_bar.dart';
import 'package:variedadesjm/modules/categoria_zapato/boundary/widgets/nueva_categoria_zapato_button.dart';
import 'package:variedadesjm/modules/categoria_zapato/boundary/widgets/categoria_zapato_list_view.dart';
import 'package:variedadesjm/modules/categoria_zapato/boundary/pages/categoria_zapato_form_bottom_sheet.dart';

import 'package:variedadesjm/shared/widgets/pagination/app_alphabet_filter.dart';
import 'package:variedadesjm/shared/widgets/pagination/app_sort_filter.dart';
import 'package:variedadesjm/shared/widgets/pagination/app_pagination.dart';
import 'package:variedadesjm/shared/widgets/pagination/app_back_button.dart';

/// Página principal del módulo de gestión de categorías de zapatos.
class CategoriaZapatoPage extends ConsumerWidget {
  const CategoriaZapatoPage({super.key});

  void _onEditCategoria(BuildContext context, CategoriaZapato categoria) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CategoriaZapatoFormBottomSheet(categoriaAEditar: categoria),
    );
  }

  void _onDeleteCategoria(BuildContext context, WidgetRef ref, CategoriaZapato categoria) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          '¿Eliminar categoría?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          '¿Estás seguro de que deseas eliminar la categoría "${categoria.nombreCategoria}"?',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB71C1C),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              _ejecutarEliminacion(context, ref, categoria);
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
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
      _mostrarSnackBarError(context, e.mensaje);
    } on CategoryNotFoundException catch (e) {
      _mostrarSnackBarError(context, e.mensaje);
    } catch (e) {
      _mostrarSnackBarError(
        context,
        'Ocurrió un error inesperado al eliminar la categoría.',
      );
    }
  }

  void _mostrarSnackBarError(BuildContext context, String mensaje) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red.shade800,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriaStateAsync = ref.watch(categoriaZapatoControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  AppBackButton(),
                  SizedBox(width: 16),
                  Expanded(child: CategoriaZapatoHeader()),
                ],
              ),
              const SizedBox(height: 16),
              const CategoriaZapatoSearchBar(),
              const SizedBox(height: 16),
              categoriaStateAsync.maybeWhen(
                data: (estado) => Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(child: NuevaCategoriaZapatoButton()),
                        const SizedBox(width: 12),
                        AppSortFilter(
                          currentSort: estado.filtros.sortDirection,
                          onSortChanged: (sort) {
                            ref
                                .read(categoriaZapatoControllerProvider.notifier)
                                .cambiarOrden(sort);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AppAlphabetFilter(
                      selectedLetter: estado.filtros.initialLetter,
                      onChanged: (letter) {
                        ref
                            .read(categoriaZapatoControllerProvider.notifier)
                            .cambiarLetra(letter);
                      },
                    ),
                  ],
                ),
                orElse: () => const NuevaCategoriaZapatoButton(),
              ),
              const SizedBox(height: 20),
              CategoriasZapatoListView(
                onEdit: (categoria) => _onEditCategoria(context, categoria),
                onDelete: (categoria) => _onDeleteCategoria(context, ref, categoria),
              ),
              const SizedBox(height: 24),
              categoriaStateAsync.maybeWhen(
                data: (estado) => Center(
                  child: AppPagination(
                    currentPage: estado.filtros.page,
                    totalItems: estado.totalItems,
                    pageSize: estado.filtros.pageSize,
                    itemName: 'categorías',
                    onPageChanged: (newPage) {
                      ref
                          .read(categoriaZapatoControllerProvider.notifier)
                          .cambiarPagina(newPage);
                    },
                  ),
                ),
                orElse: () => const SizedBox.shrink(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}