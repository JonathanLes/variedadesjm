import 'package:flutter/material.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/themes/spacing.dart';
// Se asume la ruta correcta de tu AppSearchBar
// import 'package:variedadesjm/shared/widgets/app_search_bar.dart'; 

class InventarioFilterModal extends StatelessWidget {
  const InventarioFilterModal({super.key});

  /// Muestra el modal de filtros deslizable desde la parte inferior de la pantalla.
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const InventarioFilterModal(),
    );
  }

  /// Limpia los filtros activos y cierra el modal.
  void _limpiarFiltros(BuildContext context) {
    // TODO: Lógica para limpiar filtros en el controlador Riverpod
    Navigator.pop(context);
  }

  /// Aplica los filtros seleccionados, ejecuta la búsqueda y cierra el modal.
  void _aplicarFiltros(BuildContext context) {
    // TODO: Lógica para aplicar filtros en el controlador Riverpod
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
              const Text(
                'Filtros avanzados',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Text('Búsqueda general', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.xs),
          // AppSearchBar(onChanged: (val) {}, hintText: 'Buscar por código o color...'),
          const SizedBox(height: AppSpacing.md),
          const Text('Modelo de zapato', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.xs),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: const [],
            onChanged: (val) {},
            hint: const Text('Todos los modelos'),
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
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}