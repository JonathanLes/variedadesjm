import 'package:flutter/material.dart';

/// Botón (?) del encabezado: abre una guía rápida de las acciones principales.
class AppHelpButton extends StatelessWidget {
  const AppHelpButton({super.key});

  static const _pasos = <(IconData, String, String)>[
    (Icons.add_circle_outline_rounded, 'Registrar una venta o reserva',
        'Toca el botón + y elige "Nueva venta" o "Nueva reserva".'),
    (Icons.inventory_2_outlined, 'Agregar zapatos',
        'En Inventario toca "Registrar par". Cada par lleva un código para encontrarlo rápido.'),
    (Icons.receipt_long_outlined, 'Anotar un gasto',
        'En Gastos toca uno frecuente (Comida, Uber, Gasolina) o escribe uno nuevo.'),
    (Icons.insights_rounded, 'Ver cómo va el negocio',
        'En Gráficas ves lo más vendido; en el menú, Finanzas muestra ganancias y razones.'),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return IconButton(
      tooltip: 'Ayuda',
      icon: Icon(Icons.help_outline_rounded, size: 26, color: scheme.primary),
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (sheetContext) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Guía rápida',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                for (final (icon, title, text) in _pasos)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 19,
                          backgroundColor: scheme.primary.withValues(alpha: .1),
                          child: Icon(icon, color: scheme.primary, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(title,
                                  style: const TextStyle(
                                      fontSize: 14.5, fontWeight: FontWeight.w800)),
                              const SizedBox(height: 2),
                              Text(text, style: const TextStyle(fontSize: 13)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
