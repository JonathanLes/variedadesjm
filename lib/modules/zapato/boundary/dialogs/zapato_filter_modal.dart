import 'package:flutter/material.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/themes/spacing.dart';

class ZapatoFilterModal extends StatelessWidget {
  const ZapatoFilterModal({super.key});

  /// Muestra el modal de filtros deslizable desde la parte inferior para el catálogo de zapatos.
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ZapatoFilterModal(),
    );
  }

  /// Limpia los filtros activos del catálogo y cierra el modal.
  void _limpiarFiltros(BuildContext context) {
    Navigator.pop(context);
  }

  /// Aplica los filtros de marca y categoría, y cierra el modal.
  void _aplicarFiltros(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
          const Text('Marca', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.xs),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: const [],
            onChanged: (val) {},
            hint: const Text('Todas las marcas'),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text('Categoría', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.xs),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: const [],
            onChanged: (val) {},
            hint: const Text('Todas las categorías'),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _limpiarFiltros(context),
                  child: const Text('Limpiar', style: TextStyle(color: AppColors.graphite)),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _aplicarFiltros(context),
                  icon: const Icon(Icons.filter_alt_outlined),
                  label: const Text('Aplicar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.racingRed,
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