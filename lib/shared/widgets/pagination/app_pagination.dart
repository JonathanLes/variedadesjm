import 'dart:math';
import 'package:flutter/material.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/themes/spacing.dart';

/// Un widget de paginación universal con controles de navegación avanzados.
///
/// Muestra botones para ir al inicio, final, página anterior y siguiente,
/// además de generar dinámicamente los números de página. Si la cantidad 
/// de páginas es grande, incluye puntos suspensivos (...) de forma automática.
class AppPagination extends StatelessWidget {
  /// La página actual en la que se encuentra el usuario.
  final int currentPage;

  /// La cantidad total de registros en la base de datos para la consulta actual.
  final int totalItems;

  /// La cantidad de registros que se muestran por cada página.
  final int pageSize;

  /// El nombre de la entidad en plural (ej. 'marcas', 'productos') para el texto de resumen.
  final String itemName;

  /// Callback que se ejecuta cuando el usuario selecciona una nueva página.
  final ValueChanged<int> onPageChanged;

  /// Crea una instancia de [AppPagination].
  const AppPagination({
    super.key,
    required this.currentPage,
    required this.totalItems,
    this.pageSize = 10,
    this.itemName = 'registros',
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Cálculo total de páginas (redondeado hacia arriba)
    final int totalPages = max(1, (totalItems / pageSize).ceil());
    
    // Si no hay elementos o solo hay una página, opcionalmente podrías ocultar todo,
    // pero lo mantendremos visible con los controles deshabilitados para mantener el layout.
    
    // Cálculo para el texto descriptivo ("Mostrando X a Y de Z marcas")
    final int startItem = totalItems == 0 ? 0 : ((currentPage - 1) * pageSize) + 1;
    final int endItem = min(currentPage * pageSize, totalItems);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Barra de controles de paginación
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Botón Primera Página (<<)
            _NavigationButton(
              icon: Icons.keyboard_double_arrow_left,
              onPressed: currentPage > 1 ? () => onPageChanged(1) : null,
            ),
            const SizedBox(width: AppSpacing.xs),
            
            // Botón Página Anterior (<)
            _NavigationButton(
              icon: Icons.chevron_left,
              onPressed: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
            ),
            
            const SizedBox(width: AppSpacing.sm),
            
            // Lista dinámica de números de página
            ..._buildPageNumbers(totalPages),
            
            const SizedBox(width: AppSpacing.sm),
            
            // Botón Página Siguiente (>)
            _NavigationButton(
              icon: Icons.chevron_right,
              onPressed: currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null,
            ),
            const SizedBox(width: AppSpacing.xs),
            
            // Botón Última Página (>>)
            _NavigationButton(
              icon: Icons.keyboard_double_arrow_right,
              onPressed: currentPage < totalPages ? () => onPageChanged(totalPages) : null,
            ),
          ],
        ),
        
        const SizedBox(height: AppSpacing.md),
        
        // 2. Texto de resumen
        Text(
          'Mostrando $startItem a $endItem de $totalItems $itemName',
          style: const TextStyle(
            color: AppColors.graphite,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Lógica matemática para generar los botones de números y los puntos suspensivos.
  List<Widget> _buildPageNumbers(int totalPages) {
    final List<Widget> pages = [];
    
    // Lógica para mostrar siempre un máximo de 5 elementos visibles entre números y "..."
    for (int i = 1; i <= totalPages; i++) {
      if (totalPages <= 5 || 
          i == 1 || 
          i == totalPages || 
          (i >= currentPage - 1 && i <= currentPage + 1)) {
        
        pages.add(_PageNumberButton(
          pageNumber: i,
          isActive: i == currentPage,
          onPressed: () => onPageChanged(i),
        ));
      } else if (i == currentPage - 2 || i == currentPage + 2) {
        // Añade los puntos suspensivos si corresponde
        if (pages.isNotEmpty && pages.last is! _EllipsisWidget) {
          pages.add(const _EllipsisWidget());
        }
      }
    }
    return pages;
  }
}

// -----------------------------------------------------------------------------
// WIDGETS PRIVADOS AUXILIARES (Solo viven y se usan dentro de este archivo)
// -----------------------------------------------------------------------------

/// Botón para los íconos de navegación (flechas).
class _NavigationButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _NavigationButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null;
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        child: Icon(
          icon,
          size: 24,
          color: isDisabled ? AppColors.grey.withOpacity(0.4) : AppColors.black,
        ),
      ),
    );
  }
}

/// Botón numérico para cada página.
class _PageNumberButton extends StatelessWidget {
  final int pageNumber;
  final bool isActive;
  final VoidCallback onPressed;

  const _PageNumberButton({
    required this.pageNumber,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isActive ? null : onPressed,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isActive ? AppColors.racingRed : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          pageNumber.toString(),
          style: TextStyle(
            color: isActive ? AppColors.white : AppColors.black,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

/// Widget sencillo para los puntos suspensivos.
class _EllipsisWidget extends StatelessWidget {
  const _EllipsisWidget();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: Text(
        '...',
        style: TextStyle(
          color: AppColors.graphite,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
        ),
      ),
    );
  }
}