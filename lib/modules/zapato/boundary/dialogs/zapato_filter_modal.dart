import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/controllers/database/sembast_stores.dart';
import 'package:variedadesjm/modules/zapato/controller/zapato_controller.dart';
import 'package:variedadesjm/shared/data/catalog_queries.dart';
import 'package:variedadesjm/shared/widgets/forms/paged_picker.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/themes/spacing.dart';

class ZapatoFilterModal extends ConsumerStatefulWidget {
  const ZapatoFilterModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ZapatoFilterModal(),
    );
  }

  @override
  ConsumerState<ZapatoFilterModal> createState() => _ZapatoFilterModalState();
}

class _ZapatoFilterModalState extends ConsumerState<ZapatoFilterModal> {
  String? _idMarca;
  String? _idCategoria;

  Future<void> _aplicarFiltros() async {
    await ref.read(zapatoControllerProvider.notifier).filtrarPorRelacion(
          idMarca: _idMarca,
          idCategoria: _idCategoria,
        );
    if (mounted) Navigator.pop(context);
  }

  Future<void> _limpiarFiltros() async {
    await ref.read(zapatoControllerProvider.notifier).filtrarPorRelacion();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Filtrar Catálogo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          PagedPickerField(
            label: 'Marca',
            icon: Icons.sell_outlined,
            hint: 'Todas las marcas',
            clearable: true,
            value: _idMarca,
            fetch: catalogFetch(ref, store: SembastStores.marca, field: 'nombreMarca'),
            resolve: catalogResolve(ref, store: SembastStores.marca, field: 'nombreMarca'),
            onChanged: (value) => setState(() => _idMarca = value),
          ),
          const SizedBox(height: AppSpacing.md),
          PagedPickerField(
            label: 'Categoría',
            icon: Icons.category_outlined,
            hint: 'Todas las categorías',
            clearable: true,
            value: _idCategoria,
            fetch: catalogFetch(
              ref,
              store: SembastStores.categoriaZapato,
              field: 'nombreCategoria',
            ),
            resolve: catalogResolve(
              ref,
              store: SembastStores.categoriaZapato,
              field: 'nombreCategoria',
            ),
            onChanged: (value) => setState(() => _idCategoria = value),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _limpiarFiltros,
                  child: Text('Limpiar', style: TextStyle(color: context.softInk)),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _aplicarFiltros,
                  icon: const Icon(Icons.filter_alt_outlined),
                  label: const Text('Aplicar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.brand,
                    foregroundColor: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
