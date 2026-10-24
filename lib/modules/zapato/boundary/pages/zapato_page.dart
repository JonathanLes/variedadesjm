import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/shared/widgets/inputs/app_search_bar.dart';
import 'package:variedadesjm/shared/widgets/ui/admin_page.dart';

import '../widgets/zapato_item_card.dart';
import '../dialogs/zapato_filter_modal.dart';
import 'zapato_form_page.dart';
import 'zapato_detail_page.dart';
import '../../controller/zapato_controller.dart';
import '../../../marca/controller/marca_controller.dart';
import '../../../categoria_zapato/controllers/categoria_zapato_controller.dart';

/// Catálogo de modelos: foto, marca y categoría de cada zapato.
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
    final scheme = Theme.of(context).colorScheme;

    return AdminPage(
      title: 'Productos',
      subtitle: 'Gestiona los modelos, marcas y categorías',
      addLabel: 'Nuevo modelo',
      onAdd: () => _irARegistro(context),
      children: [
        Row(
          children: [
            Expanded(
              child: AppSearchBar(
                hintText: 'Buscar modelo',
                onChanged: (value) =>
                    ref.read(zapatoControllerProvider.notifier).buscarZapatos(value),
              ),
            ),
            const SizedBox(width: 10),
            Material(
              color: scheme.primary,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => ZapatoFilterModal.show(context),
                child: const SizedBox(
                  width: 48,
                  height: 48,
                  child: Icon(Icons.filter_list_rounded, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        zapatos.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 44),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => AdminMessage(
            'No se pudo cargar el catálogo: $error',
            icon: Icons.error_outline,
            isError: true,
          ),
          data: (state) {
            if (state.zapatos.isEmpty) {
              return const AdminMessage(
                'Aún no hay modelos registrados. Toca "Nuevo modelo" para agregar el primero.',
                icon: Icons.style_outlined,
              );
            }
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.82,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: state.zapatos.length,
              itemBuilder: (context, index) {
                final zapato = state.zapatos[index];
                return ZapatoItemCard(
                  nombre: zapato.modelo,
                  marca: nombresMarca[zapato.idMarca] ?? zapato.idMarca,
                  categoria: (nombresCategoria[zapato.idCategoria] ?? zapato.idCategoria)
                      .replaceAll('_', ' '),
                  imagenPath: zapato.imagenPath,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ZapatoDetailPage(zapato: zapato),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
