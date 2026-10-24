import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/shared/data/app_data_provider.dart';
import 'package:variedadesjm/shared/layouts/app_layout.dart';
import 'package:variedadesjm/shared/widgets/inputs/app_search_bar.dart';
import 'package:variedadesjm/shared/widgets/pagination/app_pagination.dart';

import '../widgets/inventario_summary_cards.dart';
import '../widgets/inventario_item_card.dart';
import '../widgets/inventario_empty_state.dart';
import '../widgets/inventario_status_badge.dart';
import '../dialogs/inventario_filter_modal.dart';
import '../../controller/inventario_controller.dart';
import '../../entity/inventario.dart';
import 'inventario_form_page.dart';
import 'inventario_detail_page.dart';
import '../../../zapato/controller/zapato_controller.dart';

/// Inventario físico: resumen, búsqueda, filtros por estado y cuadrícula de pares.
class InventarioPage extends ConsumerWidget {
  const InventarioPage({super.key});

  /// Navega a la pantalla de registro de un nuevo par físico.
  Future<void> _irARegistro(BuildContext context, WidgetRef ref) async {
    final resultado = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const InventarioFormPage()),
    );
    ref.invalidate(existenciasProvider);
    if (context.mounted && resultado != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resultado)),
      );
    }
  }

  /// Navega al detalle de un par de zapatos específico.
  Future<void> _irADetalle(BuildContext context, WidgetRef ref, Inventario item) async {
    final resultado = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => InventarioDetailPage(item: item)),
    );
    ref.invalidate(existenciasProvider);
    if (context.mounted && resultado != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resultado)),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventario = ref.watch(inventarioControllerProvider);
    final todas = ref.watch(existenciasProvider).valueOrNull ?? const <Inventario>[];
    final zapatos = ref.watch(zapatosCatalogoProvider).valueOrNull ?? const [];
    final modelos = {for (final zapato in zapatos) zapato.id: zapato};
    final scheme = Theme.of(context).colorScheme;

    final enStock = todas.where((i) => i.estado != EstadoZapato.vendido).toList();
    final activos = todas.where((i) => i.estado == EstadoZapato.activo).length;
    final reservados = todas.where((i) => i.estado == EstadoZapato.reservado).length;
    final valor = enStock.fold<double>(0, (sum, i) => sum + i.precioCompra);

    return AppLayout(
      currentIndex: 3,
      child: inventario.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('No se pudo cargar el inventario: $error')),
        data: (state) {
          final items = state.items;
          final notifier = ref.read(inventarioControllerProvider.notifier);

          Widget estadoChip(String label, EstadoZapato? estado) => ChoiceChip(
                label: Text(label),
                selected: state.filtroEstado == estado,
                onSelected: (_) => notifier.aplicarFiltrosEspeciales(
                  idZapato: state.filtroIdZapato,
                  estado: estado,
                ),
              );

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Inventario',
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.w800, color: scheme.primary)),
                      const Text('Administra tus pares de calzado'),
                      const SizedBox(height: 12),
                      InventarioSummaryCards(
                        totalPares: todas.length,
                        paresActivos: activos,
                        paresReservados: reservados,
                        valorTotal: valor,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: AppSearchBar(
                              hintText: 'Buscar por código o color...',
                              textCapitalization: TextCapitalization.characters,
                              onChanged: (val) => notifier.buscarInventario(val.toUpperCase()),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton.filled(
                            tooltip: 'Más filtros',
                            icon: const Icon(Icons.filter_list_rounded),
                            onPressed: () => InventarioFilterModal.show(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          estadoChip('Todos', null),
                          estadoChip('Disponibles', EstadoZapato.activo),
                          estadoChip('Reservados', EstadoZapato.reservado),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Text('Pares (${state.totalItems})',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w800)),
                          ),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(0, 38),
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                            ),
                            onPressed: () => _irARegistro(context, ref),
                            icon: const Icon(Icons.add_rounded, size: 18),
                            label: const Text('Registrar par'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (items.isEmpty)
                SliverToBoxAdapter(
                  child: InventarioEmptyState(onActionPressed: () => _irARegistro(context, ref)),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid.builder(
                    itemCount: items.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.78,
                    ),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final zapato = modelos[item.idZapato];
                      return InventarioItemCard(
                        sku: item.codigo,
                        modelo: zapato?.modelo ?? item.idZapato,
                        imagenPath: zapato?.imagenPath,
                        detalle: [
                          if ((item.color ?? '').isNotEmpty) item.color!,
                          'Talla ${item.talla} / ${item.cm} cm',
                        ].join(' · '),
                        precio: zapato?.precioVentaSugerido ?? 0,
                        estado: EstadoInventario.values.byName(item.estado.name),
                        onTap: () => _irADetalle(context, ref, item),
                      );
                    },
                  ),
                ),
              if (items.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: AppPagination(
                      currentPage: state.filtros.page,
                      totalItems: state.totalItems,
                      onPageChanged: (page) => notifier.cambiarPagina(page),
                    ),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 70)),
            ],
          );
        },
      ),
    );
  }
}
