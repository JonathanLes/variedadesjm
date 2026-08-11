import 'package:flutter/material.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/themes/spacing.dart';
import 'package:variedadesjm/shared/models/filter_params.dart';

/// Un widget de filtro de ordenamiento genérico estilo Dropdown.
///
/// Muestra un botón con bordes redondeados que, al ser presionado,
/// despliega un menú flotante con las opciones de ordenamiento (A-Z y Z-A).
/// El diseño está pensado para no desplazar el contenido inferior al abrirse.
class AppSortFilter extends StatelessWidget {
  /// La dirección de ordenamiento actualmente seleccionada.
  final SortDirection currentSort;

  /// Callback que se ejecuta cuando el usuario selecciona una nueva opción.
  final ValueChanged<SortDirection> onSortChanged;

  /// Crea una instancia de [AppSortFilter].
  const AppSortFilter({
    super.key,
    required this.currentSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SortDirection>(
      onSelected: onSortChanged,
      // Desplaza un poco el menú hacia abajo para que no cubra el botón
      offset: const Offset(0, 45),
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        side: BorderSide(color: AppColors.grey.withOpacity(0.2)),
      ),
      elevation: 4,
      // Construimos el botón visible
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 12.0,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(color: AppColors.grey.withOpacity(0.5), width: 1.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Se adapta al contenido
          children: [
            // Ícono representativo de ordenamiento
            const Icon(
              Icons.sort_by_alpha,
              color: AppColors.graphite,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.sm),
            const Text(
              'Ordenar',
              style: TextStyle(
                color: AppColors.graphite,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            const Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.graphite,
              size: 20,
            ),
          ],
        ),
      ),
      // Construimos las opciones del menú desplegable
      itemBuilder: (BuildContext context) => <PopupMenuEntry<SortDirection>>[
        PopupMenuItem<SortDirection>(
          value: SortDirection.asc,
          child: Row(
            children: [
              Icon(
                Icons.arrow_downward,
                color: currentSort == SortDirection.asc 
                    ? AppColors.racingRed 
                    : AppColors.graphite,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'De la A a la Z',
                style: TextStyle(
                  color: currentSort == SortDirection.asc 
                      ? AppColors.racingRed 
                      : AppColors.graphite,
                  fontWeight: currentSort == SortDirection.asc 
                      ? FontWeight.bold 
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem<SortDirection>(
          value: SortDirection.desc,
          child: Row(
            children: [
              Icon(
                Icons.arrow_upward,
                color: currentSort == SortDirection.desc 
                    ? AppColors.racingRed 
                    : AppColors.graphite,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'De la Z a la A',
                style: TextStyle(
                  color: currentSort == SortDirection.desc 
                      ? AppColors.racingRed 
                      : AppColors.graphite,
                  fontWeight: currentSort == SortDirection.desc 
                      ? FontWeight.bold 
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}