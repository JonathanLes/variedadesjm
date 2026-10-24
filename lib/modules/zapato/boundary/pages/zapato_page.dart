import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/shared/layouts/app_layout.dart';
import 'package:variedadesjm/shared/widgets/inputs/app_search_bar.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/themes/spacing.dart';

import "../widgets/zapato_empty_state.dart";
import '../widgets/zapato_item_card.dart';
import '../dialogs/zapato_filter_modal.dart';
import 'zapato_form_page.dart';
import 'zapato_detail_page.dart';
import '../../controller/zapato_controller.dart';
import '../../../marca/controller/marca_controller.dart';
import '../../../categoria_zapato/controllers/categoria_zapato_controller.dart';

class ZapatoPage extends ConsumerWidget {
  const ZapatoPage({super.key});

  void _irARegistro(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ZapatoFormPage()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zapatos = ref.watch(zapatoControllerProvider);
    final marcas = ref.watch(marcasCatalogoProvider).valueOrNull ?? const [];
    final categorias = ref.watch(categoriasZapatoCatalogoProvider).valueOrNull ?? const [];
    final nombresMarca = {for (final marca in marcas) marca.id: marca.nombreMarca};
    final nombresCategoria = {for (final categoria in categorias) categoria.id: categoria.nombreCategoria};

    return AppLayout(
      child: zapatos.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('No se pudo cargar el catálogo: $error')),
        data: (state) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Catálogo de Zapatos',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const Text('Gestiona los modelos, marcas y categorías',
                      style: TextStyle(color: AppColors.grey)),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _irARegistro(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Registrar Nuevo Modelo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brand,
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
                          onChanged: (value) => ref
                              .read(zapatoControllerProvider.notifier)
                              .buscarZapatos(value),
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
              child: state.zapatos.isEmpty
                  ? ZapatoEmptyState(onActionPressed: () => _irARegistro(context))
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.85,
                        crossAxisSpacing: AppSpacing.md,
                        mainAxisSpacing: AppSpacing.md,
                      ),
                      itemCount: state.zapatos.length,
                      itemBuilder: (context, index) {
                        final zapato = state.zapatos[index];
                        return ZapatoItemCard(
                          nombre: zapato.modelo,
                          marca: nombresMarca[zapato.idMarca] ?? zapato.idMarca,
                          categoria: nombresCategoria[zapato.idCategoria] ?? zapato.idCategoria,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ZapatoDetailPage(zapato: zapato),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
