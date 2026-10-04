import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/shared/layouts/app_layout.dart';
import 'package:variedadesjm/shared/widgets/inputs/app_search_bar.dart';
import 'package:variedadesjm/shared/widgets/pagination/app_pagination.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/themes/spacing.dart';

import '../widgets/inventario_summary_cards.dart';
import '../widgets/inventario_item_tile.dart';
import '../widgets/inventario_empty_state.dart';
import '../widgets/inventario_status_badge.dart';
import '../dialogs/inventario_filter_modal.dart';
import '../../controller/inventario_controller.dart';
import '../../entity/inventario.dart';
import 'inventario_form_page.dart';
import 'inventario_detail_page.dart';
import '../../../zapato/controller/zapato_controller.dart';

class InventarioPage extends ConsumerWidget {
  const InventarioPage({super.key});

  /// Navega a la pantalla de registro de un nuevo par físico.
  Future<void> _irARegistro(BuildContext context) async {
    final resultado = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const InventarioFormPage()),
    );
    if (context.mounted && resultado != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resultado)),
      );
    }
  }

  /// Navega al detalle de un par de zapatos específico.
  Future<void> _irADetalle(BuildContext context, Inventario item) async {
    final resultado = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => InventarioDetailPage(item: item)),
    );
    if (context.mounted && resultado != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resultado)),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventario = ref.watch(inventarioControllerProvider);
    final zapatos = ref.watch(zapatosCatalogoProvider).valueOrNull ?? const [];
    final nombresZapato = {for (final zapato in zapatos) zapato.id: zapato.modelo};

    return AppLayout(
      currentIndex: 3,
      child: inventario.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('No se pudo cargar el inventario: $error')),
        data: (state) {
        final items = state.items;
        final isEmpty = items.isEmpty;
        final activos = items.where((item) => item.estado == EstadoZapato.activo).length;
        final reservados = items.where((item) => item.estado == EstadoZapato.reservado).length;
        final valor = items.fold<double>(0, (sum, item) => sum + item.precioCompra);

        return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Inventario de Existencias',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Controla el stock físico de cada par de calzado',
                  style: TextStyle(color: AppColors.grey),
                ),
                const SizedBox(height: AppSpacing.md),
                InventarioSummaryCards(
                  totalPares: items.length,
                  paresActivos: activos,
                  paresReservados: reservados,
                  valorTotal: valor,
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _irARegistro(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Registrar Nuevo Par'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.racingRed,
                      foregroundColor: AppColors.white,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: AppSearchBar(
                        hintText: 'Buscar por código o color...',
                        textCapitalization: TextCapitalization.characters,
                        onChanged: (val) => ref.read(inventarioControllerProvider.notifier).buscarInventario(val.toUpperCase()),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () => InventarioFilterModal.show(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: isEmpty
                ? InventarioEmptyState(onActionPressed: () => _irARegistro(context))
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return InventarioItemTile(
                        sku: item.codigo,
                        modelo: nombresZapato[item.idZapato] ?? item.idZapato,
                        imagenPath: zapatos
                            .where((zapato) => zapato.id == item.idZapato)
                            .map((zapato) => zapato.imagenPath)
                            .firstOrNull,
                        tallaCm: '${item.talla} / ${item.cm}',
                        estado: EstadoInventario.values.byName(item.estado.name),
                        onTap: () => _irADetalle(context, item),
                      );
                    },
                  ),
          ),
          if (!isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: AppPagination(
                currentPage: state.filtros.page,
                totalItems: state.totalItems,
                onPageChanged: (page) => ref.read(inventarioControllerProvider.notifier).cambiarPagina(page),
              ),
            ),
        ],
      );
        },
      ),
    );
  }
}