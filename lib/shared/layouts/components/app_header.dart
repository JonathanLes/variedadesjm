import 'package:flutter/material.dart';
import 'app_help_button.dart';

/// Encabezado claro de la app: menú, nombre del negocio y notificaciones.
class AppHeader extends StatelessWidget {
  final String title;

  const AppHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(
          bottom: BorderSide(color: scheme.outlineVariant.withValues(alpha: .6)),
        ),
      ),
      child: Row(
        children: [
          Builder(
            builder: (context) => IconButton(
              tooltip: 'Abrir menú',
              icon: Icon(Icons.menu_rounded, size: 26, color: scheme.primary),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          Expanded(
            child: Text(
              'Variedades JM',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: scheme.primary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const AppHelpButton(),
        ],
      ),
    );
  }
}
