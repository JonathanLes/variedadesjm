import 'package:flutter/material.dart';
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
import 'inventario_form_page.dart';
import 'inventario_detail_page.dart';

class InventarioPage extends StatelessWidget {
  const InventarioPage({super.key});

  /// Navega a la pantalla de registro de un nuevo par físico.
  void _irARegistro(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const InventarioFormPage()),
    );
  }

  /// Navega al detalle de un par de zapatos específico.
  void _irADetalle(BuildContext context, String sku) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const InventarioDetailPage()), // Pasar el ID/SKU en el futuro
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Obtener datos reales desde Riverpod
    final bool isEmpty = false; 

    return AppLayout(
      child: Column(
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
                const InventarioSummaryCards(
                  totalPares: 248,
                  paresActivos: 198,
                  paresReservados: 32,
                  valorTotal: 24850.00,
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
                        onChanged: (val) {},
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
                    itemCount: 5, // Mock
                    itemBuilder: (context, index) {
                      return InventarioItemTile(
                        sku: 'INV-20250915-1200-000${index + 1}',
                        modelo: 'Air Max Runner',
                        tallaCm: '9 / 27.5',
                        estado: EstadoInventario.activo,
                        onTap: () => _irADetalle(context, '123'),
                      );
                    },
                  ),
          ),
          if (!isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: AppPagination(
                currentPage: 1,
                totalItems: 50,
                onPageChanged: (page) {},
              ),
            ),
        ],
      ),
    );
  }
}