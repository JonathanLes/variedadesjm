import 'package:flutter/material.dart';

/// Barra inferior flotante con las cuatro secciones principales.
///
/// [currentIndex] y [onItemTapped] usan el número de página del layout
/// (0 Inicio, 2 Gastos, 3 Inventario, 4 Gráficas), no la posición en pantalla.
class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
  });

  static const _items = <_NavItem>[
    _NavItem(0, Icons.home_outlined, Icons.home_rounded, 'Inicio'),
    _NavItem(3, Icons.inventory_2_outlined, Icons.inventory_2_rounded, 'Inventario'),
    _NavItem(2, Icons.receipt_long_outlined, Icons.receipt_long_rounded, 'Gastos'),
    _NavItem(4, Icons.bar_chart_outlined, Icons.bar_chart_rounded, 'Gráficas'),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 6, 14, 10),
        child: Container(
          height: 62,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(31),
            border: Border.all(color: scheme.outlineVariant.withValues(alpha: .7)),
            boxShadow: const [
              BoxShadow(color: Color(0x1A000000), blurRadius: 14, offset: Offset(0, 4)),
            ],
          ),
          child: Row(
            children: [
              for (final item in _items)
                Expanded(
                  child: _NavButton(
                    item: item,
                    selected: item.page == currentIndex,
                    onTap: () => onItemTapped(item.page),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final int page;
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem(this.page, this.icon, this.activeIcon, this.label);
}

class _NavButton extends StatelessWidget {
  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  const _NavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = selected ? Colors.white : scheme.primary;
    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          decoration: BoxDecoration(
            color: selected ? scheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(27),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(selected ? item.activeIcon : item.icon, color: color, size: 22),
              const SizedBox(height: 2),
              Text(
                item.label,
                maxLines: 1,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
