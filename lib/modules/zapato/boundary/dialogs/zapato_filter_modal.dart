import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/modules/categoria_zapato/controllers/categoria_zapato_controller.dart';
import 'package:variedadesjm/modules/marca/controller/marca_controller.dart';
import 'package:variedadesjm/modules/zapato/controller/zapato_controller.dart';
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
    final marcas = ref.watch(marcasCatalogoProvider);
    final categorias = ref.watch(categoriasZapatoCatalogoProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.white,
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
          _buildDropdown(
            label: 'Marca',
            hint: 'Todas las marcas',
            value: _idMarca,
            data: marcas,
            name: (item) => item.nombreMarca,
            onChanged: (value) => setState(() => _idMarca = value),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildDropdown(
            label: 'Categoría',
            hint: 'Todas las categorías',
            value: _idCategoria,
            data: categorias,
            name: (item) => item.nombreCategoria,
            onChanged: (value) => setState(() => _idCategoria = value),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _limpiarFiltros,
                  child: const Text('Limpiar', style: TextStyle(color: AppColors.graphite)),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _aplicarFiltros,
                  icon: const Icon(Icons.filter_alt_outlined),
                  label: const Text('Aplicar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brand,
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

  Widget _buildDropdown<T>({
    required String label,
    required String hint,
    required String? value,
    required AsyncValue<List<T>> data,
    required String Function(T) name,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: AppSpacing.xs),
        data.when(
          loading: () => const LinearProgressIndicator(),
          error: (error, _) => Text('No se pudo cargar $label: $error'),
          data: (items) => DropdownButtonFormField<String>(
            initialValue: value,
            isExpanded: true,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            hint: Text(hint),
            items: items
                .map((item) => DropdownMenuItem<String>(value: (item as dynamic).id as String, child: Text(name(item))))
                .toList(),
            onChanged: items.isEmpty ? null : onChanged,
          ),
        ),
      ],
    );
  }
}
