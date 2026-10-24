import 'package:flutter/material.dart';

/// Selector de opciones en forma de píldora (Semana | Mes | Año).
///
/// Es una alternativa a `SegmentedButton` que no depende del tamaño mínimo de
/// los botones del tema, así que nunca rompe el diseño en filas o listas.
class PillSelector<T> extends StatelessWidget {
  final List<T> values;
  final List<String> labels;
  final T selected;
  final ValueChanged<T> onChanged;
  final Color? activeColor;

  const PillSelector({
    super.key,
    required this.values,
    required this.labels,
    required this.selected,
    required this.onChanged,
    this.activeColor,
  }) : assert(values.length == labels.length);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final active = activeColor ?? scheme.primary;
    return Container(
      height: 40,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          for (var i = 0; i < values.length; i++)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(values[i]),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: values[i] == selected ? active : Colors.transparent,
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: values[i] == selected
                          ? Colors.white
                          : scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
