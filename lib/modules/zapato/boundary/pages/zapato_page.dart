import 'package:flutter/material.dart';
import 'package:variedadesjm/shared/layouts/app_layout.dart';
import 'package:variedadesjm/shared/widgets/inputs/app_search_bar.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/themes/spacing.dart';

import "../widgets/zapato_empty_state.dart";
import '../widgets/zapato_item_card.dart';
import '../dialogs/zapato_filter_modal.dart';
import 'zapato_form_page.dart';
import 'zapato_detail_page.dart';

class ZapatoPage extends StatelessWidget {
  const ZapatoPage({super.key});

  /// Navega a la pantalla de registro para crear un nuevo modelo en el catálogo.
  void _irARegistro(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ZapatoFormPage()),
    );
  }

  /// Navega a la vista de detalles de un modelo específico del catálogo.
  void _irADetalle(BuildContext context, String idZapato) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ZapatoDetailPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  'Catálogo de Zapatos',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Gestiona los modelos, marcas y categorías',
                  style: TextStyle(color: AppColors.grey),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _irARegistro(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Registrar Nuevo Modelo'),
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
                        hintText: 'Buscar modelo...',
                        onChanged: (val) {},
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () => ZapatoFilterModal.show(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: isEmpty
                ? ZapatoEmptyState(onActionPressed: () => _irARegistro(context))
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: AppSpacing.md,
                      mainAxisSpacing: AppSpacing.md,
                    ),
                    itemCount: 6, 
                    itemBuilder: (context, index) {
                      return ZapatoItemCard(
                        nombre: 'Air Max Runner V${index + 1}',
                        marca: 'Nike',
                        categoria: 'Deportivo',
                        onTap: () => _irADetalle(context, '123'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}