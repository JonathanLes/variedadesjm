import 'package:flutter/material.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/themes/spacing.dart';

/// Define las opciones de ordenamiento disponibles en la aplicación.
enum AppSortOption {
  /// Orden ascendente (De la A a la Z, o del más antiguo al más reciente)
  asc,
  
  /// Orden descendente (De la Z a la A, o del más reciente al más antiguo)
  desc,
}

/// Un widget de filtro de ordenamiento genérico estilo Dropdown.
///
/// Muestra un botón con bordes redondeados que, al ser presionado,
/// despliega un menú flotante con las opciones de ordenamiento (A-Z y Z-A).
/// El diseño está pensado para no desplazar el contenido inferior al abrirse.
class AppSortFilter extends StatelessWidget {
  /// La opción de ordenamiento actualmente seleccionada.
  final AppSortOption selectedOption;

  /// Callback que se ejecuta cuando el usuario selecciona una nueva opción.
  final ValueChanged<AppSortOption> onChanged;

  /// Crea una instancia de [AppSortFilter].
  const AppSortFilter({
    super.key,
    required this.selectedOption,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<AppSortOption>(
      onSelected: onChanged,
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
      itemBuilder: (BuildContext context) => <PopupMenuEntry<AppSortOption>>[
        PopupMenuItem<AppSortOption>(
          value: AppSortOption.asc,
          child: Row(
            children: [
              Icon(
                Icons.arrow_downward,
                color: selectedOption == AppSortOption.asc 
                    ? AppColors.racingRed 
                    : AppColors.graphite,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'De la A a la Z',
                style: TextStyle(
                  color: selectedOption == AppSortOption.asc 
                      ? AppColors.racingRed 
                      : AppColors.graphite,
                  fontWeight: selectedOption == AppSortOption.asc 
                      ? FontWeight.bold 
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem<AppSortOption>(
          value: AppSortOption.desc,
          child: Row(
            children: [
              Icon(
                Icons.arrow_upward,
                color: selectedOption == AppSortOption.desc 
                    ? AppColors.racingRed 
                    : AppColors.graphite,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'De la Z a la A',
                style: TextStyle(
                  color: selectedOption == AppSortOption.desc 
                      ? AppColors.racingRed 
                      : AppColors.graphite,
                  fontWeight: selectedOption == AppSortOption.desc 
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