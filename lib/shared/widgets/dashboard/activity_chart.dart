import 'package:flutter/material.dart';

/// Gráfica de barras ligera, sin dependencia externa, para resumir actividad.
class ActivityChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;

  const ActivityChart({super.key, required this.values, required this.labels});

  @override
  Widget build(BuildContext context) {
    final maxValue = values.fold<double>(1, (max, value) => value > max ? value : max);
    final color = Theme.of(context).colorScheme.primary;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Actividad de ventas', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            SizedBox(
              height: 150,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(values.length, (index) {
                  final height = 18 + (values[index] / maxValue) * 105;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 24,
                        height: height,
                        decoration: BoxDecoration(
                          color: index == values.length - 1 ? color : color.withValues(alpha: .35),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(labels[index], style: Theme.of(context).textTheme.labelSmall),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
