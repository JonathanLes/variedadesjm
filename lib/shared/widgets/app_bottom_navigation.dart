import 'package:flutter/material.dart';
import '../themes/colors.dart';
import '../themes/spacing.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemTapped; 

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.black,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home, 'Inicio'),
            _buildNavItem(1, Icons.sell_outlined, 'Ventas'),
            _buildNavItem(2, Icons.monetization_on_outlined, 'Gastos'),
            _buildNavItem(3, Icons.inventory_2_outlined, 'Inventario'), 
            _buildNavItem(4, Icons.pie_chart_outline, 'Reporte'),
          ],
        ),
      ),
    );
  }

  // Método auxiliar para construir cada botón individualmente
  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = currentIndex == index;
    final color = isSelected ? AppColors.racingRed : AppColors.white;

    return Expanded(
      child: GestureDetector(
        onTap: () => onItemTapped(index),
        behavior: HitTestBehavior.opaque, // Para que todo el área sea clickeable
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. La línea roja indicadora en la parte superior
            Container(
              height: 3,
              color: isSelected ? AppColors.racingRed : Colors.transparent,
            ),
            const SizedBox(height: AppSpacing.sm),
            
            // 2. El ícono
            Icon(icon, color: color, size: 24),
            const SizedBox(height: AppSpacing.xs),
            
            // 3. El texto
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}